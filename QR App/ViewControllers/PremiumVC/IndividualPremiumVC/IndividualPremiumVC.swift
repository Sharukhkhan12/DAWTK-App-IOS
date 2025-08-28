//
//  IndividualPremiumVC.swift
//  QR App
//
//  Created by Touheed khan on 12/07/2025.
//

import UIKit
import SafariServices

class IndividualPremiumVC: UIViewController, URLSessionTaskDelegate {
    let accessToken = "polar_oat_s9HLeltL8eLA4nhpTGOhrTviUkYJ6wVYh7Uf13KCR0y"
    
    var progressAlert = ProgressAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapStart(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.progressAlert.show()
            self.moveToPremiumWebView()
        }
       
    }
    
    
    func moveToPremiumWebView() {
        
        PaymentNetworkManager.shared.createCheckout(
            products: ["5f17edb1-7e6f-46ff-aea0-7f7fa8e67e7e"],
            successURL: "https://hamzaoffi.github.io/QR-Card/success.html",
            cancelURL: "https://hamzaoffi.github.io/QR-Card/fail.html"
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.progressAlert.dismiss()
                
                switch result {
                case .success(let checkoutURL):
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC {
                        webVC.urlString = checkoutURL
                        webVC.modalTransitionStyle = .flipHorizontal
                        webVC.modalPresentationStyle = .fullScreen
                        self?.present(webVC, animated: true)
                    }
                case .failure(let error):
                    print("❌ Checkout error:", error)
                    // show alert if needed
                }
            }
        }
    }
    
    
//    func newCreateCheckout(accessToken: String) {
//        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
//        let url = URL(string: "https://sandbox-api.polar.sh/v1/checkouts")!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        let body: [String: Any] = [
//            "cancel_url": "https://hamzaoffi.github.io/QR-Card/fail.html",
//            "success_url": "https://hamzaoffi.github.io/QR-Card/success.html",
//            "products": ["5f17edb1-7e6f-46ff-aea0-7f7fa8e67e7e"],
//            "mode": "subscription"
//        ]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//        let task = session.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ Error: \(error)")
//                return
//            }
//            
//            guard let data = data else { return }
//            
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                    print("📩 Response JSON:", json)
//                   
//                    // ✅ "url" key extract karo
//                    if let checkoutUrl = json["url"] as? String {
//                        DispatchQueue.main.async {
//                            self.progressAlert.dismiss()
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            if let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC {
//                                webVC.urlString = checkoutUrl
//                                webVC.modalTransitionStyle = .flipHorizontal   // 🔄 flip animation
//                                webVC.modalPresentationStyle = .fullScreen     // optional
//                                self.present(webVC, animated: true, completion: nil)
//                                // OR navigationController?.pushViewController(webVC, animated: true)
//                            }
//                        }
//                    }
//                }
//            } catch {
//                print("❌ JSON Parse Error:", error)
//            }
//        }
//
//        task.resume()
//    }
//    
//    // Safari open karne ka helper
//    private func openCheckoutInSafari(urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        let safariVC = SFSafariViewController(url: url)
//        present(safariVC, animated: true)
//    }
//    
//    // important
//    func urlSession(
//        _ session: URLSession,
//        task: URLSessionTask,
//        willPerformHTTPRedirection response: HTTPURLResponse,
//        newRequest request: URLRequest,
//        completionHandler: @escaping (URLRequest?) -> Void
//    ) {
//        var newRequest = request
//        newRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        completionHandler(newRequest)
//    }
}

