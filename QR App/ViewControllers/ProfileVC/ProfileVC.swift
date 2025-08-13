//
//  ProfileVC.swift
//  QR App
//
//  Created by Touheed khan on 01/06/2025.
//

import UIKit
class ProfileVC: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet weak var placeHolderImage: UIImageView!
    @IBOutlet weak var profilelbl: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    // MARK: - Declarations
    var imageURL: URL?

    var firebaseProfileImage: UIImage?
    var sheetVC = SheetVC()
    var imageSelected: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        
        if let firebaseProfileImage = self.firebaseProfileImage {
            self.placeHolderImage.isHidden = true
            self.imageSelected = firebaseProfileImage
            setProfileImage(firebaseProfileImage, animated: false)
        } else {
            self.placeHolderImage.isHidden = false
            self.profileImage.isHidden = true
        }
        
        
        setuUpClickableImages()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Set uUp Click able Images
    func setuUpClickableImages() {
        // Enable interaction
        profileImage.isUserInteractionEnabled = true
        placeHolderImage.isUserInteractionEnabled = true
        
        // Add taps
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileOrPlaceholder(_:)))
        profileImage.addGestureRecognizer(profileTap)
        
        let placeholderTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileOrPlaceholder(_:)))
        placeHolderImage.addGestureRecognizer(placeholderTap)
    }
    
    
    @objc private func didTapProfileOrPlaceholder(_ gesture: UITapGestureRecognizer) {
        // You can distinguish if needed:
        if gesture.view === profileImage {
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
            UIView.transition(with: profileImage, duration: 0.25, options: .transitionCrossDissolve) {
                self.profileImage.image = image
            }
        } else {
            profileImage.image = image
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Make it circular based on the current layout
        let side = min(profileImage.bounds.width, profileImage.bounds.height)
        profileImage.layer.cornerRadius = side / 2
        
    }
    
    
    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .didTapBackButtonFromLogoScreen, object: nil)
        }
    }
    
    @IBAction func didTapPhtot(_ sender: Any) {
        self.dismissController()

    }
    
    
    // MARK: - Dismiss Controller
    
    func dismissController() {
        if let profileImage = self.imageSelected {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .didTapBackButtonFromLogoScreen, object: nil)

                var userInfo: [String: Any] = ["image": profileImage]
                if let url = self.imageURL {
                    userInfo["imageURL"] = url
                }

                // Correct: send image and optional URL directly, not nested
                NotificationCenter.default.post(name: .imageSelectedNotification, object: nil, userInfo: userInfo)
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

// MARK: - ImageSelectedFromSheet
extension ProfileVC: ImageSelectedFromSheet {
        
            func imageSelected(processImage: UIImage, imageURL: URL) {
            // Set profile image and make it circular
            profileImage.image = processImage
            profileImage.layoutIfNeeded()
            let profileSide = min(profileImage.frame.width, profileImage.frame.height)
            profileImage.layer.cornerRadius = profileSide / 2
            profileImage.clipsToBounds = true
            
            // Remove previous centered image view
            profileImage?.removeFromSuperview()
            
            // Create and configure new centered image view
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = processImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            parentView.addSubview(imageView)
            
            // Store reference
            profileImage = imageView
            
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


