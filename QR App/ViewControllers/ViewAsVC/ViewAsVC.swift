//
//  ViewAsVC.swift
//  QR App
//
//  Created by MacBook Air on 30/07/2025.
//

import UIKit
import FirebaseDatabase
import PassKit

enum CheckImagee {
    case profileImage
    case logoImage
    case bothImages
}

class ViewAsVC: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var updatelbl: UILabel!
    @IBOutlet weak var selectedTemplateView: UIView!
    @IBOutlet weak var toplbl: UILabel!
    @IBOutlet weak var updateAndShareStackView: UIStackView!
    
    // MARK: - Declartations
    var cardInfo: UserBusinessCardModel?
    var progressAlert = ProgressAlertView()
    var userFromCreateScreen = false
    var profileImage: UIImage?
    var logoImage: UIImage?
    var userID = ""
    var checkUserUpdateAnyImage = false
    var checkImage: CheckImagee = .bothImages
    
    var templateView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Clear any previous content
        if userFromCreateScreen {
            self.userID = UserModel.shared!.userId
            self.updatelbl.text = "Update Card"
            self.updateAndShareStackView.isHidden = true
            self.updateView.isHidden = false

        } else {
            self.updateAndShareStackView.isHidden = false
            self.updateView.isHidden = true

        }
        
        DispatchQueue.main.async {
           
            self.loadTheView()
           
        }
        
        
       
    }
    
    
    
    func updateCardURLs(cardKey: String) {
        let cardRef = Database.database().reference().child("UserBusinessCard").child(cardKey)
        
        // 📅 Format current date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HH:mm:ss"
        
        let now = Date()
        
        // ➕ 7 days for expiry
        let expiryDate = formatter.string(from: Calendar.current.date(byAdding: .day, value: 7, to: now)!)

        if let cardInfo = cardInfo {
            // 📤 Update values in Firebase
            cardRef.updateChildValues([
                "profilePhotoPath": cardInfo.profilePhotoPath,
                "companyLogoPath": cardInfo.companyLogoPath,
                "mainCardFilePath": cardInfo.mainCardFilePath,
                "qrCodeFilePath": cardInfo.qrCodeFilePath,
                "ownerId": self.userID,
                "qrCode": cardInfo.qrCode,
                "templateName": cardInfo.templateName,
                "deviceName": "ios",
                "expiryDate": expiryDate
            ]) { error, _ in
                if let error = error {
                    print("❌ Failed to update URLs in DB: \(error.localizedDescription)")
                } else {
                    print("✅ Updated card image URLs and date fields in database.")
                    self.createCard()
                }
            }
        }
       
    }
    
    func updateCard(card: UserBusinessCardModel, imageUploadCase: CheckImagee) {
        if var card = self.cardInfo {
            // ✅ Default QR image

            if let cardKey = self.cardInfo?.qrCode {
                
                switch imageUploadCase {
                    
                case .profileImage:
                    guard let profileImage = profileImage else { print("❌ Missing profile"); return }

                    FirebaseManager.shared.uploadImageToStorage(image: profileImage, cardKey: cardInfo!.qrCode, fileName: "_profile") { result in
                        switch result {
                        case .success(let profileURL):
                            self.cardInfo!.profilePhotoPath = profileURL
                            
                            self.updateCardURLs(cardKey: cardKey)
                            
                            
                        case .failure(let error):
                            self.progressAlert.dismiss()
                            print("❌ Profile upload failed: \(error.localizedDescription)")
                        }
                    }
                case .logoImage:
                    guard let logoImage = logoImage else { print("❌ Missing logo"); return }
                    FirebaseManager.shared.uploadImageToStorage(image: logoImage, cardKey: cardKey, fileName: "_logo") { result in
                        switch result {
                        case .success(let logoURL):
                            self.cardInfo!.companyLogoPath = logoURL
                            
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyyMMdd HH-mm-ss"
                            let dateString = formatter.string(from: Date())
                            let fileName = "\(dateString)"
                            
                            self.updateCardURLs(cardKey: cardKey)
                            
                            
                        case .failure(let error):
                            self.progressAlert.dismiss()
                            print("❌ Logo upload failed: \(error.localizedDescription)")
                        }
                    }
                case .bothImages:
                    guard let profileImage = profileImage else { print("❌ Missing profile"); return }
                    guard let logoImage = logoImage else { print("❌ Missing logo"); return }
                    FirebaseManager.shared.uploadImageToStorage(image: profileImage, cardKey: cardKey, fileName: "_profile") { result in
                        switch result {
                        case .success(let profileURL):
                            self.cardInfo!.profilePhotoPath = profileURL
                            
                            FirebaseManager.shared.uploadImageToStorage(image: logoImage, cardKey: self.cardInfo!.qrCode, fileName: "_logo") { result in
                                switch result {
                                case .success(let logoURL):
                                    self.cardInfo!.companyLogoPath = logoURL
                                    self.updateCardURLs(cardKey: cardKey)
                                    
                                case .failure(let error):
                                    self.progressAlert.dismiss()
                                    print("❌ Logo upload failed: \(error.localizedDescription)")
                                }
                            }
                        case .failure(let error):
                            self.progressAlert.dismiss()
                            print("❌ Profile upload failed: \(error.localizedDescription)")
                        }
                    }
                default:
                    print("Not case Seleted")
                }
                
                
            }
        }
    }
    
    func capturedImgaTemplate() {
        guard var card = self.cardInfo else { return }

        // Assume `templateView` is the UIView you want to capture (replace with actual reference)
        guard let templateView = self.templateView else {
            print("❌ Template view missing")
            return
        }

        let templateImage = templateView.snapshotImage()

        self.progressAlert.show()
        FirebaseManager.shared.uploadImageToStorage(image: templateImage, cardKey: card.qrCode, fileName: "\(card.qrCode)_mainCard") { result in
            DispatchQueue.main.async {
                self.progressAlert.dismiss()
                switch result {
                case .success(let templateUrl):
                    self.cardInfo!.mainCardFilePath = templateUrl
                    print("✅ Uploaded template image: \(templateUrl)")
                case .failure(let error):
                    print("❌ Main template upload failed: \(error.localizedDescription)")
                }
            }
        }
    }

    
    
    
    func createCard() {
        
        
        if var card = self.cardInfo {
            print("📇 Previewing User Business Card before upload:")

            print("Full Name: \(card.fullName)")
            print("Email: \(card.email)")
            print("Phone No: \(card.phoneNo)")
            print("Company Name: \(card.companyName)")
            print("Job Title: \(card.jobTitle)")
            print("Website URL: \(card.websiteUrl)")
            
            print("Profile Photo Path: \(card.profilePhotoPath)")
            print("Company Logo Path: \(card.companyLogoPath)")
            print("Main Card File Path: \(card.mainCardFilePath)")
            print("QR Code: \(card.qrCode)")
            print("QR Code File Path: \(card.qrCodeFilePath)")
            
            print("Social Links:")
            print("- Facebook: \(card.facebookLink)")
            print("- Instagram: \(card.instagramLink)")
            print("- LinkedIn: \(card.linkedinLink)")
            print("- Snapchat: \(card.snapchatLink)")
            print("- TikTok: \(card.tiktokLink)")
            print("- WhatsApp: \(card.whatsappLink)")
            
            print("Payments:")
            print("- Google Pay: \(card.googlePay)")
            print("- Apple Pay: \(card.applePay)")
            print("- NFT: \(card.nft)")
            
            print("Other:")
            print("- Owner ID: \(card.ownerId)")
            print("- Location: \(card.locationLink)")
            print("- Template Name: \(card.templateName)")

            // 🔄 Optional: Upload to Firebase after preview
            print("✅ Card saved successfully.")
            cardUpdateWithoutImage()
        }
        
        
       
    }
    
    
    func cardUpdateWithoutImage() {
        FirebaseManager.shared.updateUserBusinessCard(byQRCode: self.cardInfo!.qrCode, updatedCard: self.cardInfo!) { result in
            switch result {
            case .success:
                print("✅ Card updated successfully.")
                self.capturedImgaTemplate()
                self.progressAlert.dismiss()
                // 🎉 Show success alert
                self.showAlert(title: "Success", message: "Your card has been updated successfully.") {
                    // 👉 Do something after OK is tapped
                    self.navigateToTabBarScreen()
                    
                }
            case .failure(let error):
                self.progressAlert.dismiss()
                print("❌ Failed to update card:", error.localizedDescription)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }
    }
    
    
    @IBAction func didTapUpdate(_ sender: Any) {
       
        if checkUserUpdateAnyImage {
            if let cardInfo = self.cardInfo {
                updateCard(card: cardInfo, imageUploadCase: checkImage)
            }
        } else {
            cardUpdateWithoutImage()
        }
        
    }
    
    
    // MARK: - Show Alert
    
    
    func showAlert(title: String, message: String, onOk: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            onOk?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigate To Tab Bar Screen
    
    func navigateToTabBarScreen() {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC {
           tabBarVC.modalTransitionStyle = .crossDissolve
           tabBarVC.modalPresentationStyle = .fullScreen
           present(tabBarVC, animated: true)
       }
   }

    
    // MARK: - load The View
    
    func loadTheView() {
        // Show loader if no subviews yet
        if self.selectedTemplateView.subviews.isEmpty {
            self.progressAlert.show()
        }

        loadSelectedCardView(in: self.selectedTemplateView) { [weak self] templateView in
            guard let self = self, let templateView = templateView else { return }

            // Clear previous preview
            self.selectedTemplateView.subviews.forEach { $0.removeFromSuperview() }

            // Embed the templateView with full-edge constraints
            templateView.translatesAutoresizingMaskIntoConstraints = false
            self.selectedTemplateView.addSubview(templateView)
            NSLayoutConstraint.activate([
                templateView.topAnchor.constraint(equalTo: self.selectedTemplateView.topAnchor),
                templateView.bottomAnchor.constraint(equalTo: self.selectedTemplateView.bottomAnchor),
                templateView.leadingAnchor.constraint(equalTo: self.selectedTemplateView.leadingAnchor),
                templateView.trailingAnchor.constraint(equalTo: self.selectedTemplateView.trailingAnchor)
            ])

            self.templateView = templateView

            // Hide loader after template is added
            self.progressAlert.dismiss()

            // Force layout
            self.selectedTemplateView.layoutIfNeeded()
            templateView.layoutIfNeeded()
        }
    }


   
    
    
    // MARK: - load Selected Card View
    func loadSelectedCardView(in container: UIView, completion: @escaping (UIView?) -> Void) {
        guard let templateName = cardInfo?.templateName else {
            print("❌ No template name in cardInfo")
            completion(nil)
            return
        }

        guard let logoURL = URL(string: cardInfo?.companyLogoPath ?? ""),
              let profileURL = URL(string: cardInfo?.profilePhotoPath ?? ""),
              let qrCardURL = URL(string: cardInfo?.qrCodeFilePath ?? "") else {
            print("❌ Invalid image URLs")
            completion(nil)
            return
        }

        // 🔄 Add activity indicator to container view

        let group = DispatchGroup()
        var logoImage: UIImage?
        var profileImage: UIImage?
        var qrCodeFilePath: UIImage?

        group.enter()
        URLSession.shared.dataTask(with: logoURL) { data, _, _ in
            if let data = data { logoImage = UIImage(data: data) }
            group.leave()
        }.resume()

        group.enter()
        URLSession.shared.dataTask(with: profileURL) { data, _, _ in
            if let data = data { profileImage = UIImage(data: data) }
            group.leave()
        }.resume()

        group.enter()
        URLSession.shared.dataTask(with: qrCardURL) { data, _, _ in
            if let data = data { qrCodeFilePath = UIImage(data: data) }
            group.leave()
        }.resume()

        group.notify(queue: .main) {

            var view: UIView?

            switch templateName {
            case "1":
                if let cell = Bundle.main.loadNibNamed("Template8CVC", owner: nil, options: nil)?.first as? Template8CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "2":
                if let cell = Bundle.main.loadNibNamed("Template7CVC", owner: nil, options: nil)?.first as? Template7CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "3":
                if let cell = Bundle.main.loadNibNamed("Template6CVC", owner: nil, options: nil)?.first as? Template6CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "4":
                if let cell = Bundle.main.loadNibNamed("Template5CVC", owner: nil, options: nil)?.first as? Template5CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "5":
                if let cell = Bundle.main.loadNibNamed("Template4CVC", owner: nil, options: nil)?.first as? Template4CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "6":
                if let cell = Bundle.main.loadNibNamed("Template3CVC", owner: nil, options: nil)?.first as? Template3CVC {
                    cell.configure(with: self.cardInfo!)
                    view = cell
                }
            case "7":
                if let cell = Bundle.main.loadNibNamed("Template2CVC", owner: nil, options: nil)?.first as? Template2CVC {
                    cell.configure(with: self.cardInfo!)
                    view = cell
                }
            default:
                print("⚠️ Unknown template identifier: \(templateName)")
            }

            completion(view)
        }
    }


    
    
    

    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
//    
    @IBAction func didTapAddtoWallet(_ sender: Any) {
        if let imageUrl = cardInfo?.mainCardFilePath{
            
            // Start loading the Wallet Pass
//            NetworkManager.shared.generateWalletPass(stripImageUrl: imageUrl) { [weak self] result in
//                guard let self = self else { return }
//                
//                switch result {
//                case .success(let result):
//                    print("✅ Wallet pass generated: \(result.passData)")
//                    NetworkManager.shared.presentPass(data: result.passData, from: self)
//                    
//                case .failure(let error):
//                    print("❌ Error generating Wallet pass: \(error.localizedDescription)")
//                }
//            }
            
            
            // Step 1: Get the path of .pkpass in app bundle
               guard let passURL = Bundle.main.url(forResource: "pass_1754506750", withExtension: "pkpass") else {
                   print("❌ Pass file not found in bundle")
                   return
               }

               // Step 2: Load pass data
               do {
                   let passData = try Data(contentsOf: passURL)
                   let pass = try PKPass(data: passData)

                   // Step 3: Create Wallet view controller
                   if let addPassVC = PKAddPassesViewController(pass: pass) {
                       self.present(addPassVC, animated: true, completion: nil)
                   } else {
                       print("❌ Failed to create Wallet view controller")
                   }
               } catch {
                   print("❌ Error loading pass:", error.localizedDescription)
               }
            
            
            
        }
        
        
//        DispatchQueue.main.async {
//            if let imageUrl = self.cardInfo?.mainCardFilePath{
//                
//                
//                self.progressAlert.show()
//                
//                print("ImageURL")
//                // Start loading the Wallet Pass
//                // Step 1: Prepare the image URL
//                let imageUrlString = imageUrl
//                
//                // Step 2: Setup form-data
//                let boundary = "Boundary-\(UUID().uuidString)"
//                var request = URLRequest(url: URL(string: "https://googlewalletapi.onrender.com/apple/wallet-pass")!)
//                request.httpMethod = "POST"
//                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//                
//                var body = Data()
//                body.append("--\(boundary)\r\n".data(using: .utf8)!)
//                body.append("Content-Disposition: form-data; name=\"strip_image_url\"\r\n\r\n".data(using: .utf8)!)
//                body.append("https://firebasestorage.googleapis.com/v0/b/qr-card-ff7bc.firebasestorage.app/o/UserCard%2F-OWnsobBoaddktl3GuRC%2F-OWnsobBoaddktl3GuRC_mainCard.png?alt=media&token=bc3a7073-34c6-4cb0-b189-2322203cb705\r\n".data(using: .utf8)!)
//                body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//                request.httpBody = body
//                
//                // Step 3: Call API
//                URLSession.shared.dataTask(with: request) { data, response, error in
//                    guard let data = data, error == nil else {
//                        print("Upload error:", error?.localizedDescription ?? "Unknown")
//                        return
//                    }
//                    
//                    // Step 4: Parse JSON
//                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                       let fileUrlStr = json["file"] as? String,
//                       let fileUrl = URL(string: fileUrlStr) {
//                        print("PKPASS URL:", fileUrl)
//                        
//                        // Step 5: Download .pkpass file
//                        URLSession.shared.dataTask(with: fileUrl) { pkpassData, _, downloadError in
//                            guard let pkpassData = pkpassData, downloadError == nil else {
//                                
//                                self.progressAlert.dismiss()
//                                
//                                print("Download error:", downloadError?.localizedDescription ?? "Unknown")
//                                return
//                            }
//                            
//                            DispatchQueue.main.async {
//                                do {
//                                    let pass = try PKPass(data: data)
//                                    let addPassVC = PKAddPassesViewController(pass: pass)
//                                    self.progressAlert.dismiss()
//                                    DispatchQueue.main.async {
//                                        self.present(addPassVC!, animated: true)
//                                    }
//                                } catch {
//                                    self.progressAlert.dismiss()
//                                    
//                                    print("❌ Failed to create Apple Wallet pass: \(error)")
//                                }
//                            }
//                        }.resume()
//                    } else {
//                        print("Invalid response from backend")
//                    }
//                }.resume()
//                
//            }
//            
//        }
        
        
    }
    

    
    @IBAction func didTapShareCard(_ sender: Any) {
    }
    

}
