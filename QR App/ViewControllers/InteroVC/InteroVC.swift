//
//  SplashVC.swift
//  QR App
//
//  Created by MacBook Air on 29/07/2025.
//


import UIKit

class InteroVC: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!

    // MARK: - Properties

    let titleLabel = UILabel()

    // Constraints to animate
    var centerYConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    var titleTopConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        animateSplashIcon()
        
    }
    
    @IBAction func didTapEnglish(_ sender: Any) {
        navigateToLoginScreen()
    }
    
    
    @IBAction func didTapArabiv(_ sender: Any) {
        self.navigateToTabBarScreen()
    }
    
    
    // MARK: - Navigate TO Tab Bar Screen Controller
    
    private func navigateToTabBarScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC {
            tabBarVC.modalTransitionStyle = .crossDissolve
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true)
        }
    }
    
    
    // MARK: - Navigate to Login Screen
    private func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true)
        }
    }
    

    // MARK: - Animation

    func animateSplashIcon() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 0.5, animations: {
                self.titleLabel.alpha = 1
            }, completion: { _ in
                self.stackView.isHidden = false
                self.stackView.alpha = 0
                UIView.animate(withDuration: 0.5) {
                    self.stackView.alpha = 1
                }
            })
        }
    }
}
