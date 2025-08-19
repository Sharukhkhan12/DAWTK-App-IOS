//
//  InvitationPreViewVC.swift
//  QR App
//
//  Created by Touheed khan on 15/08/2025.
//

import UIKit

class InvitationPreViewVC: UIViewController {
    
    @IBOutlet weak var updatelbl: UILabel!
    @IBOutlet weak var waleetShareStack: UIStackView!
    @IBOutlet weak var previewCardslbl: UILabel!
    @IBOutlet weak var previewInvitation: UIView!
    @IBOutlet weak var updateView: DesignableView!
    var userCard: InvitationModel!
    var profileImage: UIImage?
    var qrCodeTransparentImage: UIImage?
    var userID = ""
    var cardKey = ""
    let templateInvitationIdentifiers = [
        "InvitationTemplatesCVC1",
        "InvitationTemplatesCVC2",
        "InvitationTemplatesCVC3",
        "InvitationTemplatesCVC4",
        "InvitationTemplatesCVC5",
        "InvitationTemplatesCVC7",
        "InvitationTemplatesCVC8",
        "InvitationTemplatesCVC9",
        "InvitationTemplatesCVC10",
        "InvitationTemplatesCVC11",
        "InvitationTemplatesCVC12",
        "InvitationTemplatesCVC13",
        "InvitationTemplatesCVC14"
    ]
    
