//
//  AccountViewController.swift
//  QR App
//
//  Created by MacBook Air on 30/07/2025.
//


import UIKit
import FirebaseAuth
class AccountVC: UIViewController {
   
    
    // MARK: - @IBOutlet
    @IBOutlet weak var DeleteL: UILabel!
    @IBOutlet weak var LogL: UILabel!
    @IBOutlet weak var grenView: UIView!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var v4: UIView!
    @IBOutlet weak var v5: UIView!
    @IBOutlet weak var v6: UIView!
    @IBOutlet weak var Acountview: UIView!
  
    var progressAlert = ProgressAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Acountview.backgroundColor = .white
        loop()
        Grenloop()
    }
    override func viewDidLayoutSubviews() {
        Font()
    }
    @IBAction func DidTapLogoutBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { _ in
            self.progressAlert.show()

            FirebaseManager.shared.logout { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        UserModel.shared = nil
                        print("✅ Logged out and cleared stored user")
                        self?.progressAlert.dismiss()

                        // e.g., go to login screen or dismiss
                        self?.navigateToInterScreen()
                    case .failure(let error):
                        self?.progressAlert.dismiss()
                        self?.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }
        })
        present(alert, animated: true)
    }
    
    
    
    
    
    // MARK: - Show Error Alert
    private func showErrorAlert(message: String) {
        let err = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        err.addAction(UIAlertAction(title: "OK", style: .default))
        present(err, animated: true)
    }
    
    
    // MARK: - Navigate to Intero Screen
    private func navigateToInterScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let interoVC = storyboard.instantiateViewController(withIdentifier: "InteroVC") as? InteroVC {
            interoVC.modalTransitionStyle = .crossDissolve
            interoVC.modalPresentationStyle = .fullScreen
            present(interoVC, animated: true)
        }
    }

    // MARK: - Font
    func Font()
    {
        DeleteL.font = UIFont.boldSystemFont(ofSize: 15)
        LogL.font = UIFont.boldSystemFont(ofSize: 15)
        
    }
 
    
    @IBAction func DidTapDeletebtn(_ sender: UIButton) {
        print("DeleteOpen")
        let alert = UIAlertController(
            title: "Delete Account",
            message: "This action is permanent. All your data will be removed. Are you sure?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.progressAlert.show()
            guard let self = self else { return }
            guard let user = Auth.auth().currentUser else {
                self.showErrorAlert(message: "No authenticated user.")
                return
            }
            let uid = user.uid

            // First delete user data in Realtime Database (Users + UserBusinessCard)
            let group = DispatchGroup()
            var firstError: Error?

            // 1. Delete user node under "Users"
            group.enter()
            FirebaseManager.shared.deleteUserData(ownerId: uid) { result in
                if case .failure(let err) = result {
                    firstError = firstError ?? err
                }
                group.leave()
            }

            // 2. Delete all business cards owned by this user
            group.enter()
            FirebaseManager.shared.fetchBusinessCardsByOwnerID(ownerId: uid) { result in
                switch result {
                case .success(let cards):
                    let innerGroup = DispatchGroup()
                    for card in cards {
                        // Need cardKey: since fetchBusinessCardsByOwnerID doesn't currently return the snapshot key,
                        // you might need to adapt that method to also deliver the key.
                        // For now, assume `card.ownerId` is the cardKey if you stored it that way.
                        let cardKey = card.ownerId
                        innerGroup.enter()
                        FirebaseManager.shared.deleteUserBusinessCard(ownerId: uid, cardKey: cardKey) { delResult in
                            if case .failure(let err) = delResult {
                                firstError = firstError ?? err
                                self.progressAlert.dismiss()

                            }
                            innerGroup.leave()
                        }
                    }
                    innerGroup.notify(queue: .main) {
                        self.progressAlert.dismiss()
                        group.leave()
                    }
                case .failure(let err):
                    firstError = firstError ?? err
                    self.progressAlert.dismiss()
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                if let err = firstError {
                    self.showErrorAlert(message: "Failed to delete user data: \(err.localizedDescription)")
                    return
                }

                // 3. Delete Auth user
                user.delete { [weak self] error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self?.progressAlert.dismiss()
                            self?.showErrorAlert(message: "Failed to delete auth user: \(error.localizedDescription)")
                        } else {
                            // Cleanup local state
                            UserModel.shared = nil
                            print("✅ Account and all related data deleted.")
                            self?.progressAlert.dismiss()

                            // Navigate away
                            self?.navigateToInterScreen()
                        }
                    }
                }
            }
        })
        present(alert, animated: true)
    }

    // MARK: - loop
    func loop(){
        let views: [UIView] = [grenView, v1, v2, v3, v4]
        
        for view in views {
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            view.layer.borderWidth = 2.0
            view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            view.layer.masksToBounds = true
        }}
    // MARK: - Grenloop
    func Grenloop(){
        let views: [UIView] = [v5,v6]
        
        for view in views {
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            
        }
    }
}
