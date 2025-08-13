//
//  EmailVC.swift
//  QR App
//
//  Created by Touheed khan on 30/05/2025.
//

import UIKit

class EmailVC: UIViewController {

    @IBOutlet weak var forgetlbl: UILabel!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    
    var progressAlert = ProgressAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable interaction on the label
        forgetlbl.isUserInteractionEnabled = true
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapForgetPassword))
        forgetlbl.addGestureRecognizer(tapGesture)
    }

    
    @IBAction func didTapEmial(_ sender: Any) {
        
        guard let email = emailTxtField.text, !email.isEmpty else { return }
           guard let password = passwordTxtField.text, !password.isEmpty else { return }
           self.progressAlert.show()
           FirebaseManager.shared.loginAndLoadUser(email: email, password: password) { result in
               DispatchQueue.main.async {
                   self.progressAlert.dismiss()
                   switch result {
                   case .success(let userModel):
                       print("✅ Login + user load successful for userId: \(userModel.userId)")
                       self.navigateToHomeScreen()
                   case .failure(let error):
                       self.showAlert("Login failed: \(error.localizedDescription)")
                   }
               }
           }
    }
    
    
    @IBAction func didTapRegister(_ sender: Any) {
        self.navigateToSignUpScreen()
    }
    
    // MARK: - Handle Forget Password Tap
    
    @objc private func didTapForgetPassword() {
        print("Forget password tapped")
        self.navigateToForgetScreen() 
        // Navigate or perform action here
        // e.g., navigateToForgotPasswordScreen()
    }
    
    // MARK: - Show Alert
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Verification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Navigate Sign Up Controller
    
    private func navigateToSignUpScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
            signUpVC.modalTransitionStyle = .crossDissolve
            signUpVC.modalPresentationStyle = .fullScreen
            present(signUpVC, animated: true)
        }
    }
    
    
    // MARK: - Navigate To HomeScreen
    private func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "CardSelectedVC") as? CardSelectedVC {
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            present(homeVC, animated: true)
        }
    }
    
    
    // MARK: - Navigate Forget Controller
    
    private func navigateToForgetScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let forgetVC = storyboard.instantiateViewController(withIdentifier: "ForgetVC") as? ForgetVC {
            forgetVC.modalTransitionStyle = .crossDissolve
            forgetVC.modalPresentationStyle = .fullScreen
            present(forgetVC, animated: true)
        }
    }
}
