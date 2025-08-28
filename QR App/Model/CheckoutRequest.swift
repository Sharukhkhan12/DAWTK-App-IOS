//
//  CheckoutRequest 2.swift
//  QR App
//
//  Created by Touheed khan on 27/08/2025.
//


import Foundation

struct CheckoutRequest: Codable {
    let products: [String]
    let mode: String
    let success_url: String
    let cancel_url: String
}

struct CheckoutResponse: Codable {
    let id: String
    let url: String
    let client_secret: String
    let status: String
    let amount: Int
    let currency: String
}


class PolarAPI {
    static let shared = PolarAPI()
    private init() {}
    
    private let baseURL = URL(string: "http://sandbox-api.polar.sh/v1/")!
    
    func createCheckout(productId: String) async throws -> CheckoutResponse {
        let url = baseURL.appendingPathComponent("checkouts")
        
        var request = URLRequest(url: url)
        let rawToken = "polar_oat_s9HLeltL8eLA4nhpTGOhrTviUkYJ6wVYh7Uf13KCR0y"


        request.setValue("Bearer \(rawToken)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = CheckoutRequest(
            products: [productId],   // 👈 just array of string IDs
            mode: "subscription",
            success_url: "https://hamzaoffi.github.io/QR-Card/success.html",
            cancel_url: "https://hamzaoffi.github.io/QR-Card/fail.html"
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted  // optional, for debugging
        request.httpBody = try encoder.encode(body)
        
      

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("📡 Status:", httpResponse.statusCode)
        if let json = try? JSONSerialization.jsonObject(with: data) {
            print("📩 Response JSON:", json)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(CheckoutResponse.self, from: data)
    }

}
extension URLRequest {
    var curlString: String {
        var result = "curl -X \(self.httpMethod ?? "GET") '\(self.url!.absoluteString)'"
        for (key, value) in self.allHTTPHeaderFields ?? [:] {
            result += " -H '\(key): \(value)'"
        }
        if let body = self.httpBody {
            result += " --data '\(String(data: body, encoding: .utf8)!)'"
        }
        return result
    }
}
