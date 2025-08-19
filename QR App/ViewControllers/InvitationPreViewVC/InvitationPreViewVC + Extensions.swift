//
//  InvitationPreViewVC + Extensions.swift
//  QR App
//
//  Created by Touheed khan on 19/08/2025.
//

import Foundation
import UIKit
import FirebaseDatabase
extension InvitationPreViewVC {
    // MARK: - Save Card
    
    func savedCardWithProfile() {
        if var card = self.userCard {
            guard let profileImage = profileImage else { print("❌ Missing profile"); return }
            guard let templateImage = capturePreviewInvitationImage() else { print("❌ Failed to capture template image"); return }

            // Determine which QR image to use based on index path
           
            
            guard let qrCodeImage = self.qrCodeTransparentImage else { print("❌ Missing QR image"); return }

            self.progressAlert.show()

            FirebaseManager.shared.uploadImageToStorage(image: profileImage, cardKey: cardKey, fileName: "_profile") { result in
                switch result {
                case .success(let profileURL):
                    self.userCard.profilePhotoPath = profileURL

                    FirebaseManager.shared.uploadImageToStorage(image: templateImage, cardKey: self.cardKey, fileName: "INV_\(self.cardKey)_mainCard") { result in
                        switch result {
                        case .success(let templateUrl):
                            self.userCard.mainCardFilePath = templateUrl
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyyMMdd HH-mm-ss"
                            let dateString = formatter.string(from: Date())
                            let fileName = "\(dateString)"

                            FirebaseManager.shared.uploadImageToStorage(image: qrCodeImage, cardKey: self.cardKey, fileName: fileName) { result in
                                switch result {
                                case .success(let qrURL):
                                    self.userCard.qrCodeFilePath = qrURL
                                    self.progressAlert.dismiss()
                                    print("✅ Images uploaded. URLs assigned.")
                                    let invitationCardKey = "\(self.cardKey)"
                                    self.updateCardURLsWithProfile(cardKey: invitationCardKey)

                                case .failure(let error):
                                    self.progressAlert.dismiss()
                                    print("❌ QR upload failed: \(error.localizedDescription)")
                                }
                            }
                            
                            
                        case .failure(let error):
                            self.progressAlert.dismiss()
                            print("❌ Main template upload failed: \(error.localizedDescription)")
                        }
                    }


                case .failure(let error):
                    self.progressAlert.dismiss()
                    print("❌ Profile upload failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Capture Preview Invitation as UIImage
    func capturePreviewInvitationImage() -> UIImage? {
        // Ensure there is content to capture
        guard !previewInvitation.subviews.isEmpty else {
            print("❌ previewInvitation has no subviews to capture.")
            return nil
        }
        
        // Render previewInvitation into UIImage
        let renderer = UIGraphicsImageRenderer(bounds: previewInvitation.bounds)
        let image = renderer.image { context in
            previewInvitation.layer.render(in: context.cgContext)
        }
        
        print("📸 Captured previewInvitation image with size: \(image.size)")
        return image
    }
    
    
    func savedCard() {
        if var card = self.userCard {
            guard let templateImage = capturePreviewInvitationImage() else { print("❌ Failed to capture template image"); return }

            // Determine which QR image to use based on index path
           
            
            guard let qrCodeImage = self.qrCodeTransparentImage else { print("❌ Missing QR image"); return }

            self.progressAlert.show()

            
            FirebaseManager.shared.uploadImageToStorage(image: templateImage, cardKey: self.cardKey, fileName: "INV_\(self.cardKey)_mainCard") { result in
                switch result {
                case .success(let templateUrl):
                    self.userCard.mainCardFilePath = templateUrl
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMdd HH-mm-ss"
                    let dateString = formatter.string(from: Date())
                    let fileName = "\(dateString)"
                    
                    
                    FirebaseManager.shared.uploadImageToStorage(image: qrCodeImage, cardKey: self.cardKey, fileName: fileName) { result in
                        switch result {
                        case .success(let qrURL):
                            self.userCard.qrCodeFilePath = qrURL
                            self.progressAlert.dismiss()
                            print("✅ Images uploaded. URLs assigned.")
                              let invitationCardKey = "\(self.cardKey)"
                              self.updateCardURLs(cardKey: invitationCardKey)


                        case .failure(let error):
                            self.progressAlert.dismiss()
                            print("❌ QR upload failed: \(error.localizedDescription)")
                        }
                    }
                    
                    
                case .failure(let error):
                    self.progressAlert.dismiss()
                    print("❌ Main template upload failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    
    func updateCardURLs(cardKey: String) {
        let cardRef = Database.database().reference().child("UserInvitationCard").child(cardKey)
        
        // 📅 Format current date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HH:mm:ss"
        
        let now = Date()
        let createdDate = formatter.string(from: now)
        
        // ➕ 7 days for expiry
        let expiryDate = formatter.string(from: Calendar.current.date(byAdding: .day, value: 7, to: now)!)

        // 📤 Update values in Firebase
        cardRef.updateChildValues([
            "mainCardFilePath": self.userCard.mainCardFilePath,
            "qrCodeFilePath": self.userCard.qrCodeFilePath,
            "ownerId": self.userID,
            "qrCode": cardKey,
            "templateName": self.userCard.templateName,
            "deviceName": "Ios",
            "createdDate": createdDate,
            "expiryDate": expiryDate
        ]) { error, _ in
            if let error = error {
                print("❌ Failed to update URLs in DB: \(error.localizedDescription)")
            } else {
                print("✅ Updated card image URLs and date fields in database.")
                self.createInvitation()
            }
        }
    }
    
    
    func updateCardURLsWithProfile(cardKey: String) {
        let cardRef = Database.database().reference().child("UserInvitationCard").child(cardKey)
        
        // 📅 Format current date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HH:mm:ss"
        
        let now = Date()
        let createdDate = formatter.string(from: now)
        
        // ➕ 7 days for expiry
        let expiryDate = formatter.string(from: Calendar.current.date(byAdding: .day, value: 7, to: now)!)

        // 📤 Update values in Firebase
        cardRef.updateChildValues([
            "profilePhotoPath": self.userCard.profilePhotoPath,
            "mainCardFilePath": self.userCard.mainCardFilePath,
            "qrCodeFilePath": self.userCard.qrCodeFilePath,
            "ownerId": self.userID,
            "qrCode": cardKey,
            "templateName": self.userCard.templateName,
            "deviceName": "Ios",
            "createdDate": createdDate,
            "expiryDate": expiryDate
        ]) { error, _ in
            if let error = error {
                print("❌ Failed to update URLs in DB: \(error.localizedDescription)")
            } else {
                print("✅ Updated card image URLs and date fields in database.")
                self.createInvitation()
            }
        }
    }
    
    // MARK: - Create Invitation
    func createInvitation() {
        print("📇 Previewing User Invitation before upload:")

        print("Groom Name: \(userCard.groomName)")
        print("Bride Name: \(userCard.brideName)")
        print("Date: \(userCard.date)")
        print("Islamic Date: \(userCard.islamicDate)")
        print("Event Time: \(userCard.eventTime)")
        print("Buffet Time: \(userCard.buffetTime)")
        print("Venue: \(userCard.venue)")
        print("RSVP Details: \(userCard.rsvpDetail)")
        print("Location Link: \(userCard.locationLink)")
        
        print("Template Name: \(userCard.templateName)")
        print("Children Allowed: \(userCard.children)")
        print("Photography Allowed: \(userCard.photography)")
        print("Smoking Allowed: \(userCard.smoking)")

        print("Media & Paths:")
        print("- QR Code: \(userCard.qrCode)")
        print("- QR Code Path: \(userCard.qrCodeFilePath)")
        print("- Profile Photo Path: \(userCard.profilePhotoPath)")
        print("- Main Card File Path: \(userCard.mainCardFilePath)")

        print("Payments:")
        print("- Google Pay: \(userCard.googlePay)")
        print("- Apple Pay: \(userCard.applePay)")
        print("- NFT: \(userCard.nft)")

        print("Other:")
        print("- Owner ID: \(userCard.ownerId)")
        print("- Created Date: \(userCard.createdDate)")
        print("- Expiry Date: \(userCard.expiryDate)")
        print("- Additional BG Color: \(userCard.additionalBgColor)")
        print("- Additional Font: \(userCard.additionalFont)")

        // 🔄 Optional: Upload to Firebase after preview
        print("✅ Invitation created successfully.")
        self.navigateToTabBarScreen()
    }

    func navigateToTabBarScreen() {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC {
           tabBarVC.modalTransitionStyle = .crossDissolve
           tabBarVC.modalPresentationStyle = .fullScreen
           present(tabBarVC, animated: true)
       }
   }
        
}
