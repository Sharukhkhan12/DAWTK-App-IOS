//
//  CreateLogoVC.swift
//  QR App
//
//  Created by Touheed khan on 02/06/2025.
//

import UIKit

class CreateLogoVC: UIViewController {

    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var firebaseLogoImage: UIImage?
    var imageSelected: UIImage?
    var imageURL: URL?
    var sheetVC = SheetVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.clipsToBounds = true
        
        if let firebaseLogoImage = self.firebaseLogoImage {
            self.placeHolderImage.isHidden = true
            self.imageSelected = firebaseLogoImage
            setProfileImage(firebaseLogoImage, animated: false)
        } else {
            self.placeHolderImage.isHidden = false
            self.logoImageView.isHidden = true
        }
        
        
        setuUpClickableImages()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Make it circular based on the current layout
        let side = min(logoImageView.bounds.width, logoImageView.bounds.height)
        logoImageView.layer.cornerRadius = side / 2
        
    }
    
    
    // MARK: - Set uUp Click able Images
    func setuUpClickableImages() {
        // Enable interaction
        logoImageView.isUserInteractionEnabled = true
        placeHolderImage.isUserInteractionEnabled = true
        
        // Add taps
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileOrPlaceholder(_:)))
        logoImageView.addGestureRecognizer(profileTap)
        
        let placeholderTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileOrPlaceholder(_:)))
        placeHolderImage.addGestureRecognizer(placeholderTap)
    }
    
    
    @objc private func didTapProfileOrPlaceholder(_ gesture: UITapGestureRecognizer) {
        // You can distinguish if needed:
        if gesture.view === logoImageView {
            print("Profile image tapped")
        } else if gesture.view === placeHolderImage {
            print("Placeholder tapped")
        }
        openOptionsSheets() // or whatever action you want
    }
    
    // MARK: - Set Profile Image

    private func setProfileImage(_ image: UIImage?, animated: Bool) {
        guard let image = image else { return }
        if animated {
            UIView.transition(with: logoImageView, duration: 0.25, options: .transitionCrossDissolve) {
                self.logoImageView.image = image
            }
        } else {
            logoImageView.image = image
        }
    }
    
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .didTapBackButtonFromLogoScreen, object: nil)
        }
    }
    
    @IBAction func didTapAddLogo(_ sender: Any) {
        self.dismissController()
    }
    
    // MARK: - Dismiss Controller
    
    func dismissController() {
        if let profileImage = self.imageSelected {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .didTapBackButtonFromLogoScreen, object: nil)
                // Post notification with both image and URL (if available)
                  var userInfo: [String: Any] = ["image": profileImage]
                if let url = self.imageURL {
                      userInfo["imageURL"] = url
                  }
                NotificationCenter.default.post(name: .imageSelectedForLogo, object: nil, userInfo: userInfo)
            }
        } else {
            let alert = UIAlertController(
                title: "No Image",
                message: "Please select a profile image before continuing.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Open Options Sheets
    func openOptionsSheets() {
        print("openICloudSheet")
        sheetVC.modalPresentationStyle = .overCurrentContext
        sheetVC.delegete = self
        // keep false
        // modal animation will be handled in VC itself
        self.present(sheetVC, animated: false)
    }
    
    
}
extension CreateLogoVC: ImageSelectedFromSheet {
    func imageSelected(processImage: UIImage, imageURL: URL) {
        logoImageView.image = processImage
        logoImageView.layoutIfNeeded()
        let profileSide = min(logoImageView.frame.width, logoImageView.frame.height)
        logoImageView.layer.cornerRadius = profileSide / 2
        logoImageView.clipsToBounds = true
        
        // Remove previous centered image view
        logoImageView?.removeFromSuperview()
        
        // Create and configure new centered image view
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = processImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        parentView.addSubview(imageView)
        
        // Store reference
        logoImageView = imageView
        
        // Set fixed width and height (e.g., 120x120)
        let fixedSize: CGFloat = 160
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: fixedSize),
            imageView.heightAnchor.constraint(equalToConstant: fixedSize)
        ])
        
        // Ensure layout and make it perfectly circular
        parentView.layoutIfNeeded()
        imageView.layer.cornerRadius = fixedSize / 2
        self.placeHolderImage.isHidden = true
        self.imageSelected = processImage
        self.imageURL = imageURL
//            NotificationCenter.default.post(name: .imageSelectedNotification, object: nil, userInfo: ["image": processImage])
    }
    
 
}
