//
//  Template2CVC.swift
//  QR App
//
//  Created by Touheed khan on 04/06/2025.
//

import UIKit

class Template2CVC: UICollectionViewCell {

    @IBOutlet weak var buianesslbl: UILabel!
    @IBOutlet weak var profilelbl: UILabel!
    @IBOutlet weak var buismesslogo: UIImageView!
    @IBOutlet weak var qrimageofCard: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var websitelbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var phonenlbl: UILabel!
    @IBOutlet weak var emailllbl: UILabel!
    @IBOutlet weak var whatsappbtn: UIButton!
    @IBOutlet weak var snapchatbtn: UIButton!
    @IBOutlet weak var facebookbtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var tiktokbtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
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

        // Update shadow path if layout changes
        cardView.layer.shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 12).cgPath
    }



}
extension Template2CVC: ScalableCardView {
    
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
