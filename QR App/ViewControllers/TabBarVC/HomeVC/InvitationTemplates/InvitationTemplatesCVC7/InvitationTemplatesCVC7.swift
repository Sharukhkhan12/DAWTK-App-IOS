//
//  InvitationTemplatesCVC7.swift
//  QR App
//
//  Created by Touheed khan on 02/07/2025.
//

import UIKit

class InvitationTemplatesCVC7: UICollectionViewCell {

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
    @IBOutlet weak var childesBtnn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var smokingBtn: UIButton!
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
        
        
        childesBtnn.addTarget(self, action: #selector(handleChildesTap), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(handleCameraTap), for: .touchUpInside)
        smokingBtn.addTarget(self, action: #selector(handleSmokingTap), for: .touchUpInside)
        
        dinnerTimebtn.addTarget(self, action: #selector(handleDinnerTimeTap), for: .touchUpInside)
        weddingTimeBtn.addTarget(self, action: #selector(handleWeddingTimeTap), for: .touchUpInside)
        locationBtn.addTarget(self, action: #selector(handleLocationTap), for: .touchUpInside)
        setupUI()
        
        // Initialization code
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
    
    
    @objc private func handleChildesTap() {
        onChildesTap?()
    }

    @objc private func handleCameraTap() {
        onCameraTap?()
    }

    @objc private func handleSmokingTap() {
        onSmokingTap?()
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
    

}
extension InvitationTemplatesCVC7 {
    
    // MARK: - Configure Cell with Invitation Data
    func configure(with invitation: InvitationModel, userFromViewScreen: Bool) {
        groomsFamilylbl.text = invitation.groomName
        brideFamilylbl.text = invitation.brideName
        englishDatelbl.text = invitation.date
        shawalDatelbl.text = invitation.islamicDate
        weddingTimelbl.text = invitation.eventTime
        dinnerTime.text = invitation.buffetTime
        locationlbl.text = invitation.venue
        
        // Update button states (example)
        childesBtnn.isSelected = invitation.children
        cameraBtn.isSelected = invitation.photography
        smokingBtn.isSelected = invitation.smoking
        if userFromViewScreen == true {
            // Load profile image (if URL exists)
            if let url = URL(string: invitation.profilePhotoPath) {
                loadImage(from: url) { [weak self] image in
                    self?.profileImageView.image = image
                }
            }
            
            // Load QR Code
            if let qrURL = URL(string: invitation.qrCodeFilePath) {
                loadImage(from: qrURL) { [weak self] image in
                    self?.qrScanImage.image = image
                }
            }
        }
       
    }
    
    // MARK: - Async Image Loader
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let img = UIImage(data: data) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async { completion(img) }
        }.resume()
    }
}
