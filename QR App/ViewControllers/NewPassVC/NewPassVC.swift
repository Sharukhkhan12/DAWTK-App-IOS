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
    
    // MARK: - Declartations
    var cardInfo: UserBusinessCardModel?
    var walletRequest: WalletPassRequest?
    var extractTheColor = ""
    var progressAlert = ProgressAlertView()
 
    var updatedParamter = [[String:Any]]()
    let parameters: [[String: Any]] = [  // ✅ master defaults
        ["key": "logo", "value": "/path/to/logo.png", "type": "file"],
        ["key": "logo_text", "value": "Default Logo Text", "type": "text"],
        ["key": "header_label", "value": "Member", "type": "text"],
        ["key": "primary_label", "value": "Primary Label", "type": "text"],
        ["key": "primary_value", "value": "Primary Value", "type": "text"],
        ["key": "strip_image_url", "value": "https://example.com/strip.png", "type": "text"],
        ["key": "secondary_label", "value": "Secondary Label", "type": "text"],
        ["key": "secondary_value", "value": "Secondary Value", "type": "text"],
        ["key": "auxiliary_label", "value": "Aux Label", "type": "text"],
        ["key": "auxiliary_value", "value": "Aux Value", "type": "text"],
        ["key": "barcode_message", "value": "1234567890", "type": "text"],
        ["key": "barcode_type", "value": "PDF417", "type": "text"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    @IBAction func didTapEventTicket(_ sender: Any) {
        
        
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
    
    
    @IBAction func didTapCouponCard(_ sender: Any) {
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
//        DispatchQueue.main.async {
//            self.uploadPassRequest()
//        }
    }

    
    
    @IBAction func didTapGenericCard(_ sender: Any) {
        
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
    
    /// Local helper func in controller
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





    // 🔧 Resize image to reduce size (important for avoiding memory issues)
    func resizedImage(_ image: UIImage, maxWidth: CGFloat = 500) -> UIImage? {
        let aspectRatio = image.size.width / image.size.height
        let width = min(image.size.width, maxWidth)
        let height = width / aspectRatio
        let size = CGSize(width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    func uploadPassRequest() {
        // 📦 Parameters to send
        let parameters: [[String: Any]] = [
            ["key": "strip_image_url", "value": "https://samples.fileformat.info/format/png/sample/40a6e65ed7fb44bc91a8a52aab47fdd4/MARBLE8.PNG", "type": "text"],
            ["key": "header_label", "value": "Member", "type": "text"],
            ["key": "ID header_value", "value": "000000", "type": "text"],
            ["key": "secondary_label", "value": "Email", "type": "text"],
            ["key": "secondary_value", "value": "dummy@gamil.com", "type": "text"],
            ["key": "back_label", "value": "Terms", "type": "text"],
            ["key": "back_value", "value": "Valid 360", "type": "text"],
            ["key": "logo_text", "value": "Acne", "type": "text"],
            ["key": "description", "value": "This is a sample description for the pass.", "type": "text"],
            ["key": "background_color", "value": "rgb(128, 223, 196)", "type": "text"],
            ["key": "foreground_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "label_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "barcode_message", "value": "1234567890", "type": "text"],
            ["key": "card_type", "value": "coupon", "type": "text"],
            ["key": "image_type", "value": "thumbnail", "type": "text"],
            ["key": "barcode_type", "value": "QR", "type": "text"],
            ["key": "primary_label", "value": "Director", "type": "text"],
            ["key": "primary_value", "value": "Sharukh", "type": "text"],
            ["key": "auxiliary_label", "value": "0305500554", "type": "text"],
            ["key": "auxiliary_value", "value": "xyz1", "type": "text"],
            ["key": "icon", "type": "file", "assetName": "logo12"],
            ["key": "logo", "type": "file", "assetName": "logo12"]
        ]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()

        for param in parameters {
            guard let key = param["key"] as? String,
                  let type = param["type"] as? String else {
                continue
            }

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"".data(using: .utf8)!)

            if type == "text", let value = param["value"] as? String {
                body.append("\r\n\r\n\(value)\r\n".data(using: .utf8)!)
            } else if type == "file", let assetName = param["assetName"] as? String {
                guard let image = UIImage(named: assetName),
                      let resized = resizedImage(image),
                      let imageData = resized.pngData() else {
                    print("⚠️ Failed to load or compress image from assets: \(assetName)")
                    continue
                }

                let sizeKB = Double(imageData.count) / 1024.0
                print("📸 Uploading \(assetName).png — Size: \(String(format: "%.2f", sizeKB)) KB")

                body.append("; filename=\"\(assetName).png\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        print("📦 Total body size: \(Double(body.count) / 1024.0) KB")

        // ✅ Create and send the request
        var request = URLRequest(url: URL(string: "https://googlewalletapi.onrender.com/apple/wallet-pass")!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        // 🔁 Execute the upload
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response.")
                return
            }

            print("📥 Status Code: \(httpResponse.statusCode)")

            guard let data = data else {
                print("❌ No data received.")
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("✅ Server Response:\n\(responseString)")
            } else {
                print("⚠️ Unable to decode server response.")
            }
        }

        task.resume()
    }


   
       private func downloadPass(from urlString: String) {
           guard let url = URL(string: urlString) else { return }
           
           let task = URLSession.shared.dataTask(with: url) { data, _, error in
               guard let data = data, error == nil else {
                   print("❌ Download error:", error?.localizedDescription ?? "Unknown")
                   return
               }
               
               DispatchQueue.main.async {
                   self.showPassKit(with: data)
               }
           }
           task.resume()
       }
       
       private func showPassKit(with data: Data) {
           do {
               let pass = try PKPass(data: data)
               let passVC = PKAddPassesViewController(pass: pass)
               passVC?.modalPresentationStyle = .formSheet
               self.present(passVC!, animated: true, completion: nil)
           } catch {
               print("❌ Failed to open PKPass:", error.localizedDescription)
           }
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

            print("✌️Extractted Color = ", extractedHex)
            // ✅ return only color
            completion(extractedHex)
        }
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
