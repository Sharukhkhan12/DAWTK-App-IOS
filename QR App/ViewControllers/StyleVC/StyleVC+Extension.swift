//
//  StyleVC+Extension.swift
//  QR App
//
//  Created by Touheed khan on 20/08/2025.
//

import Foundation
import UIKit
extension StyleVC {
    func loadSelectedInvitationCardView(in container: UIView, completion: @escaping (UIView?) -> Void) {
        guard let templateName = userCard?.templateName else {
            print("❌ No template name in cardInfo")
            completion(nil)
            return
        }

        // 🔄 Add activity indicator to container view
        progressAlert.show()

        let group = DispatchGroup()
     

        
        var view: UIView?
        // 🔄 Add activity indicator
        
        group.notify(queue: .main) {
            
            switch templateName {
            case "1":
                print("tempName: \"1\"")
                
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC1", owner: nil, options: nil)?.first as? InvitationTemplatesCVC1 {
                    
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                   
                }
                
                
            case "2":
                print("tempName: \"2\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC2", owner: nil, options: nil)?.first as? InvitationTemplatesCVC2 {
                   
                    
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                    
                }
                
                
            case "3":
                print("tempName: \"3\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC3", owner: nil, options: nil)?.first as? InvitationTemplatesCVC3 {
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
               
                }
            case "4":
                print("tempName: \"4\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC4", owner: nil, options: nil)?.first as? InvitationTemplatesCVC4 {
                    
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                    
                 
                }
                
            case "5":
                print("tempName: \"5\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC5", owner: nil, options: nil)?.first as? InvitationTemplatesCVC5 {
                    
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                    
                  
                }
                
            case "6":
                print("tempName: \"6\"") // skipping CVC6
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC7", owner: nil, options: nil)?.first as? InvitationTemplatesCVC7 {
                    
                    
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                    
                   
                }
            case "7":
                print("tempName: \"7\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC8", owner: nil, options: nil)?.first as? InvitationTemplatesCVC8 {
                    
                    
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                    
               
                }
                
            case "8":
                print("tempName: \"8\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC9", owner: nil, options: nil)?.first as? InvitationTemplatesCVC9 {
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                }
                
            case "9":
                print("tempName: \"9\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC10", owner: nil, options: nil)?.first as? InvitationTemplatesCVC10 {
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                }
                
            case "10":
                print("tempName: \"10\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC11", owner: nil, options: nil)?.first as? InvitationTemplatesCVC11 {
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                }
                
            case "11":
                print("tempName: \"11\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC12", owner: nil, options: nil)?.first as? InvitationTemplatesCVC12 {
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                }
            case "12":
                print("tempName: \"12\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC13", owner: nil, options: nil)?.first as? InvitationTemplatesCVC13 {
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                }
            case "13":
                print("tempName: \"13\"")
                
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC14", owner: nil, options: nil)?.first as? InvitationTemplatesCVC14 {
                    cell.configure(with: self.userCard, userFromViewScreen: true)
                    view = cell
                }
                
            default:
                print("Unknown template")
                
            }
            self.progressAlert.dismiss()
            completion(view)
            
            
        }
    }
    
    
    func loadTheInvitationView() {
        loadSelectedInvitationCardView(in: self.ViewScreen) { [weak self] templateView in
            guard let self = self, let templateView = templateView else { return }

            // Clear previous preview
            self.ViewScreen.subviews.forEach { $0.removeFromSuperview() }

            // Add the selected template view
            self.ViewScreen.addSubview(templateView)
            self.selectedTemplateView = templateView // ← ✅ Assign here

            // Force layout before scaling
            self.ViewScreen.layoutIfNeeded()
            templateView.layoutIfNeeded()

            // 🔁 Auto scale to fit, if conforming
            if let scalable = templateView as? InvitationScalableCardView {
                scalable.scaleToFit(in: self.ViewScreen)
            }
        }
    }
    
    
    // MARK: - Navigate TO Invitation PreViee Controller
    
     func navigateToPreVieeScreen(invitationCard: InvitationModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let invitationPreViewVC = storyboard.instantiateViewController(withIdentifier: "InvitationPreViewVC") as? InvitationPreViewVC {
            invitationPreViewVC.modalTransitionStyle = .crossDissolve
            invitationPreViewVC.userCard = invitationCard
            invitationPreViewVC.userFromMyCardsScreen = true
            
            invitationPreViewVC.modalPresentationStyle = .fullScreen
            present(invitationPreViewVC, animated: true)
        }
    }
    
    
}
