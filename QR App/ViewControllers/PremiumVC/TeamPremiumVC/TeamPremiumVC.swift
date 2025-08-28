//
//  TeamPremiumVC.swift
//  QR App
//
//  Created by Touheed khan on 12/07/2025.
//

import UIKit

enum CardsSelected {
    case fifty(id: String)
    case hundred(id: String)
    case fiveHundred(id: String)
}


class TeamPremiumVC: UIViewController {

    
    @IBOutlet weak var conntinueBtn: UIButton!
    @IBOutlet weak var hundredCardView: DesignableView!
    @IBOutlet weak var fiveHundredCardView: DesignableView!
    @IBOutlet weak var fiftgCardView: DesignableView!
    @IBOutlet weak var continueButtonView: DesignableView!
   
    
    
    var selectedCard: CardsSelected? {
        didSet {
            updateUIForSelection()
            printSelectedCard()
        }
    }

    var hundredCardPackege = "5f17edb1-7e6f-46ff-aea0-7f7fa8e67e7e"
    var fiveHundredPackage = "2c0a72ce-a637-421f-a58f-d35998b88b1f"
    var fifftyCards = "7f563ce2-2ef8-4b23-85fe-a78b507ceced"
    
   
    var progressAlert = ProgressAlertView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable interaction
           continueButtonView.isUserInteractionEnabled = false

           // Reduce opacity to indicate disabled state
           continueButtonView.alpha = 0.5
        self.conntinueBtn.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func didTapContinue(_ sender: Any) {
        guard let selectedCard = selectedCard else { return }

          var packageID: String
          switch selectedCard {
          case .hundred(let id), .fiveHundred(let id), .fifty(let id):
              packageID = id
          }

          self.progressAlert.show()
          moveToPremiumWebView(passPriceKey: packageID)
    }
    
    @IBAction func didTapHundredsCard(_ sender: Any) {
        selectedCard = .hundred(id: hundredCardPackege)
        vibrateOnTap()
        
    }

    @IBAction func didTapFiveHundredsCard(_ sender: Any) {
        selectedCard = .fifty(id: fiveHundredPackage)
        vibrateOnTap()
    }

    @IBAction func didTapFivftyHundredsCard(_ sender: Any) {
        selectedCard = .fiveHundred(id: fifftyCards)
        vibrateOnTap()
    }
    
    func vibrateOnTap() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    // Helper to print the selected card
    func printSelectedCard() {
        guard let selectedCard = selectedCard else {
            print("No card selected")
            return
        }
        
        switch selectedCard {
        case .hundred(let id):
            print("✅ Hundred card selected, id: \(id)")
        case .fiveHundred(let id):
            print("✅ Five Hundred card selected, id: \(id)")
        case .fifty(let id):
            print("✅ Fifty card selected, id: \(id)")
        }
    }
    
    func updateUIForSelection() {
        // Reset all borders
        hundredCardView.layer.borderColor = UIColor.clear.cgColor
        fiveHundredCardView.layer.borderColor = UIColor.clear.cgColor
        fiftgCardView.layer.borderColor = UIColor.clear.cgColor
    

        // Highlight the selected one
        switch selectedCard {
        case .hundred(_):
            hundredCardView.layer.borderColor = #colorLiteral(red: 0.8117647059, green: 0.9921568627, blue: 0.2980392157, alpha: 1)
            hundredCardView.layer.borderWidth = 2
        case .fifty(_):
            fiveHundredCardView.layer.borderColor = #colorLiteral(red: 0.8117647059, green: 0.9921568627, blue: 0.2980392157, alpha: 1)
            fiveHundredCardView.layer.borderWidth = 2
           
        case .fiveHundred(_):
        
            
            fiftgCardView.layer.borderColor = #colorLiteral(red: 0.8117647059, green: 0.9921568627, blue: 0.2980392157, alpha: 1)
            fiftgCardView.layer.borderWidth = 2
        case .none:
            break
        }
        
        // Enable continue button only if a card is selected
        let isSelected = selectedCard != nil
        continueButtonView.isUserInteractionEnabled = isSelected
        continueButtonView.alpha = isSelected ? 1.0 : 0.5
        conntinueBtn.isUserInteractionEnabled = isSelected
    }

    

    // MARK: - Move To Premium WebView
    func moveToPremiumWebView(passPriceKey: String) {
        
        PaymentNetworkManager.shared.createCheckout(
            products: [passPriceKey],
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
}
