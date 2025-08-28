//
//  InvitationWalletManager.swift
//  QR App
//
//  Created by Touheed khan on 28/08/2025.
//

import Foundation
import Foundation
import UIKit
class InvitationWalletManager {
    
    static let shared = InvitationWalletManager()
    private init() {}
    
    // MARK: - Add To Wallet with Completion
    func addToWalletForCoupnn(card: InvitationModel, background: String, completion: @escaping (Result<String, Error>) -> Void) {

        print("🎨 Background color: \(background)")

        
        let parameters: [[String: Any]] = [
            ["key": "strip_image_url", "value": "https://samples.fileformat.info/format/png/sample/40a6e65ed7fb44bc91a8a52aab47fdd4/MARBLE8.PNG", "type": "text"],
            ["key": "header_label", "value": "DAWTK | دعوتك", "type": "text"],
            ["key": "ID header_value", "value": "000000", "type": "text"],
            ["key": "secondary_label", "value": "Islamic Date", "type": "text"],
            ["key": "secondary_value", "value": "\(card.islamicDate)", "type": "text"],
            ["key": "back_label", "value": "Terms", "type": "text"],
            ["key": "back_value", "value": "Valid 360", "type": "text"],
            ["key": "logo_text", "value": "Invitation Card", "type": "text"],
            ["key": "description", "value": "This is a sample description for the pass.", "type": "text"],
            ["key": "background_color", "value": background, "type": "text"],
            ["key": "foreground_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "label_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "barcode_message", "value": "\(card.qrCode)", "type": "text"],
            ["key": "card_type", "value": "coupon", "type": "text"],
            ["key": "image_type", "value": "thumbnail", "type": "text"],
            ["key": "barcode_type", "value": "PDF417", "type": "text"],
            ["key": "primary_label", "value": "Bride Name \(card.brideName)", "type": "text"],
            ["key": "primary_value", "value": card.photography, "type": "text"],
            ["key": "auxiliary_label", "value": "Groom Name \(card.groomName)", "type": "text"],
            ["key": "auxiliary_value", "value": "Date \((card.date))", "type": "text"],
            ["key": "icon", "type": "file", "assetName": "AppLogo"],
            ["key": "logo", "type": "file", "assetName": "AppLogo"]
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
                    print("⚠️ Failed to load or compress image from asset: \(assetName)")
                    continue
                }

                let sizeKB = Double(imageData.count) / 1024.0
                print("📸 Uploading image from asset '\(assetName).png' — Size: \(String(format: "%.2f", sizeKB)) KB")

                body.append("; filename=\"\(assetName).png\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        print("📦 Total body size: \(Double(body.count) / 1024.0) KB")

        var request = URLRequest(url: URL(string: "https://googlewalletapi.onrender.com/apple/wallet-pass")!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "WalletPassError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                print("❌ Invalid HTTP response")
                completion(.failure(error))
                return
            }

            print("📥 HTTP Status Code: \(httpResponse.statusCode)")

            guard let data = data else {
                let error = NSError(domain: "WalletPassError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received")
                completion(.failure(error))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("✅ Server Response:\n\(responseString)")
                completion(.success(responseString))
            } else {
                let error = NSError(domain: "WalletPassError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to decode server response"])
                print("⚠️ Unable to decode server response.")
                completion(.failure(error))
            }
        }

