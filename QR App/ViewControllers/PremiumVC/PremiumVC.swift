//
//  PremiumVC.swift
//  QR App
//
//  Created by Touheed khan on 12/07/2025.
//

import UIKit

class PremiumVC: UIViewController {

    @IBOutlet weak var mainView: DesignableView!
    @IBOutlet weak var temaView: DesignableView!
    @IBOutlet weak var individualView: DesignableView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var segmentVieeHeightConstrainnt: NSLayoutConstraint!
    
    
    private lazy var individualPremiumVC: IndividualPremiumVC = {
        let individualPremiumVC = IndividualPremiumVC(nibName: "IndividualPremiumView", bundle: nil)
        return individualPremiumVC
    }()
    
    private lazy var teamPremiumVC: TeamPremiumVC = {
        let teamPremiumVC = TeamPremiumVC(nibName: "TeamPremiumView", bundle: nil)
        return teamPremiumVC
    }()
    
    var progressAlert =  ProgressAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(child: individualPremiumVC)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapPremium(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapIndividual(_ sender: Any) {
        self.addChildViewController(child: individualPremiumVC)
        updateConstraintsForIpad(constant: 0.8)
        animateSelection(selected: individualView, deselected: temaView)
    }
    
    
    @IBAction func didTapTeam(_ sender: Any) {
        self.addChildViewController(child: teamPremiumVC)
        self.updateConstraintsForIpad(constant: 0.95)
        self.animateSelection(selected: temaView, deselected: individualView)
    }
    
    
    
    
    
    
   
    
    
    // MARK: - Update Constraints For Ipad
    
    func  updateConstraintsForIpad(constant: CGFloat) {
        let newConstraint = segmentVieeHeightConstrainnt.constraintWithMultiplier(constant)
        mainView.removeConstraint(segmentVieeHeightConstrainnt)
        mainView.addConstraint(newConstraint)
        mainView.layoutIfNeeded()
        segmentVieeHeightConstrainnt = newConstraint
    }
    
    // MARK: - UI Animation
    func animateSelection(selected: DesignableView, deselected: DesignableView) {
        UIView.animate(withDuration: 0.3, animations: {
            selected.backgroundColor = #colorLiteral(red: 0.8424777389, green: 0.9784539342, blue: 0.3669895828, alpha: 1)
            deselected.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9411764706, alpha: 1)

            selected.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            deselected.transform = .identity
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                selected.transform = .identity
            }
        })
    }
    
    
    // MARK: - AddChildViewController
    
    func addChildViewController(child viewController: UIViewController) {
        // Add the child view controller
        self.addChild(viewController)
        
        // Add the child's view to the parent's view
        self.childView.addSubview(viewController.view)
        
        // Disable autoresizing mask translation
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints with 2 points margin on each side
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: self.childView.topAnchor, constant: 2),
            viewController.view.bottomAnchor.constraint(equalTo: self.childView.bottomAnchor, constant: -2),
            viewController.view.leadingAnchor.constraint(equalTo: self.childView.leadingAnchor, constant: 2),
            viewController.view.trailingAnchor.constraint(equalTo: self.childView.trailingAnchor, constant: -2)
        ])
        
        // Notify the child view controller that it was moved to the parent
        viewController.didMove(toParent: self)
    }

}
