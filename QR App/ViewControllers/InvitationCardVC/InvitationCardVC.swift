//
//  InvitationCardVC.swift
//  QR App
//
//  Created by Touheed khan on 28/06/2025.
//

import UIKit

class InvitationCardVC: UIViewController {

    @IBOutlet weak var invitationCardTV: UITableView!
    
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
        expiryDate: ""
    )
    var profileImage: UIImage?

    var progressAllert = ProgressAlertView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

    func setup() {
        invitationCardTV.delegate = self
        invitationCardTV.dataSource = self
        invitationCardTV.register(UINib(nibName: "newCardTVC", bundle: nil), forCellReuseIdentifier: "newCardTVC")
        invitationCardTV.reloadData()
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
            print("Tapped Profile Image")
            // Call your image picker logic here
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
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
