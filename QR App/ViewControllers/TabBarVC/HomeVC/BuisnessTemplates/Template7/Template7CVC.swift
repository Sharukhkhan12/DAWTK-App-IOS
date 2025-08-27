//
//  Template7CVC.swift
//  QR App
//
//  Created by Touheed khan on 04/06/2025.
//

import UIKit

import UIKit



class Template7CVC: UICollectionViewCell {

    @IBOutlet weak var buianesslbl: UILabel!
    @IBOutlet weak var profilelbl: UILabel!
    @IBOutlet weak var buismesslogo: UIImageView!
    @IBOutlet weak var qrimageofCard: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var websitelbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var phonenlbl: UILabel!
    @IBOutlet weak var emailllbl: UILabel!
    @IBOutlet weak var linkldenbtn: UIButton!
    @IBOutlet weak var twiterXbtn: UIButton!
    @IBOutlet weak var instagrambtn: UIButton!
    @IBOutlet weak var facebookbtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    // MARK: - Extracted color
       var extractedCardColor: UIColor?
       
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let defaultColor = cardView.backgroundColor {
               print("🎨 Default MainView Color: \(defaultColor)")
               extractedCardColor = defaultColor
           } else {
               print("⚠️ MainView has no default background color")
           }
        setupUI()
        
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
    
    func configure(with card: UserBusinessCardModel) {
        
        if !card.additionalBgColor.isEmpty {
            if let bgColor = UIColor(hex: card.additionalBgColor) {
                self.extractedCardColor = bgColor
                self.cardView.backgroundColor = bgColor

            }
        }
        if !card.additionalFont.isEmpty {
            profilelbl.font = UIFont(name: card.additionalFont, size: profilelbl.font.pointSize)
            buianesslbl.font = UIFont(name: card.additionalFont, size: buianesslbl.font.pointSize)
            websitelbl.font = UIFont(name: card.additionalFont, size: websitelbl.font.pointSize)
            locationlbl.font = UIFont(name: card.additionalFont, size: locationlbl.font.pointSize)
            phonenlbl.font = UIFont(name: card.additionalFont, size: phonenlbl.font.pointSize)
            emailllbl.font = UIFont(name: card.additionalFont, size: emailllbl.font.pointSize)
        }
        profilelbl.text = card.fullName
        buianesslbl.text = card.companyName
        websitelbl.text = card.websiteUrl
        locationlbl.text = card.locationLink
        phonenlbl.text = card.phoneNo
        emailllbl.text = card.email

        // Load Images (you can use SDWebImage or similar libraries for async)
        if let profileURL = URL(string: card.profilePhotoPath) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profileURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImage.image = image
                    }
                }
            }
        }

        if let logoURL = URL(string: card.companyLogoPath) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: logoURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.buismesslogo.image = image
                    }
                }
            }
        }

        if let qrURL = URL(string: card.qrCodeFilePath) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: qrURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.qrimageofCard.image = image
                    }
                }
            }
        }

        // Optional: handle hiding or enabling buttons based on link availability
//        linkldenbtn.isHidden = card.linkedinLink.isEmpty
//        twiterXbtn.isHidden = card.tiktokLink.isEmpty
//        instagrambtn.isHidden = card.instagramLink.isEmpty
//        facebookbtn.isHidden = card.facebookLink.isEmpty
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = profileImage.frame.width / 2
     
        // Update shadow path if layout changes
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 12).cgPath
    }

}


extension Template7CVC: ScalableCardView {
    
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
extension Template7CVC: FontCustomizable {
    func applyFont(_ fontName: String) {
        guard let customFont = UIFont(name: fontName, size: 16) else { return }
        
        profilelbl.font = UIFont(name: fontName, size: profilelbl.font.pointSize)
        buianesslbl.font = UIFont(name: fontName, size: buianesslbl.font.pointSize)
        websitelbl.font = UIFont(name: fontName, size: websitelbl.font.pointSize)
        locationlbl.font = UIFont(name: fontName, size: locationlbl.font.pointSize)
        phonenlbl.font = UIFont(name: fontName, size: phonenlbl.font.pointSize)
        emailllbl.font = UIFont(name: fontName, size: emailllbl.font.pointSize)
    }
}
