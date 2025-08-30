//
//  CreatteCardVC.swift
//  QR App
//
//  Created by Touheed khan on 01/06/2025.
//

import UIKit
import FirebaseDatabase
import Malert

class CreatteCardVC: UIViewController, UIScrollViewDelegate {
    // MARK: - @IBOutlet
    @IBOutlet weak var creadCardInfoTV: UITableView!
    @IBOutlet weak var socialstackViews: UIStackView!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var sociallinksTV: UITableView!
    @IBOutlet weak var contiunelbl: UILabel!
    
    // MARK: - Declation
    var selectedImageURLFromProfile: URL?
    var selectedImageURLFromLogo: URL?
    var link: String?

    var lastContentOffset: CGFloat = 0.0
    var totalScrolledHeight: CGFloat = 0.0
    var cardInfo = CardInfo()
    var socialLinks: [SocialLinkType: String] = [:]
    var profileImage: UIImage?
    var logoImage: UIImage?
    var progressAllert = ProgressAlertView()
    var selectedTemplateIdentifier: String?
    var userFromMyCards = false
    var updateCardModel: UserBusinessCardModel?
    // User Card Business Object
    var userCard = UserBusinessCardModel(
        applePay: "",
        companyLogoPath: "",
        companyName: "",
        createdDate: "",
        deviceName: "",
        email: "",
        expiryDate: "",
        facebookLink: "",
        fullName: "",
        googlePay: "",
        instagramLink: "",
        jobTitle: "",
        linkedinLink: "",
        location: "",
        locationLink: "",
        mainCardFilePath: "",
        nft: "",
        ownerId: "",
        phoneNo: "",
        profilePhotoPath: "",
        qrCode: "",
        qrCodeFilePath: "",
        snapchatLink: "",
        
        // ✅ Add these newly required fields:
        templateName: "",
        tiktokLink: "",
        websiteUrl: "",
        whatsappLink: "",
        additionalFont: "",
        additionalBgColor: ""
    )


