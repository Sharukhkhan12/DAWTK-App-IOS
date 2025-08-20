//
//  InvitationTemplatesCVC3.swift
//  QR App
//
//  Created by Touheed khan on 01/07/2025.
//

import UIKit

class InvitationTemplatesCVC3: UICollectionViewCell {
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
    
    // Closures for button actions
    var onDinnerTimeTap: (() -> Void)?
    var onWeddingTimeTap: (() -> Void)?
    var onLocationTap: (() -> Void)?
    
    
    // Closures for button actions
    var onChildesTap: (() -> Void)?
    var onCameraTap: (() -> Void)?
    var onSmokingTap: (() -> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        childesBtnn.addTarget(self, action: #selector(handleChildesTap), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(handleCameraTap), for: .touchUpInside)
        smokingBtn.addTarget(self, action: #selector(handleSmokingTap), for: .touchUpInside)
        
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
extension InvitationTemplatesCVC3 {
    func configure(with invitation: InvitationModel, userFromViewScreen: Bool) {
        // 🎉 Basic Info
        
        
        
        if !invitation.additionalBgColor.isEmpty {
            if let bgColor = UIColor(hex: invitation.additionalBgColor) {
                self.cardView.backgroundColor = bgColor
            }
        }
        
        if !invitation.additionalFont.isEmpty {
            weddingTimelbl.font = UIFont(name: invitation.additionalFont, size: weddingTimelbl.font.pointSize)
            dinnerTime.font = UIFont(name: invitation.additionalFont, size: dinnerTime.font.pointSize)
            englishDatelbl.font = UIFont(name: invitation.additionalFont, size: englishDatelbl.font.pointSize)
            shawalDatelbl.font = UIFont(name: invitation.additionalFont, size: shawalDatelbl.font.pointSize)
            brideFamilylbl.font = UIFont(name: invitation.additionalFont, size: brideFamilylbl.font.pointSize)
            groomsFamilylbl.font = UIFont(name: invitation.additionalFont, size: groomsFamilylbl.font.pointSize)
        }
        
        
        groomsFamilylbl.text = invitation.groomName
        brideFamilylbl.text = invitation.brideName
        englishDatelbl.text = invitation.date
        shawalDatelbl.text = invitation.islamicDate
        weddingTimelbl.text = invitation.eventTime
        dinnerTime.text = invitation.buffetTime
        locationlbl.text = invitation.venue

        if userFromViewScreen == true {
            // 🎯 QR Code Image (if you want to load from URL)
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
extension InvitationTemplatesCVC3: InvitationScalableCardView {
    
    var cardContentView: UIView? {
        return cardView
        
    }
    
    func scaleToFit(in container: UIView) {
        layoutIfNeeded()

        let templateSize = self.bounds.size
        let containerSize = container.bounds.size

        guard templateSize.width > 0 && templateSize.height > 0 else {
            print("❌ Template size invalid")
            return
        }

        // 👇 Use widthScale instead of min(width, height) to fill horizontally
        let widthScale = containerSize.width / templateSize.width
        let heightScale = containerSize.height / templateSize.height
        let scale = widthScale // ← favor width coverage

        // Apply transform
        self.transform = CGAffineTransform(scaleX: scale, y: scale)

        let scaledWidth = templateSize.width * scale
        let scaledHeight = templateSize.height * scale

        // ✅ Center vertically only (x = 0 to stretch full width)
        let xOffset: CGFloat = 0
        let yOffset = (containerSize.height - scaledHeight) / 2

        self.frame = CGRect(x: xOffset, y: yOffset, width: scaledWidth, height: scaledHeight)
    }
}
extension InvitationTemplatesCVC3: InvitationFontCustomizable {
    func applyFont(_ fontName: String) {
        // If the font is not valid, just return
        guard let _ = UIFont(name: fontName, size: 16) else { return }
        // Newly added ones ⬇️
        weddingTimelbl.font = UIFont(name: fontName, size: weddingTimelbl.font.pointSize)
        dinnerTime.font = UIFont(name: fontName, size: dinnerTime.font.pointSize)
        englishDatelbl.font = UIFont(name: fontName, size: englishDatelbl.font.pointSize)
        shawalDatelbl.font = UIFont(name: fontName, size: shawalDatelbl.font.pointSize)
        brideFamilylbl.font = UIFont(name: fontName, size: brideFamilylbl.font.pointSize)
        groomsFamilylbl.font = UIFont(name: fontName, size: groomsFamilylbl.font.pointSize)
    }
}
