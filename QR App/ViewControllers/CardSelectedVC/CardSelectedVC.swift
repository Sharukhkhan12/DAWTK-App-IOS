//
//  CardSelectedVC.swift
//  QR App
//
//  Created by Touheed khan on 01/06/2025.
//

import UIKit

class CardSelectedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapInvitationmaker(_ sender: Any) {
        self.navigateToPInvitaionCard()
    }
    
    @IBAction func didTapBuisnessCard(_ sender: Any) {
        self.navigateToParentCreatteCard()
    }
    
    
    
    // MARK: - Navigate To Invitaion Card
    
    private func navigateToPInvitaionCard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let invitationCardVC = storyboard.instantiateViewController(withIdentifier: "InvitationCardVC") as? InvitationCardVC {
            invitationCardVC.modalPresentationStyle = .fullScreen
            invitationCardVC.modalTransitionStyle = .crossDissolve
            present(invitationCardVC, animated: true)
        }
    }
    
    
    
    // MARK: - Navigate To ParentCreatteCard
    private func navigateToParentCreatteCard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let parentCreatteCard = storyboard.instantiateViewController(withIdentifier: "ParentCreatteCard") as? ParentCreatteCard {
            parentCreatteCard.modalPresentationStyle = .fullScreen
            parentCreatteCard.modalTransitionStyle = .crossDissolve
            present(parentCreatteCard, animated: true)
        }
    }
    
}
