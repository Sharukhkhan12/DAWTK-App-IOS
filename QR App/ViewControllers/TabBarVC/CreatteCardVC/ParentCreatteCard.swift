//
//  ParentCreatteCard.swift
//  QR App
//
//  Created by Touheed khan on 22/06/2025.
//

import UIKit

class ParentCreatteCard: UIViewController {

    @IBOutlet weak var parentView: UIView!
    
    private lazy var creareCardVc: CreatteCardVC = {
        let creareCardVc = CreatteCardVC(nibName: "CreatteCardView", bundle: nil)
        return creareCardVc
    }()
    var updateCardModel: UserBusinessCardModel?

    var selectedTemplateIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(child: creareCardVc)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackButtonTap), name: .didTapBackButton, object: nil)
        NotificationCenter.default.post(
            name: .userFromMyCardsScreen,
            object: nil,
            userInfo: ["card": updateCardModel as Any]
        )

        // Do any additional setup after loading the view.
    }
    
    
    @objc private func handleBackButtonTap() {
        print("Back button tapped! Do something here.")
        self.dismiss(animated: true)
        // For example: refresh data or navigate
    }
    

    // MARK: - AddChildViewController
    
    func addChildViewController(child viewController: UIViewController) {
        // Add the child view controller
        self.addChild(viewController)
        
        // Add the child's view to the parent's view
        self.parentView.addSubview(viewController.view)
        
        // Disable autoresizing mask translation
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints with 2 points margin on each side
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: self.parentView.topAnchor, constant: 2),
            viewController.view.bottomAnchor.constraint(equalTo: self.parentView.bottomAnchor, constant: -2),
            viewController.view.leadingAnchor.constraint(equalTo: self.parentView.leadingAnchor, constant: 2),
            viewController.view.trailingAnchor.constraint(equalTo: self.parentView.trailingAnchor, constant: -2)
        ])
        
        // Notify the child view controller that it was moved to the parent
        viewController.didMove(toParent: self)
    }

}
