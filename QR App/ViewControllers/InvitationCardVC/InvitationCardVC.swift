//
//  InvitationCardVC.swift
//  QR App
//
//  Created by Touheed khan on 28/06/2025.
//

import UIKit
import Malert
class InvitationCardVC: UIViewController {
    
    
    // MARK: - @IBOutlet

    @IBOutlet weak var savelbl: UILabel!
    @IBOutlet weak var scrolHeightConst: NSLayoutConstraint!
    @IBOutlet weak var cameraImgView: UIImageView!
    @IBOutlet weak var invitationCardTV: UITableView!
    @IBOutlet weak var childrenImgView: UIImageView!
    @IBOutlet weak var smokeImgView: UIImageView!
    @IBOutlet weak var locationView: DesignableView!
    @IBOutlet weak var locationTxtField: UILabel!
    @IBOutlet weak var selectedChildrenCamreaCigrateView: DesignableView!
    @IBOutlet weak var selectTheFollwingHeightConst: NSLayoutConstraint!
    // MARK: - @Declarationns
    var selectedTemplateIdentifier: String?
    var userFromCardScreen = false
    var updatedModel: InvitationModel!
    var selectedImageURLFromProfile: URL?

    var invitation = InvitationModel(
        ownerId: "",
        qrCode: "",
        profilePhotoPath: "",
        mainCardFilePath: "",
        qrCodeFilePath: "",
        groomName: "",
        brideName: "",
        date: "",
        islamicDate: "",
        eventTime: "",
        buffetTime: "",
        venue: "",
        locationLink: "",
        rsvpDetail: "",
        templateName: "",
        children: false,
        photography: false,
        smoking: false,
        applePay: "",
        googlePay: "",
        nft: "",
        createdDate: "",
        expiryDate: "",
        additionalBgColor: "",
        additionalFont: ""
    )

    var profileImage: UIImage?
    var progressAllert = ProgressAlertView()
    var selectedImageURLFromProfileURL: URL?
    var userSelectedProfileTemplate = false

