//
//  Nnetworking.swift
//  QR App
//
//  Created by Touheed khan on 04/08/2025.
//

import Foundation
import Foundation
import PassKit
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    // Step 1: Upload image URL and get .pkpass file URL
    func generateWalletPass(stripImageUrl: String, completion: @escaping (Result<(message: String, passData: Data), Error>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "https://googlewalletapi.onrender.com/apple/wallet-pass")!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body += "--\(boundary)\r\n".data(using: .utf8)!
        body += "Content-Disposition: form-data; name=\"strip_image_url\"\r\n\r\n".data(using: .utf8)!
        body += "\(stripImageUrl)\r\n".data(using: .utf8)!
        body += "--\(boundary)--\r\n".data(using: .utf8)!

        request.httpBody = body

        // Step 2: Hit POST API
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let fileURLString = json["file"] as? String,
                  let message = json["message"] as? String,
                  let fileURL = URL(string: fileURLString)
            else {
                let err = NSError(domain: "WalletPass", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid API response"])
                completion(.failure(err))
                return
            }

            // Step 3: Download the .pkpass file
            URLSession.shared.dataTask(with: fileURL) { fileData, _, fileError in
                if let fileError = fileError {
                    completion(.failure(fileError))
                } else if let fileData = fileData {
                    completion(.success((message: message, passData: fileData)))
                } else {
                    let err = NSError(domain: "WalletPass", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to download pkpass"])
                    completion(.failure(err))
                }
            }.resume()

        }.resume()
    }

    // Step 4: Present Apple Wallet pass
    func presentPass(data: Data, from viewController: UIViewController) {
        do {
            let pass = try PKPass(data: data)
            let addPassVC = PKAddPassesViewController(pass: pass)
            DispatchQueue.main.async {
                viewController.present(addPassVC!, animated: true)
            }
        } catch {
            print("❌ Failed to create Apple Wallet pass: \(error)")
        }
    }
}