    override func viewDidLoad() {
        super.viewDidLoad()
        scrolView.delegate = self
        self.setNoti()
        self.setup()
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(handleSocialStackTap))
        socialstackViews.addGestureRecognizer(tapGesture1)
        socialstackViews.isUserInteractionEnabled = true
        creadCardInfoTV.rowHeight = UITableView.automaticDimension
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           tapGesture.cancelsTouchesInView = false
           view.addGestureRecognizer(tapGesture)
        
    }
    
    
    
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        NotificationCenter.default.post(name: .didTapBackButton, object: nil)
        self.dismiss(animated: true)

    }
    
    
    
    @IBAction func didTapCreateCard(_ sender: Any) {
        view.endEditing(true) // to ensure textFieldDidEndEditing is called

        // Example: selectedImageURL is optional URL
        if userFromMyCards {
            self.updateUserCardFromVisibleCells()

            if let imageURL = selectedImageURLFromProfile {
                if imageURL.isRemote {
                    print("✅ Image URL is a server URL: \(imageURL.absoluteString)")
                    // e.g., use as-is (already uploaded)
                } else if imageURL.isLocalFile {
                    print("✅ Image URL is local: \(imageURL.path)")
                    
                    // e.g., upload it first, then replace with remote URL
                } else {
                    print("⚠️ Image URL has unknown scheme: \(imageURL)")
                }
            } else  if let logoURL = selectedImageURLFromLogo {
                
                if logoURL.isRemote {
                    print("✅ Image URL is a server URL: \(logoURL.absoluteString)")
                    // e.g., use as-is (already uploaded)
                } else if logoURL.isLocalFile {
                    print("✅ Image URL is local: \(logoURL.path)")
                    // e.g., upload it first, then replace with remote URL
                } else {
                    print("⚠️ Image URL has unknown scheme: \(logoURL)")
                }
                
                print("No selectedImageURL present.")
            }

            print("🎉 Model From Firebase", userCard)
            self.navigateToViewCardScreen(card: userCard)

        } else {
            self.updateUserCardFromVisibleCells()
            if validateForm() {
                print("All fields valid ✅", userCard)
                
//                do {
//                    let encoder = JSONEncoder()
//                    encoder.outputFormatting = .prettyPrinted // For readable JSON
//                    let jsonData = try encoder.encode(userCard)
//                    
//                    if let jsonString = String(data: jsonData, encoding: .utf8) {
//                        print("All fields valid ✅")
//                        print(jsonString)
//                    }
//                } catch {
//                    print("❌ Failed to serialize userCard to JSON:", error)
//                }
                
                
                self.navigateToPreVieeScreen(buisnessCard: userCard)
            }
        }
    }

    
    
    func navigateToTabBarScreen() {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC {
           tabBarVC.modalTransitionStyle = .crossDissolve
           tabBarVC.modalPresentationStyle = .fullScreen
           present(tabBarVC, animated: true)
       }
   }


    
   
    private func updateUserCardFromVisibleCells() {
        // 🟠 First: Update from creadCardInfoTV
        for cell in creadCardInfoTV.visibleCells {
            guard let cardCell = cell as? newCardTVC else { continue }
            let tag = cardCell.inputTxtField.tag
            let text = cardCell.inputTxtField.text ?? ""

            switch tag {
            case 0: userCard.fullName = text
            case 2: userCard.email = text
            case 3: userCard.phoneNo = text
            case 4: userCard.companyName = text
            case 5: userCard.jobTitle = text
            case 6: userCard.websiteUrl = text
            case 8: userCard.locationLink = text
            default: break
            }
        }

        // 🔵 Then: Update from sociallinksTV
        for cell in sociallinksTV.visibleCells {
            guard let cardCell = cell as? newCardTVC else { continue }
            let tag = cardCell.inputTxtField.tag - 1000 // you tagged social fields starting from 1000
            let text = cardCell.inputTxtField.text ?? ""

            switch tag {
            case 0: userCard.facebookLink = text
            case 1: userCard.instagramLink = text
            case 2: userCard.snapchatLink = text
            case 3: userCard.tiktokLink = text
            case 4: userCard.linkedinLink = text // or xLink, as you mentioned
            case 5: userCard.whatsappLink = text
            default: break
            }
        }
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sociallinksTV.reloadData()
        creadCardInfoTV.reloadData()
    }
    
    // MARK: - Navigate to View Card Screen
    private func navigateToViewCardScreen(card: UserBusinessCardModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewAsVC = storyboard.instantiateViewController(withIdentifier: "ViewAsVC") as? ViewAsVC {
            
            if let logoImageURL = selectedImageURLFromLogo {
                if logoImageURL.isLocalFile {
                    viewAsVC.logoImage = logoImage
                    viewAsVC.checkUserUpdateAnyImage = true
                    viewAsVC.checkImage = .logoImage
                }
            } else if let profileURL = selectedImageURLFromProfile {
                if profileURL.isLocalFile {
                    viewAsVC.checkUserUpdateAnyImage = true
                    viewAsVC.profileImage = profileImage
                    viewAsVC.checkImage = .profileImage
                }
            }
            
            if let profileImage = selectedImageURLFromProfile, let logoImageURL = selectedImageURLFromLogo  {
                if logoImageURL.isLocalFile && logoImageURL.isLocalFile {
                    viewAsVC.checkImage = .bothImages
                }
            }
            
            viewAsVC.cardInfo = card
            viewAsVC.userFromCreateScreen = true
            viewAsVC.modalTransitionStyle = .crossDissolve
            viewAsVC.modalPresentationStyle = .fullScreen
            present(viewAsVC, animated: true)
        }
    }
    
    
    // MARK: - Navigate TO PreViee Controller
    
    private func navigateToPreVieeScreen(buisnessCard: UserBusinessCardModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let preViewVC = storyboard.instantiateViewController(withIdentifier: "PreViewVC") as? PreViewVC {
            preViewVC.modalTransitionStyle = .crossDissolve
            preViewVC.userCard = userCard
            preViewVC.profileImage = profileImage
            preViewVC.logoImage = logoImage
            preViewVC.selectedTemplateIdentifier =  selectedTemplateIdentifier
            preViewVC.modalPresentationStyle = .fullScreen
            present(preViewVC, animated: true)
        }
    }
    
    // MARK: - Set Notifications
    func setNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageSelected(_:)), name: .imageSelectedNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageSelectedForLogo(_:)), name: .imageSelectedForLogo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackButtonTap), name: .didTapBackButtonFromLogoScreen, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateDataTap), name: .userFromMyCardsScreen, object: nil)

    }
    

    
    
    @objc func handleUpdateDataTap(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let card = userInfo["card"] as? UserBusinessCardModel {
            DispatchQueue.main.async {
                self.progressAllert.show()
                self.contiunelbl.text = "Continue"
                self.userFromMyCards = true
                self.userCard = card
                
                
                if let url = URL(string: card.profilePhotoPath) {
                    self.selectedImageURLFromProfile = url
                } else if let logoURL =  URL(string: card.companyLogoPath) {
                    self.selectedImageURLFromLogo = logoURL
                }
                // Load images
                self.loadImage(from: card.profilePhotoPath) { image in
                    self.profileImage = image
                    self.creadCardInfoTV.reloadData()
                }

                self.loadImage(from: card.companyLogoPath) { image in
                    self.logoImage = image
                    self.progressAllert.dismiss()
                    self.creadCardInfoTV.reloadData()
                }

                // Reload text fields
                self.creadCardInfoTV.reloadData()
                self.sociallinksTV.reloadData()
               
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

    
    
    
    @objc private func handleBackButtonTap() {
        print("Back button tapped! Do something here.")
//        self.creadCardInfoTV.reloadData()
        // For example: refresh data or navigate
    }
    
    @objc private func handleImageSelected(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let image = userInfo["image"] as? UIImage else {
            return
        }

        self.profileImage = image
        self.view.endEditing(true) // Save text field changes if needed

        if let imageURL = userInfo["imageURL"] as? URL {
            // URL was provided by sender
            print("Received image file URL: \(imageURL)")
            self.selectedImageURLFromProfile = imageURL
        } else {
            // Fallback: serialize the UIImage to temp location and keep that URL
            do {
                let tempURL = try writeImageToTemporaryURL(image: image)
                print("Created fallback temp URL: \(tempURL)")
                self.selectedImageURLFromProfile = tempURL
            } catch {
                print("Failed to create temp URL from image: \(error)")
            }
        }

        print("UserCardDataModel (after image): ", userCard.fullName)

        let indexPath = IndexPath(row: 1, section: 0)
        self.creadCardInfoTV.reloadRows(at: [indexPath], with: .none)
    }
    
    
    func writeImageToTemporaryURL(image: UIImage, quality: CGFloat = 0.9) throws -> URL {
        guard let data = image.jpegData(compressionQuality: quality) else {
            throw NSError(domain: "ImageEncoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data."])
        }
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "selected_image_\(UUID().uuidString).jpg"
        let fileURL = tempDir.appendingPathComponent(fileName)
        try data.write(to: fileURL, options: .atomic)
        return fileURL
    }



    
    @objc private func handleImageSelectedForLogo(_ notification: Notification) {
        

        guard let userInfo = notification.userInfo,
              let image = userInfo["image"] as? UIImage else {
            return
        }
        self.view.endEditing(true) // Save text field changes if needed

        self.logoImage = image

        if let imageURL = userInfo["imageURL"] as? URL {
            // URL was provided by sender
            print("Received image file URL: \(imageURL)")
            self.selectedImageURLFromLogo = imageURL
        } else {
            // Fallback: serialize the UIImage to temp location and keep that URL
            do {
                let tempURL = try writeImageToTemporaryURL(image: image)
                print("Created fallback temp URL: \(tempURL)")
                self.selectedImageURLFromLogo = tempURL
            } catch {
                print("Failed to create temp URL from image: \(error)")
            }
        }

        print("UserCardDataModel (after image): ", userCard.fullName)

        let indexPath = IndexPath(row: 7, section: 0)
        self.creadCardInfoTV.reloadRows(at: [indexPath], with: .none)
        
        
    }

    
    
    @objc func handleSocialStackTap() {
        // Scroll to bottom of scrollView
        let bottomOffset = CGPoint(x: 0, y: scrolView.contentSize.height - scrolView.bounds.height + scrolView.contentInset.bottom)
        
        scrolView.setContentOffset(bottomOffset, animated: true)
        print("⬇️ Scrolled to bottom on socialstackViews tap")
    }
    
    // MARK: - Scroll View Will Begin Dragging
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("User started scrolling.")
        lastContentOffset = scrollView.contentOffset.y
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let delta = currentOffset - lastContentOffset

        if delta != 0 {
            totalScrolledHeight += abs(delta)
        }

        // Hide when scrolled more than 420 pts
        if currentOffset >= 40 {
            if !socialstackViews.isHidden {
                socialstackViews.isHidden = true
                print("🔽 socialstackViews hidden at offset:", currentOffset)
            }
        } else {
            if socialstackViews.isHidden {
                socialstackViews.isHidden = false
                print("🔼 socialstackViews shown at offset:", currentOffset)
            }
        }

        lastContentOffset = currentOffset
    }

    
    
    // MARK: - Set Up

    func setup() {
        if let currentUser = UserModel.shared {
            userCard.ownerId = currentUser.userId
        }
        let premiumTVC = UINib(nibName: "newCardTVC", bundle: nil)
        creadCardInfoTV.register(premiumTVC, forCellReuseIdentifier: "newCardTVC")
        creadCardInfoTV.dataSource = self
        creadCardInfoTV.delegate = self
        // Setup social links table view
        sociallinksTV.delegate = self
        sociallinksTV.dataSource = self
        sociallinksTV.register(UINib(nibName: "newCardTVC", bundle: nil), forCellReuseIdentifier: "newCardTVC")

    }
    
    private func validateForm() -> Bool {
        if userCard.fullName.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter your full name.")
            return false
        }
        
        if userCard.email.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter your email.")
            return false
        }
        
        if userCard.phoneNo.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter your phone number.")
            return false
        }
        
        if userCard.companyName.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter your company name.")
            return false
        }
        
        if userCard.jobTitle.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter your job title.")
            return false
        }
        
        if userCard.websiteUrl.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter your website URL.")
            return false
        }
        
        if profileImage == nil {
            showAlert(title: "Missing Profile Image", message: "Please upload your profile image.")
            return false
        }
        
        
        if logoImage == nil {
            showAlert(title: "Missing Logo Image", message: "Please upload your logo image.")
            return false
        }
        
        return true
    }

    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    
}

