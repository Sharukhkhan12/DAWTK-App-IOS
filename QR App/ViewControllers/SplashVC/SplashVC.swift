//
//  ViewController.swift
//  QR App
//
//  Created by Touheed khan on 30/05/2025.
//

import UIKit

class SplashVC: UIViewController {


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = UserModel.shared {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                print("✅ User is already saved locally:")
                print("Email: \(currentUser.email)")
                self.navigateToTabBarScreen()
            }
            
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                print("❌ No user found in UserDefaults")
                self.navigateToInterScreen()
            }
            
            
           
            
        }
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
    // MARK: - Navigate to Intero Screen
    private func navigateToInterScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let interoVC = storyboard.instantiateViewController(withIdentifier: "InteroVC") as? InteroVC {
            interoVC.modalTransitionStyle = .crossDissolve
            interoVC.modalPresentationStyle = .fullScreen
            present(interoVC, animated: true)
        }
    }
}