    var progressAlert = ProgressAlertView()
    var userSelectedProfileTemplate = false
    var userFromMyCardsScreen = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            
            if self.userFromMyCardsScreen {
                self.updatelbl.text = "Update"
                self.updateView.isHidden = false
                self.waleetShareStack.isHidden = true
                self.loadTheView()
            } else {
                self.updateView.isHidden = true
                self.waleetShareStack.isHidden = false
                self.progressAlert.show()
                self.setCardInitialInFirebase()
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func didTapSave(_ sender: Any) {
        if userSelectedProfileTemplate {
            
            DispatchQueue.main.async {
                self.savedCardWithProfile()
            }
        } else {
            DispatchQueue.main.async {
                self.savedCard()
            }
        }
    }
    
    @IBAction func didTapUpdateCard(_ sender: Any) {
        if userSelectedProfileTemplate {
            
            DispatchQueue.main.async {
                self.savedCardWithProfile()
            }
        } else {
            DispatchQueue.main.async {
                self.savedCard()
            }
        }
    }
    
    
    
    @IBAction func didTapWallet(_ sender: Any) {
    }
    
    
    
    func setCardInitialInFirebase() {
        
        if let currentUser = UserModel.shared?.userId {
            userID = currentUser
            userCard.ownerId = userID
            print("✅ UserID \(userID)")
        }
        
        if let card =  self.userCard {
            FirebaseManager.shared.saveUserInvitationCard(card: card) { result in
                switch result {
                case .success(let cardKey):
                    print("📦 Business card created with key: \(cardKey)")
                    self.cardKey = cardKey
                    if let qrImage = self.generateQRCode(from: cardKey) {
                        if let whiteQrImage =  self.generateQRCodeWithBackground(from: cardKey) {
                            
                        }
                        self.qrCodeTransparentImage = qrImage
                        self.loadTheView()
                    }
                    self.progressAlert.dismiss()
                    // Step 2: Upload profile image
                case .failure(let error):
                    self.progressAlert.dismiss()
                    print("❌ Failed to save card: \(error.localizedDescription)")
                    
                }
                
            }
        }
    }
    
    
    // MARK: - Generate QR Code
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        
        // Step 1: Create QR Code
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")
        guard let qrImage = qrFilter.outputImage else { return nil }
        
        // Step 2: Apply color filter to make background transparent
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        colorFilter.setValue(qrImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(color: .black), forKey: "inputColor0") // QR color
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0, alpha: 0), forKey: "inputColor1") // Transparent background
        
        guard let coloredImage = colorFilter.outputImage else { return nil }
        
        // Step 3: Scale it up
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = coloredImage.transformed(by: transform)
        
        return convertCIImageToUIImageTransparent(ciImage: scaledImage)
    }
    
    
    
    
    func convertCIImageToUIImageTransparent(ciImage: CIImage) -> UIImage? {
        let context = CIContext(options: nil)
        
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
    
    
    
    func generateQRCodeWithBackground(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("M", forKey: "inputCorrectionLevel")
            
            if let outputImage = filter.outputImage {
                // Scale the QR code to make it higher resolution
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledImage = outputImage.transformed(by: transform)
                return UIImage(ciImage: scaledImage)
            }
        }
        
        return nil
    }
    
    
    
    // MARK: - load The View
    
    func loadTheView() {
        loadSelectedCardView(in: self.previewInvitation) { [weak self] templateView in
            guard let self = self, let templateView = templateView else { return }

            // Clear previous preview
            self.previewInvitation.subviews.forEach { $0.removeFromSuperview() }

            // Embed the templateView with full-edge constraints
            templateView.translatesAutoresizingMaskIntoConstraints = false
            self.previewInvitation.addSubview(templateView)
            NSLayoutConstraint.activate([
                templateView.topAnchor.constraint(equalTo: self.previewInvitation.topAnchor),
                templateView.bottomAnchor.constraint(equalTo: self.previewInvitation.bottomAnchor),
                templateView.leadingAnchor.constraint(equalTo: self.previewInvitation.leadingAnchor),
                templateView.trailingAnchor.constraint(equalTo: self.previewInvitation.trailingAnchor)
            ])
            
           

            // Force layout if needed
            self.previewInvitation.layoutIfNeeded()
            templateView.layoutIfNeeded()
        }
    }

        
        
        // MARK: - loa dSelected Card View
        func loadSelectedCardView(in container: UIView, completion: @escaping (UIView?) -> Void) {
            guard let templateName = userCard?.templateName else {
                print("❌ No template name in cardInfo")
                completion(nil)
                return
            }
            
            var view: UIView?
            // 🔄 Add activity indicator
            switch templateName {
            case "1":
                print("tempName: \"1\"")
                
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC1", owner: nil, options: nil)?.first as? InvitationTemplatesCVC1 {
                    
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = qrCodeTransparentImage
                        view = cell
                    }
                    
                   
                }
                
                
            case "2":
                print("tempName: \"2\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC2", owner: nil, options: nil)?.first as? InvitationTemplatesCVC2 {
                   
                    
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        view = cell
                    }
                    
                }
                
                
            case "3":
                print("tempName: \"3\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC3", owner: nil, options: nil)?.first as? InvitationTemplatesCVC3 {
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        view = cell
                    }
               
                }
            case "4":
                print("tempName: \"4\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC4", owner: nil, options: nil)?.first as? InvitationTemplatesCVC4 {
                    
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        cell.profileImageView.image = profileImage
                        view = cell
                    }
                    
                 
                }
                
            case "5":
                print("tempName: \"5\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC5", owner: nil, options: nil)?.first as? InvitationTemplatesCVC5 {
                    
                    
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        cell.profileImageView.image = profileImage
                        view = cell
                    }
                    
                  
                }
                
            case "6":
                print("tempName: \"6\"") // skipping CVC6
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC7", owner: nil, options: nil)?.first as? InvitationTemplatesCVC7 {
                    
                    
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        cell.profileImageView.image = profileImage
                        view = cell
                    }
                    
                   
                }
            case "7":
                print("tempName: \"7\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC8", owner: nil, options: nil)?.first as? InvitationTemplatesCVC8 {
                    
                    if userFromMyCardsScreen {
                        
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        view = cell
                    }
                    
               
                }
                
            case "8":
                print("tempName: \"8\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC9", owner: nil, options: nil)?.first as? InvitationTemplatesCVC9 {
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        view = cell
                    }
                }
                
            case "9":
                print("tempName: \"9\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC10", owner: nil, options: nil)?.first as? InvitationTemplatesCVC10 {
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        view = cell
                    }
                }
                
            case "10":
                print("tempName: \"10\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC11", owner: nil, options: nil)?.first as? InvitationTemplatesCVC11 {
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        view = cell
                    }
                }
                
            case "11":
                print("tempName: \"11\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC12", owner: nil, options: nil)?.first as? InvitationTemplatesCVC12 {
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        view = cell
                    }
                }
            case "12":
                print("tempName: \"12\"")
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC13", owner: nil, options: nil)?.first as? InvitationTemplatesCVC13 {
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        view = cell
                    }
                }
            case "13":
                print("tempName: \"13\"")
                
                if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC14", owner: nil, options: nil)?.first as? InvitationTemplatesCVC14 {
                    if userFromMyCardsScreen {
                        cell.configure(with: self.userCard, userFromViewScreen: userFromMyCardsScreen)
                        view = cell
                    } else {
                        cell.configure(with: self.userCard, userFromViewScreen: false)
                        cell.qrScanImage.image = self.qrCodeTransparentImage
                        view = cell
                    }
                }
                
            default:
                print("Unknown template")
                
            }
            completion(view)
        }
        
    }
    