extension CreatteCardVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == creadCardInfoTV {
            return CardFieldType.allCases.count
        } else if tableView == sociallinksTV {
            return SocialLinkType.allCases.count // or use a separate filtered list
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCardTVC", for: indexPath) as! newCardTVC

        if tableView == creadCardInfoTV {
            guard let type = CardFieldType(rawValue: indexPath.row) else { return cell }
               
               cell.configurePlaceholder(type.placeholder)
               cell.uploadIcon.isHidden = !type.showsUploadIcon
               cell.inputTxtField.delegate = self
               cell.inputTxtField.tag = indexPath.row
               
               if type == .profilePicture || type == .logo || type == .location {
                   // 🔒 Non-editable rows
                   cell.inputTxtField.isUserInteractionEnabled = false
                   cell.inputTxtField.text = ""
                   cell.placeholderLabel.isHidden = false
                   cell.inputTxtField.backgroundColor = .clear
                   cell.inputTxtField.textColor = .black
                   
                   // Profile Image
                   if type == .profilePicture, let selectedImage = self.profileImage {
                       cell.uploadIcon.image = selectedImage
                       cell.uploadIcon.layer.cornerRadius = cell.uploadIcon.frame.width / 2
                       cell.uploadIcon.clipsToBounds = true
                       cell.uploadIcon.contentMode = .scaleAspectFill
                   }
                   
                   // Logo Image
                   if type == .logo, let selectedImage = self.logoImage {
                       cell.uploadIcon.image = selectedImage
                       cell.uploadIcon.layer.cornerRadius = cell.uploadIcon.frame.width / 2
                       cell.uploadIcon.clipsToBounds = true
                       cell.uploadIcon.contentMode = .scaleAspectFill
                   }
                   
                   // Location
                   if type == .location {
                       cell.inputTxtField.text = userCard.location
                       cell.placeholderLabel.isHidden = !(userCard.location.isEmpty)
                   }
                   
            } else {
                // ✏️ Editable rows (text input)
                
            }
        } else if tableView == sociallinksTV {
            let type = SocialLinkType.allCases[indexPath.row]
            cell.configurePlaceholder(type.placeholder)
            cell.uploadIcon.image = UIImage(named: type.iconName)
            cell.uploadIcon.isHidden = !type.showsUploadIcon
            cell.inputTxtField.delegate = self
            cell.inputTxtField.tag = 1000 + indexPath.row // avoid tag conflict with creadCardInfoTV
            addDoneButtonOnKeyboard(for: cell.inputTxtField)
            
            // 🧠 Set saved value
            switch type {
            case .facebook:
                cell.inputTxtField.text = userCard.facebookLink
            case .instagram:
                cell.inputTxtField.text = userCard.instagramLink
            case .snapchat:
                cell.inputTxtField.text = userCard.snapchatLink
            case .tiktok:
                cell.inputTxtField.text = userCard.tiktokLink
            case .x:
                cell.inputTxtField.text = userCard.linkedinLink // or xLink
            case .whatsapp:
                cell.inputTxtField.text = userCard.whatsappLink
            }

            cell.placeholderLabel.isHidden = !(cell.inputTxtField.text?.isEmpty ?? true)
        }


        return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if tableView == creadCardInfoTV {
            if indexPath.row == 1 {
                print("Tapped on row 0 — perform action here.")
                navigateToProfileScreen()
                // e.g., navigate or present an alert
            } else if indexPath.row == 7 {
                print("Tapped on row 7 — perform action here.")
                navigateToCreateLogoScreen()
            }
            if let type = CardFieldType(rawValue: indexPath.row) {
                
                if type == .location {
                    print("📍 Location cell tapped")
                    showCostumAlert()
                }
            }
        }
      
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    // MARK: - Navigate Profile Up Controller
    
    private func navigateToProfileScreen() {
        view.endEditing(true) // ✅ This saves any currently editing field
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
            if let profileImage = self.profileImage {
                profileVC.firebaseProfileImage = profileImage
            }
            profileVC.modalTransitionStyle = .crossDissolve
            profileVC.modalPresentationStyle = .fullScreen
            present(profileVC, animated: true)
        }
    }
    
    // MARK: - AddDone Button On Keyboard
    
    func addDoneButtonOnKeyboard(for textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.items = [flexSpace, doneButton]
        textField.inputAccessoryView = toolbar
    }
    
    // MARK: - Navigate Create logo Controller
    
    private func navigateToCreateLogoScreen() {
        view.endEditing(true) // ✅ This saves any currently editing field
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "CreateLogoVC") as? CreateLogoVC {
            if let profileImage = self.logoImage {
                profileVC.firebaseLogoImage = profileImage
            }
            profileVC.modalTransitionStyle = .crossDissolve
            profileVC.modalPresentationStyle = .fullScreen
            present(profileVC, animated: true)
        }
    }
    
    func showCostumAlert() {
        let customAlert = CostumAlertForLocationn.instantiateFromNib()
        
        // Wrap the alert in Malert
        let malert = Malert(customView: customAlert)
        
        // Configure closure actions
        customAlert.pasteAction = { [weak self] in
            guard let self = self else { return }
            if let clipboard = UIPasteboard.general.string {
                customAlert.editLinkTxtView.text = clipboard
            }
        }
        
        customAlert.verifyAction = { [weak self] link in
            guard let self = self else { return }
            print("User wants to verify: \(link)")
            
            // ✅ Dismiss after verify
               self.dismiss(animated: true) {
                   self.userCard.location = link
                   self.link = link
                   
                   let indexPath = IndexPath(row: CardFieldType.location.rawValue, section: 0)
                   self.creadCardInfoTV.reloadRows(at: [indexPath], with: .automatic)
               }
        }
        
        // Present the alert
        present(malert, animated: true)
    }
    
    
}
extension CreatteCardVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""

        if creadCardInfoTV == textField.superview?.superview?.superview as? UITableView {
            switch textField.tag {
            case 0: userCard.fullName = text
            case 1: break // profile handled via image
            case 2: userCard.email = text
            case 3: userCard.phoneNo = text
            case 4: userCard.companyName = text
            case 5: userCard.jobTitle = text
            case 6: userCard.websiteUrl = text
            case 7: break // logo handled via image
            case 8: break
            default: break
            }
        } else {
            switch textField.tag {
            case 0: userCard.facebookLink = text
            case 1: userCard.instagramLink = text
            case 2: userCard.linkedinLink = text
            case 3: userCard.snapchatLink = text
            case 4: userCard.tiktokLink = text
            case 5: userCard.whatsappLink = text
            case 6: userCard.googlePay = text
            case 7: userCard.applePay = text
            case 8: userCard.nft = text
            default: break
            }
        }
    }
}