    // Track states
    var isCameraOn = false
    var isSmokeOn = false
    var isChildrenOn = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTxtField.isHidden = true
        locationTxtField.isUserInteractionEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        if userFromCardScreen {
            self.savelbl.text = "Save"
            self.setFormWIthUpdate(templateNo: updatedModel.templateName)

        } else {
            
            self.getSelectedTemplate()
        }
        self.setup()
        self.setNoti()
    }
    
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func getSelectedTemplate() {
        if let selected = selectedTemplateIdentifier {
            switch selected {
            case "InvitationTemplatesCVC1":
                print("tempName: \"1\"")
                self.scrolHeightConst.constant = 830
                userSelectedProfileTemplate = false
                invitation.templateName = "1"
            case "InvitationTemplatesCVC2":
                print("tempName: \"2\"")
                self.scrolHeightConst.constant = 830
                userSelectedProfileTemplate = false
                invitation.templateName = "2"
            case "InvitationTemplatesCVC3":
                print("tempName: \"3\"")
                self.scrolHeightConst.constant = 830
                userSelectedProfileTemplate = false
                invitation.templateName = "3"
            case "InvitationTemplatesCVC4":
                print("tempName: \"4\"")
                self.scrolHeightConst.constant = 940
                invitation.templateName = "4"
                
                userSelectedProfileTemplate = true
            case "InvitationTemplatesCVC5":
                print("tempName: \"5\"")
                self.scrolHeightConst.constant = 940
                userSelectedProfileTemplate = true
                invitation.templateName = "5"
            case "InvitationTemplatesCVC7":
                self.scrolHeightConst.constant = 940
                print("tempName: \"6\"") // skipping CVC6
                
                userSelectedProfileTemplate = true
                invitation.templateName = "6"
            case "InvitationTemplatesCVC8":
                print("tempName: \"7\"")
                self.scrolHeightConst.constant = 830
                userSelectedProfileTemplate = false
                invitation.templateName = "7"
            case "InvitationTemplatesCVC9":
                print("tempName: \"8\"")
                self.scrolHeightConst.constant = 830
                userSelectedProfileTemplate = false
                invitation.templateName = "8"
            case "InvitationTemplatesCVC10":
                print("tempName: \"9\"")
                userSelectedProfileTemplate = true
                self.scrolHeightConst.constant = 910
                self.updateUIForm()
                invitation.templateName = "9"
            case "InvitationTemplatesCVC11":
                print("tempName: \"10\"")
                self.scrolHeightConst.constant = 830
                userSelectedProfileTemplate = false
                self.updateUIForm()
                invitation.templateName = "10"
            case "InvitationTemplatesCVC12":
                print("tempName: \"11\"")
                self.scrolHeightConst.constant = 830
                userSelectedProfileTemplate = false
                self.updateUIForm()
                invitation.templateName = "11"
            case "InvitationTemplatesCVC13":
                print("tempName: \"12\"")
                self.scrolHeightConst.constant = 830
                userSelectedProfileTemplate = false
                self.updateUIForm()
                invitation.templateName = "12"
            case "InvitationTemplatesCVC14":
                self.scrolHeightConst.constant = 830
                userSelectedProfileTemplate = false
                print("tempName: \"13\"")
                self.updateUIForm()
                invitation.templateName = "13"
            default:
                print("Unknown template")
                invitation.templateName = ""
            }
        }
        invitationCardTV.reloadData()
    }
    
    func updateUIForm() {
        self.selectTheFollwingHeightConst.constant = 0
        self.selectedChildrenCamreaCigrateView.isHidden = true
    }
    
    

    
    // MARK: - Set Notifications
    func setNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageSelected(_:)), name: .userFromInviationCard, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(locationViewTapped))
          locationView.isUserInteractionEnabled = true  // make sure it accepts touches
          locationView.addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func locationViewTapped() {
        print("Location view tapped!")
        showCostumAlert()
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
                self.locationTxtField.isHidden = false
                self.locationTxtField.text = customAlert.editLinkTxtView.text
                self.invitation.locationLink = customAlert.editLinkTxtView.text
            }
        }
        
        // Present the alert
        present(malert, animated: true)
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
        let indexPath = IndexPath(row: 0, section: 0)
        self.invitationCardTV.reloadRows(at: [indexPath], with: .none)
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
    
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func didTapCreate(_ sender: Any) {
        
        self.updateInvitationFromVisibleCells()
        if validateInvitationForm() {
            print("All fields valid ✅")
            self.navigateToPreVieeScreen(invitationCard: invitation)
        }
    }
    
    
    
    
    
    @IBAction func didTapSmoke(_ sender: Any) {
        isSmokeOn.toggle()
        smokeImgView.image = UIImage(named: isSmokeOn ? "cigarette-on" : "cigarette-off")
        invitation.smoking = isSmokeOn
    }

    @IBAction func didTapCamera(_ sender: Any) {
        isCameraOn.toggle()
        cameraImgView.image = UIImage(named: isCameraOn ? "camera-on" : "camera-off")
        invitation.photography = isCameraOn
    }

    @IBAction func didTapChildren(_ sender: Any) {
        isChildrenOn.toggle()
        childrenImgView.image = UIImage(named: isChildrenOn ? "children-on" : "children-off")
        invitation.children = isChildrenOn
    }

    
    // MARK: - Navigate TO Invitation PreViee Controller
    
    private func navigateToPreVieeScreen(invitationCard: InvitationModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let invitationPreViewVC = storyboard.instantiateViewController(withIdentifier: "InvitationPreViewVC") as? InvitationPreViewVC {
            invitationPreViewVC.modalTransitionStyle = .crossDissolve
            invitationPreViewVC.userCard = invitationCard
            invitationPreViewVC.profileImage = profileImage
            invitationPreViewVC.userSelectedProfileTemplate = userSelectedProfileTemplate
            invitationPreViewVC.userFromMyCardsScreen = userFromCardScreen
            invitationPreViewVC.modalPresentationStyle = .fullScreen
            present(invitationPreViewVC, animated: true)
        }
    }
    
    
    
    func setup() {
        invitationCardTV.delegate = self
        invitationCardTV.dataSource = self
        invitationCardTV.register(UINib(nibName: "newCardTVC", bundle: nil), forCellReuseIdentifier: "newCardTVC")
    }
    
    
    private func updateInvitationFromVisibleCells() {
        for cell in invitationCardTV.visibleCells {
            guard let cardCell = cell as? newCardTVC else { continue }
            let tag = cardCell.inputTxtField.tag
            let text = cardCell.inputTxtField.text ?? ""

            // Adjust for skipped profile cell if needed
            let adjustedTag = userSelectedProfileTemplate ? tag - 1 : tag

            switch adjustedTag {
            case 0: invitation.groomName = text
            case 1: invitation.brideName = text
            case 2: invitation.date = text
            case 3: invitation.islamicDate = text
            case 4: invitation.eventTime = text
            case 5: invitation.buffetTime = text
            case 6: invitation.venue = text
            default: break
            }
        }
    }


    
    private func validateInvitationForm() -> Bool {
        if invitation.groomName.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter the groom's name.")
            return false
        }

        if invitation.brideName.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter the bride's name.")
            return false
        }

        if invitation.date.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter the event date.")
            return false
        }

        if invitation.islamicDate.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter the Islamic date.")
            return false
        }

        if invitation.eventTime.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter the event time.")
            return false
        }

        if invitation.buffetTime.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter the buffet time.")
            return false
        }

        if invitation.venue.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter the venue.")
            return false
        }

        if invitation.locationLink.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter the location link.")
            return false
        }

        if profileImage == nil && userSelectedProfileTemplate == true {
            showAlert(title: "Missing Field", message: "Please upload the profile photo.")
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

extension InvitationCardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSelectedProfileTemplate ? 8 : 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCardTVC", for: indexPath) as! newCardTVC
        
        let adjustedRow = userSelectedProfileTemplate ? indexPath.row  : indexPath.row + 1
        
        guard let type = InvitationFieldType(rawValue: adjustedRow) else { return cell }
        
        cell.configurePlaceholder(type.placeholder)
        cell.uploadIcon.isHidden = !type.showsUploadIcon
        cell.inputTxtField.delegate = self
        cell.inputTxtField.tag = adjustedRow
        
        if userSelectedProfileTemplate == true && adjustedRow == 0 {
            // Profile image row
            cell.inputTxtField.isUserInteractionEnabled = false
            cell.inputTxtField.text = ""
            cell.placeholderLabel.isHidden = false
            cell.inputTxtField.backgroundColor = .clear
            cell.inputTxtField.textColor = .black
            
            if let selectedImage = self.profileImage {
                cell.uploadIcon.image = selectedImage
                cell.uploadIcon.layer.cornerRadius = cell.uploadIcon.frame.width / 2
                cell.uploadIcon.clipsToBounds = true
                cell.uploadIcon.contentMode = .scaleAspectFill
            }
        } else {
            // Regular text field rows
            cell.inputTxtField.isUserInteractionEnabled = true
            cell.inputTxtField.backgroundColor = .white
            cell.inputTxtField.textColor = .black
          
            
            // ✅ Set saved value from userCard
            
            switch type {
            case .profileImage:
                // handled above (profile image row)
                cell.inputTxtField.text = ""
                
            case .groomName:
                cell.inputTxtField.text = invitation.groomName
                
            case .brideName:
                cell.inputTxtField.text = invitation.brideName
                
            case .date:
                cell.inputTxtField.text = invitation.date
                
            case .islamicDate:
                cell.inputTxtField.text = invitation.islamicDate
                
            case .eventTime:
                cell.inputTxtField.text = invitation.eventTime
                
            case .buffetTime:
                cell.inputTxtField.text = invitation.buffetTime
                
            case .venue:
                cell.inputTxtField.text = invitation.venue
                
            case .rsvpDetail:
                cell.inputTxtField.text = invitation.rsvpDetail
            }

            cell.placeholderLabel.isHidden = !(cell.inputTxtField.text?.isEmpty ?? true)
            
        }
        
        return cell
    }





    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if userSelectedProfileTemplate == true && indexPath.row == 0 {
            // Only open picker if profile image is part of template
            self.navigateToProfileScreen()
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    
    private func navigateToProfileScreen() {
        view.endEditing(true) // ✅ This saves any currently editing field
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
            if let profileImage = self.profileImage {
                profileVC.firebaseProfileImage = profileImage
            }
            profileVC.userFromInvitation = true
            profileVC.modalTransitionStyle = .crossDissolve
            profileVC.modalPresentationStyle = .fullScreen
            present(profileVC, animated: true)
        }
    }
    
    
}

extension InvitationCardVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        guard let field = InvitationFieldType(rawValue: textField.tag) else { return }

        switch field {
        case .groomName: invitation.groomName = text
        case .brideName: invitation.brideName = text
        case .date: invitation.date = text
        case .islamicDate: invitation.islamicDate = text
        case .eventTime: invitation.eventTime = text
        case .buffetTime: invitation.buffetTime = text
        case .venue: invitation.venue = text
        case .rsvpDetail: invitation.rsvpDetail = text
        default: break
        }
    }
}
