//
//  Template8CVC.swift
//  QR App
//
//  Created by Touheed khan on 04/06/2025.
//

import UIKit

class Template8CVC: UICollectionViewCell {
    @IBOutlet weak var buianesslbl: UILabel!
    @IBOutlet weak var profilelbl: UILabel!
    @IBOutlet weak var buismesslogo: UIImageView!
    @IBOutlet weak var qrimageofCard: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var websitelbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var phonenlbl: UILabel!
    @IBOutlet weak var emailllbl: UILabel!
    @IBOutlet weak var linkldenbtn: UIButton!
    @IBOutlet weak var twiterXbtn: UIButton!
    @IBOutlet weak var instagrambtn: UIButton!
    @IBOutlet weak var facebookbtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        setupUI()
        
    }
    
  
    

    private func setupUI() {
        // Corner Radius
        mainView.layer.cornerRadius = 20
        mainView.layer.masksToBounds = false // Important for shadow to appear

        // Shadow
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.15
        mainView.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainView.layer.shadowRadius = 6

        // Shadow path (for performance)
        mainView.layer.shadowPath = UIBezierPath(roundedRect: mainView.bounds, cornerRadius: 12).cgPath
    }
    
    
    func configure(with card: UserBusinessCardModel) {
        // Set background color if available
           if !card.additionalBgColor.isEmpty {
               if let bgColor = UIColor(hex: card.additionalBgColor) {
                   self.mainView.backgroundColor = bgColor
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
        mainView.layer.shadowPath = UIBezierPath(roundedRect: mainView.bounds, cornerRadius: 12).cgPath
    }
}
extension Template8CVC: ScalableCardView {
    var cardContentView: UIView? {
        return mainView
        
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
extension Template8CVC: FontCustomizable {
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
