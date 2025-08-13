//
//  ConformVC.swift
//  QR App
//
//  Created by Touheed khan on 30/05/2025.
//

import UIKit

class ConformVC: UIViewController {

    @IBOutlet weak var forgetpasslbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Enable interaction on the label
        forgetpasslbl.isUserInteractionEnabled = true
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapForgetPassword))
        forgetpasslbl.addGestureRecognizer(tapGesture)
       // Do any additional setup after loading the view.
    }
    
    
    @objc private func didTapForgetPassword() {
        print("Forget password tapped")
        self.navigateToForgetScreen()
        // Navigate or perform action here
        // e.g., navigateToForgotPasswordScreen()
    }

    @IBAction func didTapVerify(_ sender: Any) {
       
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
