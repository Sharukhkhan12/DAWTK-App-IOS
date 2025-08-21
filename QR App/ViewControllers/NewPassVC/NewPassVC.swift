//
//  NewPassVC.swift
//  QR App
//
//  Created by Touheed khan on 21/08/2025.
//

import UIKit

class NewPassVC: UIViewController {
    @IBOutlet var bottomViewSheet: UIView!

    @IBOutlet var parentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        parentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

    }
    

    @IBAction func dismissScren(_ sender: UIButton) {
        UIView.animate(withDuration: 0.20, animations: {
               // Dono ko same transform apply kar rahe hain
               self.bottomViewSheet.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
              
           }) { _ in
               self.dismiss(animated: false)
           }
            }
   

}
