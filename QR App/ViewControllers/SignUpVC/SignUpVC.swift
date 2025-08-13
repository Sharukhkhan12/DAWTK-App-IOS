//
//  SignUpVC.swift
//  QR App
//
//  Created by Touheed khan on 30/05/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {

    @IBOutlet weak var phonenoTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var conFormPasswordTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var firstNameTxtField: UITextField!

    var progressAlert = ProgressAlertView()
    var userModel: UserModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissGesture()
    }

    // MARK: - Dismiss Keyboard
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func didTapLoginBack(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func didTapSubmit(_ sender: Any) {
        registerUser()
//
//        navigateToHomeScreen()
    }

    private func registerUser() {
        guard let firstName = firstNameTxtField.text, !firstName.isEmpty,
              let lastName = lastNameTxtField.text, !lastName.isEmpty,
              let email = emailTxtField.text, !email.isEmpty,
              let phone = phonenoTxtField.text, !phone.isEmpty,
              let password = passwordTxtField.text, !password.isEmpty,
              let confirmPassword = conFormPasswordTxtField.text, !confirmPassword.isEmpty else {
            showAlert("Please fill in all fields.")
            return
        }

        guard password == confirmPassword else {
            showAlert("Passwords do not match.")
            return
        }

        userModel = UserModel(accountType: "standard", authId: "", authPass: password, authToken: "", countryCode: phone, deleted: false, deviceName: "IOS", email: email, fcmToken: "", firstName: firstName, lastName: lastName, phoneNo: phone, profileUrl: "", userId: "")
        self.signUpAuth(email: email, password: password, firstName: firstName, lastName: lastName, phone: phone)
        progressAlert.show()
    }
    
    
    func signUpAuth(email: String, password: String, firstName: String, lastName: String, phone: String) {
        FirebaseManager.shared.signUpUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.progressAlert.dismiss()
                switch result {
                case .success(let authResult):
                    let uid = authResult.user.uid
                    UserDefaults.standard.set(uid, forKey: "recentSignUpUID")

                    FirebaseManager.shared.sendVerificationEmail { verifyResult in
                        DispatchQueue.main.async {
                            switch verifyResult {
                            case .success:
                                self.navigateToVerificationScreen()
                            case .failure(let error):
                                self.showAlert("Verification email failed: \(error.localizedDescription)")
                            }
                        }
                    }
                case .failure(let error):
                    let nsError = error as NSError
                    if let errCode = AuthErrorCode(rawValue: nsError.code), errCode == .emailAlreadyInUse {
                        self.showAlert("This email is already registered. Please try logging in.")
                    } else {
                        self.showAlert("Signup failed: \(error.localizedDescription)")
                    }

                }
            }
        }
    }


    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Signup", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func navigateToVerificationScreen() {
        if let user = userModel {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let verifiedVC = storyboard.instantiateViewController(withIdentifier: "VerifiedEmailVC") as? VerifiedEmailVC {
                verifiedVC.modalPresentationStyle = .fullScreen
                verifiedVC.userModel = user
                present(verifiedVC, animated: true)
            }

        }
    }
    
    
    private func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC {
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            present(homeVC, animated: true)
        }
    }
}
