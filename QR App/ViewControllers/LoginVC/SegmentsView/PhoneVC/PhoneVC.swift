//
//  PhoneVC.swift
//  QR App
//
//  Created by Touheed khan on 30/05/2025.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit


class PhoneVC: UIViewController {

    
    @IBOutlet weak var phoneNoTxtField: UITextField!
    var progressAllert = ProgressAlertView()
    
    fileprivate var currentNonce: String?
    var phoneNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ddiTapApple(_ sender: Any) {
        startSignInWithAppleFlow()
    }
    
    @IBAction func didTapgoogleSignIn(_ sender: Any) {
        // Ensure Firebase is configured and client ID is available
        self.googlesignIn()
    }
    
    func startSignInWithAppleFlow() {
           let nonce = randomNonceString()
           currentNonce = nonce
           let appleIDProvider = ASAuthorizationAppleIDProvider()
           let request = appleIDProvider.createRequest()
           request.requestedScopes = [.fullName, .email]
           request.nonce = sha256(nonce)

           let authorizationController = ASAuthorizationController(authorizationRequests: [request])
           authorizationController.delegate = self
           authorizationController.presentationContextProvider = self
           authorizationController.performRequests()
       }

    
    
    // MARK: - Nonce Helpers for Apple
    
    func googlesignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ Missing Firebase clientID")
            return
        }

        // Create GIDConfiguration
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Present Google Sign-In screen
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("❌ Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            // Ensure user and tokens are valid
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                print("❌ Missing token information")
                return
            }

            let accessToken = user.accessToken.tokenString

            // 🔐 Extract Custom Info
            let authId = user.userID ?? ""
            let authToken = idToken
            let profileUrl = user.profile?.imageURL(withDimension: 200)?.absoluteString ?? ""
            let email = user.profile?.email ?? ""
            let firstName = user.profile?.givenName ?? ""
            let lastName = user.profile?.familyName ?? ""

            // Firebase Credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            // Sign in with Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase Sign-In failed: \(error.localizedDescription)")
                    return
                }

                guard let firebaseUser = authResult?.user else {
                    print("❌ Firebase user not found")
                    return
                }

                // ✅ Create UserModel
                let userModel = UserModel(
                    accountType: "google",
                    authId: authId,
                    authPass: "",
                    authToken: authToken,
                    countryCode: "",
                    deleted: false,
                    deviceName:"IOS",
                    email: email,
                    fcmToken: "", // You can update this after FCM setup
                    firstName: firstName,
                    lastName: lastName,
                    phoneNo: "",
                    profileUrl: profileUrl,
                    userId: firebaseUser.uid
                )

                self.progressAlert.show()
                // ✅ Save to Firebase Realtime Database
                FirebaseManager.shared.saveUserModelUnderAuthUID(user: userModel) { result in
                    switch result {
                    case .success:
                        // ✅ Save locally
                        self.progressAlert.dismiss()
                        UserModel.shared = userModel
                        self.navigateToCardSelectedVC()
                        print("✅ User saved to Firebase and UserDefaults")
                    case .failure(let error):
                        print("❌ Failed to save user: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    // MARK: - Navigate To CardSelectedVC
    private func navigateToCardSelectedVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let cardSelectedVC = storyboard.instantiateViewController(withIdentifier: "CardSelectedVC") as? CardSelectedVC {
            cardSelectedVC.modalPresentationStyle = .fullScreen
            cardSelectedVC.modalTransitionStyle = .crossDissolve
            present(cardSelectedVC, animated: true)
        }
    }

    
    
    // MARK: - Nonce Helpers for Apple
        private func randomNonceString(length: Int = 32) -> String {
            precondition(length > 0)
            let charset: [Character] =
                Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
            var result = ""
            var remainingLength = length

            while remainingLength > 0 {
                let randoms: [UInt8] = (0..<16).map { _ in
                    var random: UInt8 = 0
                    let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                    if errorCode != errSecSuccess {
                        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with error code \(errorCode)")
                    }
                    return random
                }

                randoms.forEach { random in
                    if remainingLength == 0 {
                        return
                    }

                    if random < charset.count {
                        result.append(charset[Int(random)])
                        remainingLength -= 1
                    }
                }
            }

            return result
        }

        private func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashed = SHA256.hash(data: inputData)
            return hashed.compactMap { String(format: "%02x", $0) }.joined()
        }
    
    
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var progressAlert = ProgressAlertView()
    @IBAction func didTapRegister(_ sender: Any) {
        self.navigateToSignUpScreen()
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let number = phoneNoTxtField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !number.isEmpty else {
            showAlert(title: "Missing Number", message: "Please enter your phone number.")
            return
        }

        guard isValidPhoneNumber(number) else {
            showAlert(title: "Invalid Number", message: "Please enter a valid phone number in international format.\nExample: +923001234567")
            return
        }

        print("Sending OTP to:", number)
        progressAllert.show()

        FirebaseManager.shared.sendOTP(to: "+923055566563") { result in
            DispatchQueue.main.async {
                self.progressAllert.dismiss()
            }

            switch result {
            case .success(let verificationID):
                DispatchQueue.main.async {
                    self.navigateToPhoneVerificationVC(phoneNumber: number, verificationID: verificationID)
                }

            case .failure(let error):
                print("Failed to send OTP:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(title: "OTP Error", message: error.localizedDescription)
                }
            }
        }
    }

    
    
    // MARK: - isValid Phone Number
    func isValidPhoneNumber(_ number: String) -> Bool {
        let regex = "^\\+[1-9][0-9]{9,14}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: number)
    }



    
    // MARK: - Show Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    // MARK: - Navigate To Phone Verification VC

    private func navigateToPhoneVerificationVC(phoneNumber: String, verificationID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let phoneVerificationVC = storyboard.instantiateViewController(withIdentifier: "PhoneVerificationVC") as? PhoneVerificationVC {
            phoneVerificationVC.verificationID = verificationID
            phoneVerificationVC.prevoiusphoneNumber = phoneNumber
            phoneVerificationVC.modalPresentationStyle = .fullScreen
            phoneVerificationVC.modalTransitionStyle = .crossDissolve
            self.present(phoneVerificationVC, animated: true)
        }
    }

  
    // MARK: - Navigate Sign Up Controller
    
    private func navigateToSignUpScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let SignUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
            SignUpVC.modalTransitionStyle = .crossDissolve
            SignUpVC.modalPresentationStyle = .fullScreen
            present(SignUpVC, animated: true)
        }
    }

}
// MARK: - Apple Sign-In Delegates
extension PhoneVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: no login request sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("❌ Failed to fetch identity token.")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("❌ Failed to decode identity token.")
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)

            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("❌ Apple Sign-In failed: \(error.localizedDescription)")
                    return
                }

                print("✅ Successfully signed in with Apple and authenticated with Firebase")
                // Navigate to next screen
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple Sign-In Error: \(error.localizedDescription)")
    }
}
