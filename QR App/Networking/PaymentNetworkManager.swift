//
//  PaymentNetworkManager.swift
//  QR App
//
//  Created by Touheed khan on 27/08/2025.
//


//import Foundation
//
//
import Foundation

class PaymentNetworkManager: NSObject, URLSessionTaskDelegate {

    static let shared = PaymentNetworkManager()
    private override init() {}

    let accessToken = "polar_oat_s9HLeltL8eLA4nhpTGOhrTviUkYJ6wVYh7Uf13KCR0y"

    func createCheckout(
        products: [String],
        successURL: String,
        cancelURL: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {

        let url = URL(string: "https://sandbox-api.polar.sh/v1/checkouts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "products": products,
            "mode": "subscription",
            "success_url": successURL,
            "cancel_url": cancelURL
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let checkoutURL = json["url"] as? String {
                    completion(.success(checkoutURL))
                } else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: 0)))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // Handle redirection to keep token
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void
    ) {
        var newRequest = request
        newRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        completionHandler(newRequest)
    }
}
