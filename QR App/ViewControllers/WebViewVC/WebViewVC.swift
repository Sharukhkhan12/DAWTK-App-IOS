//
//  WebViewVC.swift
//  QR App
//
//  Created by Touheed khan on 28/08/2025.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var urlString = ""
    
    // Success / cancel URLs
    var successURL: String?
    var cancelURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.successURL = "https://hamzaoffi.github.io/QR-Card/success.html"
        self.cancelURL = "https://hamzaoffi.github.io/QR-Card/fail.html"
        webView.navigationDelegate = self   // ✅ set delegate

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url?.absoluteString {
            
            // Check if success URL
            if let success = successURL, url.contains(success) {
                print("✅ Success URL reached")
                decisionHandler(.cancel) // stop further navigation if needed
                
                // Navigate to next screen
                navigateToSuccessScreen()
                return
            }
            
            // Check if cancel URL
            if let cancel = cancelURL, url.contains(cancel) {
                print("❌ Cancel URL reached")
                decisionHandler(.cancel)
                
                // Handle cancel if needed
                self.dismiss(animated: true)
                return
            }
        }
        
        decisionHandler(.allow) // allow normal navigation
    }
    func navigateToSuccessScreen() {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "SuccessVC") as? SuccessVC {
           tabBarVC.modalTransitionStyle = .crossDissolve
           tabBarVC.modalPresentationStyle = .fullScreen
           present(tabBarVC, animated: true)
       }
   }
}
