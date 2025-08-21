//
//  PreViewVC.swift
//  QR App
//
//  Created by Touheed khan on 27/06/2025.
//

import UIKit
import FirebaseDatabase
import PassKit

class PreViewVC: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet weak var templatesCV: UICollectionView!
    
    // MARK: - Properties
    let totalTemplates = 10
    var hasVibratedForPage1 = false
    var selectedTemplateIdentifier: String?
    var lastVibratedPage: Int?
    var templateIdentifiers = [
        "Template8CVC",
        "Template7CVC",
        "Template6CVC",
        "Template5CVC",
        "Template4CVC",
        "Template3CVC",
        "Template2CVC"
    ]
    var selectedIndexPath: IndexPath?

    var profileImage: UIImage?
    var logoImage: UIImage?
    var qrCodeTransparentImage: UIImage?
    var qrCodeWithWhiteBackgroundImage: UIImage?
    var templateView: UIView?
    
    
    var userID = ""
    var cardKey = ""
    var userCard: UserBusinessCardModel!
    var progressAllert = ProgressAlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        templatesCV.delegate = self
        templatesCV.dataSource = self
        setup()
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func didTapSave(_ sender: Any) {
        DispatchQueue.main.async {
            self.savedCard()
        }
        
    }
    
    
    
    @IBAction func didTapAddWallet(_ sender: Any) {
        self.goToPass()
    }
   
    func goToPass() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let userVC = storyboard.instantiateViewController(withIdentifier: "NewPassVC") as? NewPassVC {
            userVC.modalPresentationStyle = .overCurrentContext
            userVC.modalTransitionStyle = .crossDissolve
            present(userVC, animated: true, completion: nil)
        }
    }
    
    
    
    func setCardInitialInFirebase() {
        
        if let currentUser = UserModel.shared?.userId {
            userID = currentUser
            print("✅ UserID \(userID)")
        }
        
        if let card =  self.userCard {
            FirebaseManager.shared.saveUserBusinessCard(card: card) { result in
                switch result {
                case .success(let cardKey):
                    print("📦 Business card created with key: \(cardKey)")
                    self.cardKey = cardKey
                    if let qrImage = self.generateQRCode(from: cardKey) {
                        if let whiteQrImage =  self.generateQRCodeWithBackground(from: cardKey) {
                            
                            self.qrCodeWithWhiteBackgroundImage = whiteQrImage
                        }
                        self.qrCodeTransparentImage = qrImage
                    }
                    self.progressAllert.dismiss()
                    // Step 2: Upload profile image
                case .failure(let error):
                    self.progressAllert.dismiss()
                    print("❌ Failed to save card: \(error.localizedDescription)")
                    
                }
                
            }
        }
    }
    
    
    // MARK: - Generate QR Code
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)

        // Step 1: Create QR Code
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")
        guard let qrImage = qrFilter.outputImage else { return nil }

        // Step 2: Apply color filter to make background transparent
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        colorFilter.setValue(qrImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(color: .black), forKey: "inputColor0") // QR color
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0, alpha: 0), forKey: "inputColor1") // Transparent background

        guard let coloredImage = colorFilter.outputImage else { return nil }

        // Step 3: Scale it up
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = coloredImage.transformed(by: transform)

        return convertCIImageToUIImageTransparent(ciImage: scaledImage)
    }

    
    
    
    func convertCIImageToUIImageTransparent(ciImage: CIImage) -> UIImage? {
        let context = CIContext(options: nil)

        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }

        return nil
    }
    
    
    
    func generateQRCodeWithBackground(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("M", forKey: "inputCorrectionLevel")

            if let outputImage = filter.outputImage {
                // Scale the QR code to make it higher resolution
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledImage = outputImage.transformed(by: transform)
                return UIImage(ciImage: scaledImage)
            }
        }

        return nil
    }

    
    
    // MARK: - Save Card
    
    func savedCard() {
        if var card = self.userCard {
            guard let profileImage = profileImage else { print("❌ Missing profile"); return }
            guard let logoImage = logoImage else { print("❌ Missing logo"); return }
            guard let templateImage = captureCurrentVisibleCellImage() else { print("❌ Failed to capture template image"); return }

            // Determine which QR image to use based on index path
            let center = CGPoint(x: templatesCV.contentOffset.x + templatesCV.bounds.width / 2,
                                 y: templatesCV.bounds.height / 2)
            let indexPath = templatesCV.indexPathForItem(at: center)
            
            // ✅ Default QR image
            var qrCodeImage: UIImage?
            if indexPath?.item == 1 {
                qrCodeImage = qrCodeWithWhiteBackgroundImage
            } else {
                qrCodeImage = qrCodeTransparentImage
            }
            
            guard let qrCodeImage = qrCodeImage else { print("❌ Missing QR image"); return }

            self.progressAllert.show()

            FirebaseManager.shared.uploadImageToStorage(image: profileImage, cardKey: cardKey, fileName: "_profile") { result in
                switch result {
                case .success(let profileURL):
                    self.userCard.profilePhotoPath = profileURL

                    FirebaseManager.shared.uploadImageToStorage(image: templateImage, cardKey: self.cardKey, fileName: "\(self.cardKey)_mainCard") { result in
                        switch result {
                        case .success(let templateUrl):
                            self.userCard.mainCardFilePath = templateUrl
                        case .failure(let error):
                            self.progressAllert.dismiss()
                            print("❌ Main template upload failed: \(error.localizedDescription)")
                        }
                    }

                    FirebaseManager.shared.uploadImageToStorage(image: logoImage, cardKey: self.cardKey, fileName: "_logo") { result in
                        switch result {
                        case .success(let logoURL):
                            self.userCard.companyLogoPath = logoURL

                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyyMMdd HH-mm-ss"
                            let dateString = formatter.string(from: Date())
                            let fileName = "\(dateString)"

                            FirebaseManager.shared.uploadImageToStorage(image: qrCodeImage, cardKey: self.cardKey, fileName: fileName) { result in
                                switch result {
                                case .success(let qrURL):
                                    self.userCard.qrCodeFilePath = qrURL
                                    self.progressAllert.dismiss()
                                    print("✅ Images uploaded. URLs assigned.")
                                    self.updateCardURLs(cardKey: self.cardKey)

                                case .failure(let error):
                                    self.progressAllert.dismiss()
                                    print("❌ QR upload failed: \(error.localizedDescription)")
                                }
                            }

                        case .failure(let error):
                            self.progressAllert.dismiss()
                            print("❌ Logo upload failed: \(error.localizedDescription)")
                        }
                    }

                case .failure(let error):
                    self.progressAllert.dismiss()
                    print("❌ Profile upload failed: \(error.localizedDescription)")
                }
            }
        }
    }


    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }


    
    // MARK: - Capture Visible Template Image
    func captureCurrentVisibleCellImage() -> UIImage? {
        // Get the center point of the collection view
        let center = CGPoint(x: templatesCV.contentOffset.x + templatesCV.bounds.width / 2,
                             y: templatesCV.bounds.height / 2)

        // Get the indexPath of the cell at the center
        guard let indexPath = templatesCV.indexPathForItem(at: center),
              let cell = templatesCV.cellForItem(at: indexPath) else {
            print("❌ No visible cell found at center point.")
            return nil
        }

        // ✅ Log the captured index and identifier
        selectedIndexPath = indexPath
        let templateIdentifier = templateIdentifiers[safe: indexPath.item] ?? "Unknown"
        print("📸 Capturing cell at indexPath: \(indexPath), Identifier: \(templateIdentifier)")
        
        self.setTemplate()

        // Render that cell's content into an image
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }

        if let context = UIGraphicsGetCurrentContext() {
            cell.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }

        return nil
    }



    func setTemplate() {
        guard let indexPath = selectedIndexPath else {
            print("❌ No selected index path.")
            return
        }

        let identifier = templateIdentifiers[safe: indexPath.item] ?? "Unknown"

        switch identifier {
        case "Template8CVC":
            print("🟦 Handling Template8CVC")
            userCard.templateName = "1"
            // Your custom logic for Template8CVC

        case "Template7CVC":
            print("🟩 Handling Template7CVC")
            userCard.templateName = "2"

            // Your custom logic for Template7CVC

        case "Template6CVC":
            print("🟧 Handling Template6CVC")
            userCard.templateName = "3"

            // Your custom logic for Template6CVC

        case "Template5CVC":
            print("🟥 Handling Template5CVC")
            userCard.templateName = "4"

            // Your custom logic for Template5CVC

        case "Template4CVC":
            print("🟨 Handling Template4CVC")
            userCard.templateName = "5"

            // Your custom logic for Template4CVC

        case "Template3CVC":
            print("🟪 Handling Template3CVC")
            userCard.templateName = "6"

            // Your custom logic for Template3CVC

        case "Template2CVC":
            print("🟫 Handling Template2CVC")
            userCard.templateName = "7"

            // Your custom logic for Template2CVC

        default:
            print("⚠️ Unknown template identifier: \(identifier)")
        }
    }


    
    
    
    // MARK: - Update Card URLs
    func updateCardURLs(cardKey: String) {
        let cardRef = Database.database().reference().child("UserBusinessCard").child(cardKey)
        
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
            "companyLogoPath": self.userCard.companyLogoPath,
            "mainCardFilePath": self.userCard.mainCardFilePath,
            "qrCodeFilePath": self.userCard.qrCodeFilePath,
            "ownerId": self.userID,
            "qrCode": self.cardKey,
            "templateName": self.userCard.templateName,
            "deviceName": "Ios",
            "createdDate": createdDate,
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

    
    // MARK: - Create Card
    
    func createCard() {
        print("📇 Previewing User Business Card before upload:")

        print("Full Name: \(userCard.fullName)")
        print("Email: \(userCard.email)")
        print("Phone No: \(userCard.phoneNo)")
        print("Company Name: \(userCard.companyName)")
        print("Job Title: \(userCard.jobTitle)")
        print("Website URL: \(userCard.websiteUrl)")
        
        print("Profile Photo Path: \(userCard.profilePhotoPath)")
        print("Company Logo Path: \(userCard.companyLogoPath)")
        print("Main Card File Path: \(userCard.mainCardFilePath)")
        print("QR Code: \(userCard.qrCode)")
        print("QR Code File Path: \(userCard.qrCodeFilePath)")
        
        print("Social Links:")
        print("- Facebook: \(userCard.facebookLink)")
        print("- Instagram: \(userCard.instagramLink)")
        print("- LinkedIn: \(userCard.linkedinLink)")
        print("- Snapchat: \(userCard.snapchatLink)")
        print("- TikTok: \(userCard.tiktokLink)")
        print("- WhatsApp: \(userCard.whatsappLink)")
        
        print("Payments:")
        print("- Google Pay: \(userCard.googlePay)")
        print("- Apple Pay: \(userCard.applePay)")
        print("- NFT: \(userCard.nft)")
        
        print("Other:")
        print("- Owner ID: \(userCard.ownerId)")
        print("- Location: \(userCard.locationLink)")
        print("- Template Name: \(userCard.templateName)")

        // 🔄 Optional: Upload to Firebase after preview
        print("✅ Card saved successfully.")
        self.navigateToTabBarScreen()
    }
    
    
    
    
    // MARK: - Setup
    func setup() {
        let template7Nib = UINib(nibName: "Template7CVC", bundle: nil)
        templatesCV.register(template7Nib, forCellWithReuseIdentifier: "Template7CVC")

        let template8Nib = UINib(nibName: "Template8CVC", bundle: nil)
        templatesCV.register(template8Nib, forCellWithReuseIdentifier: "Template8CVC")
        
        let template6Nib = UINib(nibName: "Template6CVC", bundle: nil)
        templatesCV.register(template6Nib, forCellWithReuseIdentifier: "Template6CVC")
        
        
        let template5Nib = UINib(nibName: "Template5CVC", bundle: nil)
        templatesCV.register(template5Nib, forCellWithReuseIdentifier: "Template5CVC")
        
        let template4Nib = UINib(nibName: "Template4CVC", bundle: nil)
        templatesCV.register(template4Nib, forCellWithReuseIdentifier: "Template4CVC")
        
        let template3Nib = UINib(nibName: "Template3CVC", bundle: nil)
        templatesCV.register(template3Nib, forCellWithReuseIdentifier: "Template3CVC")
        
        let template2Nib = UINib(nibName: "Template2CVC", bundle: nil)
        templatesCV.register(template2Nib, forCellWithReuseIdentifier: "Template2CVC")

        if let layout = templatesCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        
        
        
        

        templatesCV.isPagingEnabled = false
        templatesCV.showsHorizontalScrollIndicator = false
        templatesCV.alwaysBounceHorizontal = false

        // Move selected template to index 0
        if let selected = selectedTemplateIdentifier,
           let index = templateIdentifiers.firstIndex(of: selected) {
            // Remove selected and insert at index 0
            templateIdentifiers.remove(at: index)
            templateIdentifiers.insert(selected, at: 0)
        }
        
        
        
        // Scroll to first item (now the selected template)
        DispatchQueue.main.async {
            self.progressAllert.show()
            self.setCardInitialInFirebase()
            let firstIndexPath = IndexPath(item: 0, section: 0)
            self.templatesCV.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: false)
            self.templatesCV.reloadData()
        }
        
    }


}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension PreViewVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalTemplates
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = templateIdentifiers[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

        if let card = userCard {
            switch identifier {
            case "Template8CVC":
                if let typedCell = cell as? Template8CVC {
                    typedCell.configure(with: card)
                    typedCell.buismesslogo.image = logoImage
                    typedCell.qrimageofCard.image = qrCodeTransparentImage
                    typedCell.profileImage.image = profileImage
                }
            case "Template7CVC":
                if let typedCell = cell as? Template7CVC {
                    typedCell.configure(with: card)
                    typedCell.buismesslogo.image = logoImage
                    typedCell.qrimageofCard.image = qrCodeWithWhiteBackgroundImage
                    typedCell.profileImage.image = profileImage
                }
            case "Template6CVC":
                if let typedCell = cell as? Template6CVC {
                    typedCell.configure(with: card)
                    typedCell.buismesslogo.image = logoImage
                    typedCell.qrimageofCard.image = qrCodeTransparentImage
                    typedCell.profileImage.image = profileImage
                }
            case "Template5CVC":
                if let typedCell = cell as? Template5CVC {
                    typedCell.configure(with: card)
                    typedCell.buismesslogo.image = logoImage
                    typedCell.qrimageofCard.image = qrCodeTransparentImage
                    typedCell.profileImage.image = profileImage
                }
            case "Template4CVC":
                if let typedCell = cell as? Template4CVC {
                    typedCell.configure(with: card)
                    typedCell.buismesslogo.image = logoImage
                    typedCell.qrimageofCard.image = qrCodeTransparentImage
                    typedCell.profileImage.image = profileImage
                }
            case "Template3CVC":
                return cell
            case "Template2CVC":
               return cell
            default:
                break
            }
        }
        // Type check and call configure if supported
        return cell
    }




}

// MARK: - UICollectionViewDelegateFlowLayout
extension PreViewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.9
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = collectionView.frame.width * 0.05
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension PreViewVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width * 0.9
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)

        if currentPage != lastVibratedPage {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
            lastVibratedPage = currentPage
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                    withVelocity velocity: CGPoint,
                                    targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = templatesCV.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = templatesCV.frame.width * 0.9

        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: CGFloat

        if velocity.x > 0 {
            index = ceil(estimatedIndex)
        } else if velocity.x < 0 {
            index = floor(estimatedIndex)
        } else {
            index = round(estimatedIndex)
        }

        let xOffset = index * cellWidthIncludingSpacing - templatesCV.frame.width * 0.05
        targetContentOffset.pointee = CGPoint(x: xOffset, y: 0)
    }
}
