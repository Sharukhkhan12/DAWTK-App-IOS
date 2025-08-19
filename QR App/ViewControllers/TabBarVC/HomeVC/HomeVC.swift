//
//  HomeVC.swift
//  QR App
//
//  Created by Touheed khan on 04/06/2025.
//

import UIKit


// MARK: - SegmentsSelected
enum  SegmentsSelected {
    case inviationCard
    case BusinessCard
}
class HomeVC: UIViewController {

    // MARK: - @IBOutlet
    @IBOutlet weak var weddingView: DesignableView!
    @IBOutlet weak var buisnessView: DesignableView!
    @IBOutlet weak var segmentStackView: UIStackView!
    @IBOutlet weak var templatesCV: UICollectionView!
    @IBOutlet weak var templatePageControl: UIPageControl!

    // MARK: - Properties
    var segmeentsSelected: SegmentsSelected = .BusinessCard
    let totalTemplates = 10
    var hasVibratedForPage1 = false
    var lastVibratedPage: Int?
    let templateBuisnessIdentifiers = [
        "Template8CVC",
        "Template7CVC",
        "Template6CVC",
        "Template5CVC",
        "Template4CVC",
        "Template3CVC",
        "Template2CVC",
        "Template1CVC"
    ]
   
    
    let templateInvitationIdentifiers = [
        "InvitationTemplatesCVC1",
        "InvitationTemplatesCVC2",
        "InvitationTemplatesCVC3",
        "InvitationTemplatesCVC4",
        "InvitationTemplatesCVC5",
        "InvitationTemplatesCVC7",
        "InvitationTemplatesCVC8",
        "InvitationTemplatesCVC9",
        "InvitationTemplatesCVC10",
        "InvitationTemplatesCVC11",
        "InvitationTemplatesCVC12",
        "InvitationTemplatesCVC13",
        "InvitationTemplatesCVC14"
    ]
    
    
    
    
    
    var currentTemplateIdentifiers: [String] {
        switch segmeentsSelected {
        case .BusinessCard:
            return templateBuisnessIdentifiers
        case .inviationCard:
            return templateInvitationIdentifiers
        }
    }
    
    

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        templatesCV.delegate = self
        templatesCV.dataSource = self

