//
//  InvitationTemplatesCVC10.swift
//  QR App
//
//  Created by Touheed khan on 02/07/2025.
//

import UIKit

class InvitationTemplatesCVC10: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var weddingTimelbl: UILabel!
    @IBOutlet weak var dinnerTime: UILabel!
    @IBOutlet weak var qrScanImage: UIImageView!
    @IBOutlet weak var englishDatelbl: UILabel!
    @IBOutlet weak var shawalDatelbl: UILabel!
    @IBOutlet weak var brideFamilylbl: UILabel!
    @IBOutlet weak var groomsFamilylbl: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dinnerTimebtn: UIButton!
    @IBOutlet weak var weddingTimeBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    
    var onChildesTap: (() -> Void)?
    var onCameraTap: (() -> Void)?
    var onSmokingTap: (() -> Void)?
    
    // Closures for button actions
    var onDinnerTimeTap: (() -> Void)?
    var onWeddingTimeTap: (() -> Void)?
    var onLocationTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        dinnerTimebtn.addTarget(self, action: #selector(handleDinnerTimeTap), for: .touchUpInside)
        weddingTimeBtn.addTarget(self, action: #selector(handleWeddingTimeTap), for: .touchUpInside)
        locationBtn.addTarget(self, action: #selector(handleLocationTap), for: .touchUpInside)
        
        
        setupUI()
        
    }
    
    
    @objc private func handleDinnerTimeTap() {
        onDinnerTimeTap?()
    }

    @objc private func handleWeddingTimeTap() {
        onWeddingTimeTap?()
    }

    @objc private func handleLocationTap() {
        onLocationTap?()
    }
    
    
    

    private func setupUI() {
        // Corner Radius
        cardView.layer.cornerRadius = 20
        cardView.layer.masksToBounds = false // Important for shadow to appear

        // Shadow
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 6

        // Shadow path (for performance)
        cardView.layer.shadowPath = UIBezierPath(roundedRect:cardView.bounds, cornerRadius: 12).cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update shadow path if layout changes
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 12).cgPath
    }
    
    // MARK: - Configure Cell
       func configure(with invitation: InvitationModel, userFromViewScreen: Bool) {
           groomsFamilylbl.text = invitation.groomName
           brideFamilylbl.text = invitation.brideName
           englishDatelbl.text = invitation.date
           shawalDatelbl.text = invitation.islamicDate
           weddingTimelbl.text = invitation.eventTime
           dinnerTime.text = invitation.buffetTime
           locationlbl.text = invitation.venue
           
           if userFromViewScreen == true {
               // Load profile image
               if let url = URL(string: invitation.profilePhotoPath), !invitation.profilePhotoPath.isEmpty {
                   loadImage(from: url, into: profileImageView)
               } else {
                   profileImageView.image = UIImage(named: "placeholder") // fallback
               }
               
               // Load QR image
               if let qrURL = URL(string: invitation.qrCodeFilePath), !invitation.qrCodeFilePath.isEmpty {
                   loadImage(from: qrURL, into: qrScanImage)
               } else {
                   qrScanImage.image = UIImage(named: "qr_placeholder")
               }
           }
         
       }
    
    
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    

}
