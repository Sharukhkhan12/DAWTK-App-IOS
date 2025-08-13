//
//  PhoneVerificationVC.swift
//  QR App
//
//  Created by Touheed khan on 09/06/2025.
//

import UIKit
import AEOTPTextField


class PhoneVerificationVC: UIViewController {

    @IBOutlet weak var resendlbl: UILabel!
    @IBOutlet weak var enterPhoneNumberTextlbl: UILabel!
    @IBOutlet weak var otpTextField: AEOTPTextField!
    
    var prevoiusphoneNumber: String?
    var verificationID: String?
    var progressAllert = ProgressAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enterPhoneNumberTextlbl.text = "Enter the OTP sent to \(prevoiusphoneNumber ?? "")"
        self.otpSetUp()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Otp Set Up
    
    func otpSetUp() {
        otpTextField.layer.borderColor = UIColor.clear.cgColor
        otpTextField.otpDelegate = self
        otpTextField.otpFontSize = 16
        otpTextField.otpTextColor = .black
        otpTextField.otpDefaultBorderColor = .black
        otpTextField.otpCornerRaduis = 5
        otpTextField.otpDefaultBorderWidth = 0.5
        otpTextField.otpFilledBorderWidth = 0.5
        otpTextField.configure(with: 6)
    }
    
    
    
    
    @IBAction func didTapBackLogin(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapVerified(_ sender: Any) {
        guard let code = otpTextField.text, !code.isEmpty,
              let verificationID = verificationID else {
            return
        }

        progressAllert.show()
        
        FirebaseManager.shared.verifyOTP(verificationID: verificationID, verificationCode: code) { result in
            switch result {
            case .success(let authResult):
                self.progressAllert.dismiss()
                print("Phone Auth Success:", authResult.user.uid)
                self.navigateToHomeScreen()
                // Navigate to home or dashboard screen
                
            case .failure(let error):
                print("OTP Verification failed:", error.localizedDescription)
                // Show error alert
            }
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
    
}
extension PhoneVerificationVC: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print(code)
    }
}
