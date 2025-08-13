//
//  TabBarVC.swift
//  QR App
//
//  Created by Touheed khan on 01/06/2025.
//

import UIKit

class TabBarVC: UIViewController {

    
    @IBOutlet weak var mainView: UIView!
    
    
    private lazy var creareCardVc: CreatteCardVC = {
        let creareCardVc = CreatteCardVC(nibName: "CreatteCardView", bundle: nil)
        return creareCardVc
    }()
    
    
    private lazy var homeVC: HomeVC = {
        let homeVC = HomeVC(nibName: "HomeViewNib", bundle: nil)
        return homeVC
    }()

    private lazy var qrScanVC: QRScanVC = {
        let qrScanVC = QRScanVC(nibName: "QRScanViewNib", bundle: nil)
        return qrScanVC
    }()
    
    
    private lazy var cardVC: CardVC = {
        let cardVC = CardVC(nibName: "SavedCardViewNib", bundle: nil)
        return cardVC
    }()
    
    private lazy var userProfileVC: UserProfileVC = {
        let userProfileVC = UserProfileVC(nibName: "UserProfileViews", bundle: nil)
        return userProfileVC
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(child: homeVC)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapScanner(_ sender: Any) {
        self.addChildViewController(child: qrScanVC)
    }
    
    @IBAction func didTapHome(_ sender: Any) {
        self.addChildViewController(child: homeVC)
    }
    

    @IBAction func didTapCards(_ sender: Any) {
        self.addChildViewController(child: cardVC)
        
        // 🔁 Slight delay to ensure cardVC.view is fully loaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              NotificationCenter.default.post(name: .reloadKolodaCards, object: nil)
          }
    }

    
    
    @IBAction func didTapViewAnalyze(_ sender: Any) {
    }
    
    @IBAction func didTapProfile(_ sender: Any) {
        self.addChildViewController(child: userProfileVC)
    }
    
    
    // MARK: - AddChildViewController
    
    func addChildViewController(child viewController: UIViewController) {
        // Add the child view controller
        self.addChild(viewController)
        
        // Add the child's view to the parent's view
        self.mainView.addSubview(viewController.view)
        
        // Disable autoresizing mask translation
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints with 2 points margin on each side
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 2),
            viewController.view.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor, constant: -2),
            viewController.view.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 2),
            viewController.view.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor, constant: -2)
        ])
        
        // Notify the child view controller that it was moved to the parent
        viewController.didMove(toParent: self)
    }

}
