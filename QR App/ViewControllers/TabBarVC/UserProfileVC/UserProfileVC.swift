//
//  ProfileVC.swift
//  QRScan
//
//  Created by iMac on 19/07/2025.
//

import UIKit

class UserProfileVC: UIViewController {

    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var Bordercolr: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loop()
    }
    
    
    
    @IBAction func ddiTapChengeLanguage(_ sender: Any) {
        if UIView.appearance().semanticContentAttribute == .forceLeftToRight {
            // Switch to Right-to-Left
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            // Switch back to Left-to-Right
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }

        // Reload the root view to apply layout changes
        navigateToTabBarScreen()
    }
    
    @IBAction func AccountButn(_ sender: UIButton) {
        print("AccountOpen")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC") as? AccountVC {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }

    }
    func loop(){
        let views: [UIView] = [Bordercolr, v1, v2, v3]
        
        for view in views {
            view.layer.cornerRadius = 10
            
            view.layer.borderWidth = 2.0
            view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            view.layer.masksToBounds = true
        }}


    private func navigateToTabBarScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC {
            tabBarVC.modalTransitionStyle = .crossDissolve
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true)
        }
    }
   

}
