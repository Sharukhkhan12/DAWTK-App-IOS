//
//  VerifiedEmailVC.swift
//  QR App
//
//  Created by Touheed khan on 01/06/2025.
//

import UIKit
import FirebaseAuth

class VerifiedEmailVC: UIViewController {

    @IBOutlet weak var useremailllbl: UILabel!
    
    var userModel: UserModel?
    var progressAllert = ProgressAlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let email = Auth.auth().currentUser?.email {
            useremailllbl.text = "Verification email sent to: \(email)"
        } else {
            useremailllbl.text = "No email found"
        }
    }

    @IBAction func didTapImVerified(_ sender: Any) {
        progressAllert.show()

        guard let currentUser = Auth.auth().currentUser else {
            progressAllert.dismiss()
            showAlert("No user logged in.")
            return
        }

        let storedUID = UserDefaults.standard.string(forKey: "recentSignUpUID")

        // Make sure current user matches the one who just signed up
        guard currentUser.uid == storedUID else {
            progressAllert.dismiss()
            showAlert("You are not the signed-up user. Please log in again.")
            return
        }

        FirebaseManager.shared.checkEmailVerified { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.progressAllert.dismiss()

                switch result {
                case .success(let isVerified):
                    if isVerified {
                        self.progressAllert.show()
                        self.saveUserInRealTimeDataBase()

                    } else {
                        self.showAlert("Email is not verified yet.")
                    }

                case .failure(let error):
                    self.showAlert("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    @IBAction func didTapBacktologin(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    // MARK: - Save User In RealTimeDataBase
    func saveUserInRealTimeDataBase() {
        userModel?.userId =  Auth.auth().currentUser?.uid ?? ""
        if let userModel = userModel {
          
            FirebaseManager.shared.saveUserModelUnderAuthUID(user: userModel) { result in
                switch result {
                case .success:
                    print("✅ User saved to Firebase")
                    
                    // ✅ Save to UserDefaults (shared instance)
                    UserModel.shared = userModel
                    print("✅ User saved to UserDefaults")
                    self.navigateToCardSelectedVC()
                case .failure(let error):
                    print("❌ Error saving user: \(error.localizedDescription)")
                }
            }
        } else {
            print("❌ userModel is nil")
        }
    }
    // MARK: - Show Alert
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Verification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
    
   
    
    
}

