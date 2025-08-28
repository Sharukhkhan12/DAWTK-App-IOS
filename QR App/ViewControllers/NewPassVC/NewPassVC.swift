//
//  NewPassVC.swift
//  QR App
//
//  Created by Touheed khan on 21/08/2025.
//

import UIKit
import PassKit
class NewPassVC: UIViewController {
    @IBOutlet var bottomViewSheet: UIView!
    @IBOutlet var parentView: UIView!
    var segmeentsSelected: SegmentsSelected = .inviationCard

    // MARK: - Declartations
    var cardInfo: UserBusinessCardModel?
    var walletRequest: WalletPassRequest?
    var extractTheColor = ""
    var progressAlert = ProgressAlertView()
    var userInvitationCard: InvitationModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch segmeentsSelected{
            
        case .inviationCard:
            print("⚠️ inviationCard")
            loadSelectedCardViewForInnvite { extractedColor in
                if let hexColor = extractedColor,
                   let rgbString = hexColor.toRGBString() {
                    print("🎨 RGB Color: \(rgbString)")
                    let pngURL = self.userInvitationCard!.profilePhotoPath.asPNGUrl()
                    print("😂PNGURL-- ",pngURL)
                    self.extractTheColor = rgbString
                    
                    
                } else {
                    print("⚠️ No color extracted")
                }
            }
        case .BusinessCard:
            loadSelectedCardView { extractedColor in
                if let hexColor = extractedColor,
                   let rgbString = hexColor.toRGBString() {
                    print("🎨 RGB Color: \(rgbString)")
                    let pngURL = self.cardInfo!.companyLogoPath.asPNGUrl()
                    print("😂PNGURL-- ",pngURL)
                    self.extractTheColor = rgbString
                    
                    
                } else {
                    print("⚠️ No color extracted")
                }
            }
        }
        
        
    
        parentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

    }
    

    @IBAction func dismissScren(_ sender: UIButton) {
        UIView.animate(withDuration: 0.20, animations: {
            // Dono ko same transform apply kar rahe hain
            self.bottomViewSheet.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            
        }) { _ in
            self.dismiss(animated: false)
        }
        
    }
    
    
    @IBAction func didTapStoreCard(_ sender: Any) {
        
        
        switch segmeentsSelected{
            
        case .inviationCard:
            print("⚠️ inviationCard")
            
            
            
            DispatchQueue.main.async {
                self.progressAlert.show()
                InvitationWalletManager.shared.addToWalletForStoreCard(
                    card: self.userInvitationCard!,
                    background: self.extractTheColor
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("✅ Response:", response)
                            
                            // ✅ Call local function with response
                            self.handlePassResponse(response)
                            
                        case .failure(let error):
                            print("❌ Error:", error.localizedDescription)
                            self.progressAlert.dismiss()
                        }
                    }
                }
            }
            
        case .BusinessCard:
            
            DispatchQueue.main.async {
                self.progressAlert.show()
                WalletManager.shared.addToWalletForStoreCard(
                    card: self.cardInfo!,
                    background: self.extractTheColor
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("✅ Response:", response)
                            
                            // ✅ Call local function with response
                            self.handlePassResponse(response)
                            
                        case .failure(let error):
                            print("❌ Error:", error.localizedDescription)
                            self.progressAlert.dismiss()
                        }
                    }
                }
            }
        }
        
       
        
    }
    @IBAction func didTapEventTicket(_ sender: Any) {
        
        
        
        switch segmeentsSelected{
            
        case .inviationCard:
            print("⚠️ inviationCard")
            
            DispatchQueue.main.async {
                self.progressAlert.show()
                InvitationWalletManager.shared.addToWalletForEventTicket(
                    card: self.userInvitationCard!,
                    background: self.extractTheColor
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("✅ Response:", response)
                            
                            // ✅ Call local function with response
                            self.handlePassResponse(response)
                            
                        case .failure(let error):
                            print("❌ Error:", error.localizedDescription)
                            self.progressAlert.dismiss()
                        }
                    }
                }
            }
        case .BusinessCard:
            
            DispatchQueue.main.async {
                self.progressAlert.show()
                WalletManager.shared.addToWalletForEventTicket(
                    card: self.cardInfo!,
                    background: self.extractTheColor
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("✅ Response:", response)
                            
                            // ✅ Call local function with response
                            self.handlePassResponse(response)
                            
                        case .failure(let error):
                            print("❌ Error:", error.localizedDescription)
                            self.progressAlert.dismiss()
                        }
                    }
                }
            }
        }
        
        
      
        
        
    }
    
    
    @IBAction func didTapCouponCard(_ sender: Any) {
        
        switch segmeentsSelected{
            
        case .inviationCard:
            print("⚠️ inviationCard")
            
            DispatchQueue.main.async {
                self.progressAlert.show()
                InvitationWalletManager.shared.addToWalletForCoupnn(
                    card: self.userInvitationCard!,
                    background: self.extractTheColor
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("✅ Response:", response)
                            
                            // ✅ Call local function with response
                            self.handlePassResponse(response)
                            
                        case .failure(let error):
                            print("❌ Error:", error.localizedDescription)
                            self.progressAlert.dismiss()
                        }
                    }
                }
            }
        case .BusinessCard:
            
            DispatchQueue.main.async {
                self.progressAlert.show()
                WalletManager.shared.addToWalletForCoupnn(
                    card: self.cardInfo!,
                    background: self.extractTheColor
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("✅ Response:", response)
                            
                            // ✅ Call local function with response
                            self.handlePassResponse(response)
                            
                        case .failure(let error):
                            print("❌ Error:", error.localizedDescription)
                            self.progressAlert.dismiss()
                        }
                    }
                }
            }
        }
    }
    @IBAction func didTapGenericCard(_ sender: Any) {
        
        
        switch segmeentsSelected{
            
        case .inviationCard:
            print("⚠️ inviationCard")
            DispatchQueue.main.async {
                self.progressAlert.show()
                InvitationWalletManager.shared.addToWalletForGeneric(
                    card: self.userInvitationCard!,
                    background: self.extractTheColor
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("✅ Response:", response)
                            
                            // ✅ Call local function with response
                            self.handlePassResponse(response)
                            
                        case .failure(let error):
                            print("❌ Error:", error.localizedDescription)
                            self.progressAlert.dismiss()
                        }
                    }
                }
            }
        case .BusinessCard:
            
            DispatchQueue.main.async {
                self.progressAlert.show()
                WalletManager.shared.addToWalletForGeneric(
                    card: self.cardInfo!,
                    background: self.extractTheColor
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("✅ Response:", response)
                            
                            // ✅ Call local function with response
                            self.handlePassResponse(response)
                            
                        case .failure(let error):
                            print("❌ Error:", error.localizedDescription)
                            self.progressAlert.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - // Local helper func in controller
    private func handlePassResponse(_ responseString: String) {
        guard let data = responseString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let fileURL = json["file"] as? String,
              let url = URL(string: fileURL) else {
            print("❌ Invalid JSON or file URL")
            return
        }
        
        // Download pkpass file
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Download error:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("❌ No data from pkpass URL")
                return
            }
            
            do {
                let pass = try PKPass(data: data)
                DispatchQueue.main.async {
                    self.progressAlert.dismiss()
                    if let passVC = PKAddPassesViewController(pass: pass) {
                        self.present(passVC, animated: true, completion: nil)
                    }
                }
            } catch {
                print("❌ PKPass init error:", error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: - load Selected Card View
    func loadSelectedCardView(
        completion: @escaping (_ extractedColor: String?) -> Void
    ) {
        guard let templateName = cardInfo?.templateName else {
            print("❌ No template name in cardInfo")
            completion(nil)
            return
        }

        let group = DispatchGroup()

        group.notify(queue: .main) {
            var extractedHex: String?

            switch templateName {
            case "1":
                if let cell = Bundle.main.loadNibNamed("Template8CVC", owner: nil, options: nil)?.first as? Template8CVC {
                    cell.configure(with: self.cardInfo!)
                    extractedHex = cell.extractedCardColor?.toHexString()
                }
            case "2":
                if let cell = Bundle.main.loadNibNamed("Template7CVC", owner: nil, options: nil)?.first as? Template7CVC {
                    cell.configure(with: self.cardInfo!)
                    extractedHex = cell.extractedCardColor?.toHexString()
                }
            case "3":
                if let cell = Bundle.main.loadNibNamed("Template6CVC", owner: nil, options: nil)?.first as? Template6CVC {
                    cell.configure(with: self.cardInfo!)
                    extractedHex = cell.extractedCardColor?.toHexString()
                }
            case "4":
                if let cell = Bundle.main.loadNibNamed("Template5CVC", owner: nil, options: nil)?.first as? Template5CVC {
                    cell.configure(with: self.cardInfo!)
                    extractedHex = cell.extractedCardColor?.toHexString()
                }
            case "5":
                if let cell = Bundle.main.loadNibNamed("Template4CVC", owner: nil, options: nil)?.first as? Template4CVC {
                    cell.configure(with: self.cardInfo!)
                    extractedHex = cell.extractedCardColor?.toHexString()
                }
            case "6":
                if let cell = Bundle.main.loadNibNamed("Template3CVC", owner: nil, options: nil)?.first as? Template3CVC {
                    cell.configure(with: self.cardInfo!)
                    extractedHex = cell.extractedCardColor?.toHexString()
                }
            case "7":
                if let cell = Bundle.main.loadNibNamed("Template2CVC", owner: nil, options: nil)?.first as? Template2CVC {
                    cell.configure(with: self.cardInfo!)
                    extractedHex = cell.extractedCardColor?.toHexString()
                }
            default:
                print("⚠️ Unknown template identifier: \(templateName)")
            }
            // ✅ return only color
            completion(extractedHex)
        }
    }
    
    
    // MARK: - loadSelected Card View
    func loadSelectedCardViewForInnvite(completion: @escaping (_ extractedColor: String?) -> Void) {
        guard let templateName = userInvitationCard?.templateName else {
            print("❌ No template name in cardInfo")
            completion(nil)
            return
        }
        
        var extractedHex: String?
        // 🔄 Add activity indicator
        switch templateName {
        case "1":
            print("tempName: \"1\"")
            
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC1", owner: nil, options: nil)?.first as? InvitationTemplatesCVC1 {
                
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
               
            }
            
            
        case "2":
            print("tempName: \"2\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC2", owner: nil, options: nil)?.first as? InvitationTemplatesCVC2 {
               
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
              
                
            }
            
            
        case "3":
            print("tempName: \"3\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC3", owner: nil, options: nil)?.first as? InvitationTemplatesCVC3 {
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
           
            }
        case "4":
            print("tempName: \"4\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC4", owner: nil, options: nil)?.first as? InvitationTemplatesCVC4 {
                
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
                
             
            }
            
        case "5":
            print("tempName: \"5\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC5", owner: nil, options: nil)?.first as? InvitationTemplatesCVC5 {
                
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
              
                
              
            }
            
        case "6":
            print("tempName: \"6\"") // skipping CVC6
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC7", owner: nil, options: nil)?.first as? InvitationTemplatesCVC7 {
                
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
              
               
            }
        case "7":
            print("tempName: \"7\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC8", owner: nil, options: nil)?.first as? InvitationTemplatesCVC8 {
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
              
                
           
            }
            
        case "8":
            print("tempName: \"8\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC9", owner: nil, options: nil)?.first as? InvitationTemplatesCVC9 {
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
            }
            
        case "9":
            print("tempName: \"9\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC10", owner: nil, options: nil)?.first as? InvitationTemplatesCVC10 {
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
            }
            
        case "10":
            print("tempName: \"10\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC11", owner: nil, options: nil)?.first as? InvitationTemplatesCVC11 {
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
            }
            
        case "11":
            print("tempName: \"11\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC12", owner: nil, options: nil)?.first as? InvitationTemplatesCVC12 {
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
            }
        case "12":
            print("tempName: \"12\"")
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC13", owner: nil, options: nil)?.first as? InvitationTemplatesCVC13 {
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                view = cell
                
            }
        case "13":
            print("tempName: \"13\"")
            
            if let cell = Bundle.main.loadNibNamed("InvitationTemplatesCVC14", owner: nil, options: nil)?.first as? InvitationTemplatesCVC14 {
                cell.configure(with: self.userInvitationCard, userFromViewScreen: true)
                extractedHex = cell.extractedCardColor?.toHexString()
                
            }
            
        default:
            print("Unknown template")
            
        }
        // ✅ return only color
        completion(extractedHex)
    }

    
    
   
    
}


extension String {
    /// Convert HEX string (e.g. "#FF0000" or "FF0000") into RGB format
    func toRGBString() -> String? {
        var hex = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Remove "#" if present
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        
        // Hex must be 6 characters
        guard hex.count == 6,
              let rgbValue = UInt64(hex, radix: 16) else {
            return nil
        }
        
        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0x00FF00) >> 8
        let b = rgbValue & 0x0000FF
        
        return "rgb(\(r), \(g), \(b))"
    }
    
    
    func asPNGUrl() -> String {
        if self.lowercased().hasSuffix(".png") {
            return self
        } else {
            // Agar already koi extension hai (.jpg/.jpeg/.webp etc.)
            if let dotIndex = self.lastIndex(of: ".") {
                let base = self[..<dotIndex]
                return "\(base).png"
            } else {
                // Agar koi extension hi nahi hai to default .png append kar do
                return self + ".png"
            }
        }
    }        
        
      
    
    
    
    
}
extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