        task.resume()
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
    
    
    
    
    func addToWalletForGeneric(card: InvitationModel, background: String, completion: @escaping (Result<String, Error>) -> Void) {

        print("🎨 Background color: \(background)")
        
        let parameters: [[String: Any]] = [
            ["key": "strip_image_url", "value": "\(card.profilePhotoPath)", "type": "text"],
            ["key": "header_label", "value": "DAWTK | دعوتك", "type": "text"],
            ["key": "ID header_value", "value": "000000", "type": "text"],
            ["key": "secondary_label", "value": "Islamic Date", "type": "text"],
            ["key": "secondary_value", "value": card.islamicDate, "type": "text"],
            ["key": "back_label", "value": "Terms", "type": "text"],
            ["key": "back_value", "value": "Valid 360", "type": "text"],
            ["key": "logo_text", "value": "Invitation Card", "type": "text"],
            ["key": "description", "value": "This is a sample description for the pass.", "type": "text"],
            ["key": "background_color", "value": background, "type": "text"],
            ["key": "foreground_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "label_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "barcode_message", "value": "\(card.qrCode)", "type": "text"],
            ["key": "card_type", "value": "generic", "type": "text"],
            ["key": "image_type", "value": "thumbnail", "type": "text"],
            ["key": "barcode_type", "value": "QR", "type": "text"],
            ["key": "primary_label", "value": "Bride Name \(card.brideName)", "type": "text"],
            ["key": "primary_value", "value": card.photography, "type": "text"],
            ["key": "auxiliary_label", "value": "Groom Name \(card.groomName)", "type": "text"],
            ["key": "auxiliary_value", "value": "Date\((card.date))", "type": "text"],
            ["key": "icon", "type": "file", "assetName": "AppLogo"],
            ["key": "logo", "type": "file", "assetName": "AppLogo"]
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
                    print("⚠️ Failed to load or compress image from asset: \(assetName)")
                    continue
                }

                let sizeKB = Double(imageData.count) / 1024.0
                print("📸 Uploading image from asset '\(assetName).png' — Size: \(String(format: "%.2f", sizeKB)) KB")

                body.append("; filename=\"\(assetName).png\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        print("📦 Total body size: \(Double(body.count) / 1024.0) KB")

        var request = URLRequest(url: URL(string: "https://googlewalletapi.onrender.com/apple/wallet-pass")!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "WalletPassError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                print("❌ Invalid HTTP response")
                completion(.failure(error))
                return
            }

            print("📥 HTTP Status Code: \(httpResponse.statusCode)")

            guard let data = data else {
                let error = NSError(domain: "WalletPassError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received")
                completion(.failure(error))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("✅ Server Response:\n\(responseString)")
                completion(.success(responseString))
            } else {
                let error = NSError(domain: "WalletPassError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to decode server response"])
                print("⚠️ Unable to decode server response.")
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    
    
    
    func addToWalletForEventTicket(card: InvitationModel, background: String, completion: @escaping (Result<String, Error>) -> Void) {

        print("🎨 Background color: \(background)")
        
        let parameters: [[String: Any]] = [
            ["key": "strip_image_url", "value": "\(card.profilePhotoPath)", "type": "text"],
            ["key": "header_label", "value": "DAWTK | دعوتك", "type": "text"],
            ["key": "ID header_value", "value": "000000", "type": "text"],
            ["key": "secondary_label", "value": "Groom Name \(card.groomName)", "type": "text"],
            ["key": "secondary_value", "value": "Bride Name \(card.brideName)", "type": "text"],
             ["key": "back_label", "value": "Terms", "type": "text"],
            ["key": "back_value", "value": "Valid 360", "type": "text"],
            ["key": "logo_text", "value": "Invitation Card", "type": "text"],
            ["key": "description", "value": "This is a sample description for the pass.", "type": "text"],
            ["key": "background_color", "value": background, "type": "text"],
            ["key": "foreground_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "label_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "barcode_message", "value": "\(card.qrCode)", "type": "text"],
            ["key": "card_type", "value": "eventticket", "type": "text"],
            ["key": "image_type", "value": "strip", "type": "text"],
            ["key": "barcode_type", "value": "PDF417", "type": "text"],
            ["key": "primary_label", "value": "Director", "type": "text"],
            ["key": "primary_value", "value": "", "type": "text"],
            ["key": "auxiliary_label", "value": "(Islamic Date \(card.islamicDate)", "type": "text"],
            ["key": "auxiliary_value", "value": "Date \(card.date)", "type": "text"],
            ["key": "icon", "type": "file", "assetName": "AppLogo"],
            ["key": "logo", "type": "file", "assetName": "AppLogo"]
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
                    print("⚠️ Failed to load or compress image from asset: \(assetName)")
                    continue
                }

                let sizeKB = Double(imageData.count) / 1024.0
                print("📸 Uploading image from asset '\(assetName).png' — Size: \(String(format: "%.2f", sizeKB)) KB")

                body.append("; filename=\"\(assetName).png\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        print("📦 Total body size: \(Double(body.count) / 1024.0) KB")

        var request = URLRequest(url: URL(string: "https://googlewalletapi.onrender.com/apple/wallet-pass")!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "WalletPassError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                print("❌ Invalid HTTP response")
                completion(.failure(error))
                return
            }

            print("📥 HTTP Status Code: \(httpResponse.statusCode)")

            guard let data = data else {
                let error = NSError(domain: "WalletPassError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received")
                completion(.failure(error))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("✅ Server Response:\n\(responseString)")
                completion(.success(responseString))
            } else {
                let error = NSError(domain: "WalletPassError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to decode server response"])
                print("⚠️ Unable to decode server response.")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
    func addToWalletForStoreCard(card: InvitationModel, background: String, completion: @escaping (Result<String, Error>) -> Void) {

        print("🎨 Background color: \(background)")

        let parameters: [[String: Any]] = [
            ["key": "strip_image_url", "value": "\(card.profilePhotoPath)", "type": "text"],
            ["key": "header_label", "value": "DAWTK | دعوتك", "type": "text"],
            ["key": "ID header_value", "value": "000000", "type": "text"],
            ["key": "secondary_label", "value": "Groom Name", "type": "text"],
            ["key": "secondary_value", "value": card.groomName, "type": "text"],
            ["key": "back_label", "value": "Terms", "type": "text"],
            ["key": "back_value", "value": "Valid 360", "type": "text"],
            ["key": "logo_text", "value": "Invitation Card", "type": "text"],
            ["key": "description", "value": "This is a sample description for the pass.", "type": "text"],
            ["key": "background_color", "value": background, "type": "text"],
            ["key": "foreground_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "label_color", "value": "rgb(0, 0, 0)", "type": "text"],
            ["key": "barcode_message", "value": "\(card.qrCode)", "type": "text"],
            ["key": "card_type", "value": "storecard", "type": "text"],
            ["key": "image_type", "value": "strip", "type": "text"],
            ["key": "barcode_type", "value": "PDF417", "type": "text"],
            ["key": "primary_label", "value": "Bride Name \(card.brideName)", "type": "text"],
            ["key": "primary_value", "value": card.photography, "type": "text"],
            ["key": "auxiliary_label", "value": "Islamic Date\(card.islamicDate)", "type": "text"],
            ["key": "auxiliary_value", "value": "Date\((card.date))", "type": "text"],
            ["key": "icon", "type": "file", "assetName": "AppLogo"],
            ["key": "logo", "type": "file", "assetName": "AppLogo"]
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
                    print("⚠️ Failed to load or compress image from asset: \(assetName)")
                    continue
                }

                let sizeKB = Double(imageData.count) / 1024.0
                print("📸 Uploading image from asset '\(assetName).png' — Size: \(String(format: "%.2f", sizeKB)) KB")

                body.append("; filename=\"\(assetName).png\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                body.append(imageData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        print("📦 Total body size: \(Double(body.count) / 1024.0) KB")

        var request = URLRequest(url: URL(string: "https://googlewalletapi.onrender.com/apple/wallet-pass")!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "WalletPassError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                print("❌ Invalid HTTP response")
                completion(.failure(error))
                return
            }

            print("📥 HTTP Status Code: \(httpResponse.statusCode)")

            guard let data = data else {
                let error = NSError(domain: "WalletPassError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received")
                completion(.failure(error))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("✅ Server Response:\n\(responseString)")
                completion(.success(responseString))
            } else {
                let error = NSError(domain: "WalletPassError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to decode server response"])
                print("⚠️ Unable to decode server response.")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