        setup()
    }
    
   
    
    @IBAction func didTapPremiumVC(_ sender: Any) {
        self.navigateToPremiumScreen()
    }
    
    @IBAction func didTapCreateCard(_ sender: Any) {
        
       
        
        if segmeentsSelected == .inviationCard {
            
            if let selectedIndex = getCurrentIndex() {
                navigateToPInvitaionCard(currentIndex: selectedIndex)
            }
        } else {
            if let selectedIndex = getCurrentIndex() {
                navigateToParentCreatteCard(currentIndex: selectedIndex)
            }
        }
       
    }
    
    
    // MARK: - get Current Index
    
    func getCurrentIndex() -> Int? {
        let visibleCenterPosition = templatesCV.contentOffset.x + (templatesCV.bounds.width * 0.5)
          if let layout = templatesCV.collectionViewLayout as? UICollectionViewFlowLayout {
              let itemWidth = templatesCV.bounds.width * 0.9
              let currentIndex = Int((visibleCenterPosition - templatesCV.frame.width * 0.05) / itemWidth)

              print("Currently selected template index: \(currentIndex)")
              
              // Optionally, you can get the identifier too
              if currentIndex >= 0 && currentIndex < currentTemplateIdentifiers.count {
                  let selectedIdentifier = currentTemplateIdentifiers[currentIndex]
                  print("Selected cell identifier: \(selectedIdentifier)")
                  return currentIndex
              }
          }
        return 0
    }
    
    
    // MARK: - Navigate To ParentCreatteCard
    
    private func navigateToParentCreatteCard(currentIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let parentCreatteCard = storyboard.instantiateViewController(withIdentifier: "ParentCreatteCard") as? ParentCreatteCard {
            parentCreatteCard.selectedTemplateIdentifier = currentTemplateIdentifiers[currentIndex]
            parentCreatteCard.modalPresentationStyle = .fullScreen
            parentCreatteCard.modalTransitionStyle = .crossDissolve
            present(parentCreatteCard, animated: true)
        }
    }
    
    
    private func navigateToPremiumScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let premiumVC = storyboard.instantiateViewController(withIdentifier: "PremiumVC") as? PremiumVC {
            premiumVC.modalPresentationStyle = .fullScreen
            premiumVC.modalTransitionStyle = .crossDissolve
            present(premiumVC, animated: true)
        }
    }
    
    
    // MARK: - Navigate To Invitaion Card
    
    private func navigateToPInvitaionCard(currentIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let invitationCardVC = storyboard.instantiateViewController(withIdentifier: "InvitationCardVC") as? InvitationCardVC {
            invitationCardVC.selectedTemplateIdentifier = currentTemplateIdentifiers[currentIndex]
            invitationCardVC.modalPresentationStyle = .fullScreen
            invitationCardVC.modalTransitionStyle = .crossDissolve
            present(invitationCardVC, animated: true)
        }
    }
    

    // MARK: - Setup
    func setup() {
        // Register Business Card Templates
        for identifier in templateBuisnessIdentifiers {
            let nib = UINib(nibName: identifier, bundle: nil)
            templatesCV.register(nib, forCellWithReuseIdentifier: identifier)
        }

        // Register Invitation Card Templates
        for identifier in templateInvitationIdentifiers {
            let nib = UINib(nibName: identifier, bundle: nil)
            templatesCV.register(nib, forCellWithReuseIdentifier: identifier)
        }

        // Configure CollectionView Layout
        if let layout = templatesCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }

        templatesCV.isPagingEnabled = false
        templatesCV.showsHorizontalScrollIndicator = false
        templatesCV.alwaysBounceHorizontal = false

        templatePageControl.numberOfPages = currentTemplateIdentifiers.count
        templatePageControl.currentPage = 0
        templatePageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.8424777389, green: 0.9784539342, blue: 0.3669895828, alpha: 1)
        templatePageControl.pageIndicatorTintColor = #colorLiteral(red: 0.9215686275, green: 0.9294117647, blue: 0.9411764706, alpha: 1)
    }




    // MARK: - Actions
    @IBAction func didTapWedding(_ sender: Any) {
        segmeentsSelected = .inviationCard
        animateSelection(selected: weddingView, deselected: buisnessView)
        templatesCV.reloadData()
        scrollToFirstItem()
    }

    @IBAction func didTapBuisness(_ sender: Any) {
        segmeentsSelected = .BusinessCard  // ✅ Correct enum case
        animateSelection(selected: buisnessView, deselected: weddingView)
        templatesCV.reloadData()
        scrollToFirstItem()
    }
    
    // MARK: - Scroll To FirstItem
    func scrollToFirstItem() {
        DispatchQueue.main.async {
            if self.currentTemplateIdentifiers.count > 0 {
                self.templatesCV.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
                self.templatePageControl.currentPage = 0
                self.lastVibratedPage = nil
            }
        }
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
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTemplateIdentifiers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = currentTemplateIdentifiers[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }



}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.9
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = collectionView.frame.width * 0.05
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


// MARK: - UIScrollViewDelegate

extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width * 0.9
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        templatePageControl.currentPage = currentPage

        if currentPage != lastVibratedPage {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
            lastVibratedPage = currentPage
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                    withVelocity velocity: CGPoint,
                                    targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = templatesCV.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = templatesCV.frame.width * 0.9

        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: CGFloat

        if velocity.x > 0 {
            index = ceil(estimatedIndex)
        } else if velocity.x < 0 {
            index = floor(estimatedIndex)
        } else {
            index = round(estimatedIndex)
        }

        let xOffset = index * cellWidthIncludingSpacing - templatesCV.frame.width * 0.05
        targetContentOffset.pointee = CGPoint(x: xOffset, y: 0)
    }
}

