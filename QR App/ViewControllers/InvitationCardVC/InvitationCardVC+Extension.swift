//
//  InvitationCardVC+Extension.swift
//  QR App
//
//  Created by Touheed khan on 19/08/2025.
//

import Foundation
import UIKit
extension InvitationCardVC {
    
    func setFormWIthUpdate(templateNo: String?) {
        guard let templateNo = templateNo else {
            print("❌ No selected index path.")
            return
        }

        switch templateNo {
        case "1":
          
            // Your custom logic for Template8CVC
            self.scrolHeightConst.constant = 830
            userSelectedProfileTemplate = false

        case "2":
            self.scrolHeightConst.constant = 830
            userSelectedProfileTemplate = false

            // Your custom logic for Template7CVC

        case "3":
            print("tempName: \"3\"")
            self.scrolHeightConst.constant = 830
            userSelectedProfileTemplate = false

            // Your custom logic for Template6CVC

        case "4":
            print("tempName: \"4\"")
            self.scrolHeightConst.constant = 940
            
            userSelectedProfileTemplate = true

            // Your custom logic for Template5CVC

        case "5":
            print("tempName: \"5\"")
            self.scrolHeightConst.constant = 940
            userSelectedProfileTemplate = true

            // Your custom logic for Template4CVC

        case "6":
            self.scrolHeightConst.constant = 940
            print("tempName: \"6\"") // skipping CVC6
            
            userSelectedProfileTemplate = true

            // Your custom logic for Template3CVC

        case "7":
            print("tempName: \"7\"")
            self.scrolHeightConst.constant = 830
            userSelectedProfileTemplate = false
            
            
        case "8":
            print("tempName: \"8\"")
            self.scrolHeightConst.constant = 830
            userSelectedProfileTemplate = false

            // Your custom logic for Template4CVC

        case "9":
   
            print("tempName: \"9\"")
            userSelectedProfileTemplate = true
            self.scrolHeightConst.constant = 910
            self.updateUIForm()
            // Your custom logic for Template3CVC

        case "10":
           
            print("tempName: \"10\"")
            self.scrolHeightConst.constant = 830
            userSelectedProfileTemplate = false
            self.updateUIForm()
            
        case "11":

            print("tempName: \"11\"")
            self.scrolHeightConst.constant = 830
            userSelectedProfileTemplate = false
            self.updateUIForm()
            // Your custom logic for Template4CVC

        case "12":
   
            print("tempName: \"12\"")
            self.scrolHeightConst.constant = 830
            userSelectedProfileTemplate = false
            self.updateUIForm()
            // Your custom logic for Template3CVC

        case "13":
           
            self.scrolHeightConst.constant = 830
            userSelectedProfileTemplate = false
            print("tempName: \"13\"")
            self.updateUIForm()
            // Your custom logic for Template2CVC

        default:
            print("⚠️ Unknown template identifier: ")
        }
        
        self.fetchSelectedInviationCard()
        
        
    }
    
    
    func fetchSelectedInviationCard() {
        
        DispatchQueue.main.async {
            self.progressAllert.show()
            self.invitation = self.updatedModel
            self.userFromCardScreen = true
            if self.userSelectedProfileTemplate {
                
                if let url = URL(string: self.updatedModel.profilePhotoPath) {
                    self.selectedImageURLFromProfileURL = url
                    self.loadImage(from: self.updatedModel.profilePhotoPath) { image in
                        self.profileImage = image
                        self.progressAllert.dismiss()
                        self.invitationCardTV.reloadData()
                    }
                }
            } else {
                self.invitationCardTV.reloadData()
                self.locationTxtField.isHidden = false
                self.locationTxtField.text =  self.invitation.locationLink
                self.progressAllert.dismiss()
            
            }
        }
     
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                completion(nil)
                return
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
}
