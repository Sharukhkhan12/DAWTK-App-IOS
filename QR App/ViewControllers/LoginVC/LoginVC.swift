//
//  LoginVC.swift
//  QR App
//
//  Created by Touheed khan on 30/05/2025.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var segmentStackView: UIStackView!
    @IBOutlet weak var emailView: DesignableView!
    @IBOutlet weak var phoneView: DesignableView!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var phonelbl: UILabel!
    @IBOutlet weak var cardView: CardView!
    
    private lazy var phoneLoginCard: PhoneVC = {
        let phoneLoginCard = PhoneVC(nibName: "PhoneView", bundle: nil)
        return phoneLoginCard
    }()
    
    private lazy var emailLoginCard: EmailVC = {
        let emailLoginCard = EmailVC(nibName: "EmailView", bundle: nil)
        return emailLoginCard
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(child: phoneLoginCard)
        applyInitialSegmentState()
    }
    
    
    @IBAction func didTapPhone(_ sender: Any) {
        self.phonelbl.textColor =  .black
        self.emaillbl.textColor =  #colorLiteral(red: 0.6576154293, green: 0.7654830079, blue: 0.2881794783, alpha: 1)
        animateSelection(selected: phoneView, deselected: emailView)
        self.addChildViewController(child: phoneLoginCard)
    }
    
    @IBAction func didTapEmail(_ sender: Any) {
        self.emaillbl.textColor = .black
        self.phonelbl.textColor =  #colorLiteral(red: 0.6576154293, green: 0.7654830079, blue: 0.2881794783, alpha: 1)
        animateSelection(selected: emailView, deselected: phoneView)
        self.addChildViewController(child: emailLoginCard)
    }
    
    

    // MARK: - Setup
    
    func applyInitialSegmentState() {
        // Initial appearance
        emailView.backgroundColor =  #colorLiteral(red: 0.9764705882, green: 0.9803921569, blue: 0.9843137255, alpha: 1)
        phoneView.backgroundColor = #colorLiteral(red: 0.8424777389, green: 0.9784539342, blue: 0.3669895828, alpha: 1)
    }

    
    
    // MARK: - AddChildViewController
    
    func addChildViewController(child viewController: UIViewController) {
        // Add the child view controller
        self.addChild(viewController)
        
        // Add the child's view to the parent's view
        self.cardView.addSubview(viewController.view)
        
        // Disable autoresizing mask translation
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints with 2 points margin on each side
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: self.cardView.topAnchor, constant: 2),
            viewController.view.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -2),
            viewController.view.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor, constant: 2),
            viewController.view.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -2)
        ])
        
        // Notify the child view controller that it was moved to the parent
        viewController.didMove(toParent: self)
    }


    // MARK: - Animation

    func animateSelection(selected: DesignableView, deselected: DesignableView) {
        UIView.animate(withDuration: 0.3, animations: {
            selected.backgroundColor =  #colorLiteral(red: 0.8424777389, green: 0.9784539342, blue: 0.3669895828, alpha: 1)
            deselected.backgroundColor =  .clear
            

            selected.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            deselected.transform = .identity
        }, completion: { _ in
            // Restore original scale
            UIView.animate(withDuration: 0.2) {
                selected.transform = .identity
            }
        })
    }
}
