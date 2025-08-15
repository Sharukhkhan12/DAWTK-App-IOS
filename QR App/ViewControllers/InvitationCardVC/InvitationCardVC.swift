//
//  InvitationCardVC.swift
//  QR App
//
//  Created by Touheed khan on 28/06/2025.
//

import UIKit

class InvitationCardVC: UIViewController {

    @IBOutlet weak var cameraImgView: UIImageView!
    @IBOutlet weak var invitationCardTV: UITableView!
    @IBOutlet weak var childrenImgView: UIImageView!
    @IBOutlet weak var smokeImgView: UIImageView!
    
    
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
    var selectedImageURLFromProfile: URL?

    // Track states
    var isCameraOn = false
    var isSmokeOn = false
    var isChildrenOn = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setNoti()
    }
    
    
    // MARK: - Set Notifications
    func setNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageSelected(_:)), name: .userFromInviationCard, object: nil)
        
        
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
//            self.navigateToPreVieeScreen(buisnessCard: userCard)
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

    
    func setup() {
        invitationCardTV.delegate = self
        invitationCardTV.dataSource = self
        invitationCardTV.register(UINib(nibName: "newCardTVC", bundle: nil), forCellReuseIdentifier: "newCardTVC")
        invitationCardTV.reloadData()
    }
    
    
    private func updateInvitationFromVisibleCells() {
        // 🟠 Example: For your invitation info tableView
        for cell in invitationCardTV.visibleCells {
            guard let cardCell = cell as? newCardTVC else { continue }
            let tag = cardCell.inputTxtField.tag
            let text = cardCell.inputTxtField.text ?? ""

            switch tag {
            case 0: invitation.groomName = text
            case 1: invitation.brideName = text
            case 2: invitation.date = text
            case 3: invitation.islamicDate = text
            case 4: invitation.eventTime = text
            case 5: invitation.buffetTime = text
            case 6: invitation.venue = text
            case 7: invitation.locationLink = text
            case 8: invitation.rsvpDetail = text
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

        if invitation.rsvpDetail.isEmpty {
            showAlert(title: "Missing Field", message: "Please enter the RSVP details.")
            return false
        }

        if invitation.mainCardFilePath.isEmpty {
            showAlert(title: "Missing Field", message: "Please upload the main invitation card image.")
            return false
        }

        if invitation.profilePhotoPath.isEmpty {
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
        return 9 // Profile Image, Groom, Bride, Date, Event Time, Buffet Time, Venue, RSVP
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newCardTVC", for: indexPath) as! newCardTVC

        
        guard let type = InvitationFieldType(rawValue: indexPath.row) else { return cell }
        
        if tableView == invitationCardTV {
            cell.configurePlaceholder(type.placeholder)
            cell.uploadIcon.isHidden = !type.showsUploadIcon
            cell.inputTxtField.delegate = self
            cell.inputTxtField.tag = indexPath.row
            
            if indexPath.row == 0 {
                cell.inputTxtField.isUserInteractionEnabled = false
                cell.inputTxtField.text = "" // ensure text is empty so placeholder appears
                cell.placeholderLabel.isHidden = false
                cell.inputTxtField.backgroundColor = .clear
                cell.inputTxtField.textColor = .black
                // Set correct image based on row
                if indexPath.row == 0, let selectedImage = self.profileImage {
                    cell.uploadIcon.image = selectedImage
                    cell.uploadIcon.layer.cornerRadius = cell.uploadIcon.frame.width / 2
                    cell.uploadIcon.clipsToBounds = true
                    cell.uploadIcon.contentMode = .scaleAspectFill
                }
            } else {
                cell.inputTxtField.isUserInteractionEnabled = true
                cell.inputTxtField.backgroundColor = .white
                cell.inputTxtField.textColor = .black
                cell.placeholderLabel.isHidden = !(cell.inputTxtField.text?.isEmpty ?? true)
            }
        }
        

        return cell
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            // Navigate to image picker
            self.navigateToProfileScreen()
            // Call your image picker logic here
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
        case .locationLink: invitation.locationLink = text
        case .rsvpDetail: invitation.rsvpDetail = text
        default: break
        }
    }
}
