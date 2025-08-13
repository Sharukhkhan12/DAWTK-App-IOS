//
//  LogoutViewController.swift
//  QR App
//
//  Created by MacBook Air on 30/07/2025.
//


import UIKit

class SuccessVC: UIViewController {

    @IBOutlet weak var L1: UILabel!
    
    @IBOutlet weak var L2: UILabel!
    
    @IBOutlet weak var C1: UILabel!
    @IBOutlet weak var grenview: UIView!
    @IBOutlet weak var boarderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        secondboarderView()
    }

   
    @IBAction func gotoStyle(_ sender: Any) {
        print("StyleOpen")
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "StyleVC") as? StyleVC {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        fontsixe() 
    }
    func secondboarderView()
    {
        boarderView.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        boarderView.layer.cornerRadius = 15
        boarderView.clipsToBounds = true
        boarderView.layer.borderWidth = 3.0
        grenview.layer.cornerRadius = 10
        grenview.clipsToBounds = true
        
        
    }
    func fontsixe() {
        let fonts: [UILabel] = [L1, L2, C1]
        for label in fonts {
            label.font = UIFont.systemFont(ofSize: 18)
        }
    }


}
