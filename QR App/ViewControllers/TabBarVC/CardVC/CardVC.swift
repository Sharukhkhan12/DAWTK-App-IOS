//
//  CardVC.swift
//  QR App
//
//  Created by MacBook Air on 28/07/2025.
//

import UIKit
import Koloda
import FirebaseAuth
import Malert

class CardVC: UIViewController {

    @IBOutlet weak var kalodaView: KolodaView!
    @IBOutlet weak var weddingView: DesignableView!
    @IBOutlet weak var buisnessView: DesignableView!

    var segmeentsSelected: SegmentsSelected = .BusinessCard
    var progressAllert = ProgressAlertView()
    var fetchedCards: [UserBusinessCardModel] = []
    
    var fetchedInvitationCards: [InvitationModel] = []


    var selectedImage: UIImage?
    var businessCardImageURLs: [String] = []
    var invitationCardImageURLs: [String] = []
    var selectedInnvitationImage: UIImage?
    var imagesStored: [UIImage] = []
    var invitationsImagesStored: [UIImage] = []

    var selectedCard: UserBusinessCardModel?
    var selectedInvitationCard: InvitationModel?

    var userFromCardVC = false

    override func viewDidLoad() {
        super.viewDidLoad()
        kalodaView.delegate = self
        kalodaView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(handleReloadNotification), name: .reloadKolodaCards, object: nil)
        fetchBusinessCards()
    }
    
    @objc func handleReloadNotification() {
        print("🔁 handleReloadNotification triggered")
        fetchBusinessCards()
    }

    // MARK: - Firebase Fetch and Image Preload
    func fetchBusinessCards() {
        progressAllert.show()
        guard let ownerId = Auth.auth().currentUser?.uid else {
            print("❌ No logged-in user")
            progressAllert.dismiss()
            return
        }

        FirebaseManager.shared.fetchBusinessCardsByOwnerID(ownerId: ownerId) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let cards):
                self.businessCardImageURLs = cards.map { $0.mainCardFilePath }
                self.preloadImagesAndReload()

                self.fetchedCards = cards
            case .failure(let error):
                print("❌ Error fetching cards: \(error.localizedDescription)")
                self.progressAllert.dismiss()
            }
        }
    }
    
    
    
    
    func fetchInvitaionCards() {
        progressAllert.show()
        guard let ownerId = Auth.auth().currentUser?.uid else {
            print("❌ No logged-in user")
            progressAllert.dismiss()
            return
        }

        FirebaseManager.shared.fetchInvitationCardsByOwnerID(ownerId: ownerId) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let cards):
                self.invitationCardImageURLs = cards.map { $0.mainCardFilePath }
                self.preloadImagesAndReload()

                self.fetchedInvitationCards = cards
            case .failure(let error):
                print("❌ Error fetching cards: \(error.localizedDescription)")
                self.progressAllert.dismiss()
            }
        }
    }
    

    private func preloadImagesAndReload() {
        
        switch segmeentsSelected {
        case .inviationCard:
            let urls = invitationCardImageURLs.compactMap { URL(string: $0) }
            invitationsImagesStored = Array(repeating: UIImage(), count: urls.count)
            let group = DispatchGroup()

            for (index, url) in urls.enumerated() {
                group.enter()
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    defer { group.leave() }

                    if let data = data, let image = UIImage(data: data) {
                        self.invitationsImagesStored[index] = image
                    }
                }.resume()
            }

            group.notify(queue: .main) {
                self.progressAllert.dismiss()
                self.kalodaView.resetCurrentCardIndex()
                self.kalodaView.reloadData()
            }
            
        case .BusinessCard:
            let urls = businessCardImageURLs.compactMap { URL(string: $0) }
            imagesStored = Array(repeating: UIImage(), count: urls.count)
            let group = DispatchGroup()

            for (index, url) in urls.enumerated() {
                group.enter()
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    defer { group.leave() }

                    if let data = data, let image = UIImage(data: data) {
                        self.imagesStored[index] = image
                    }
                }.resume()
            }

            group.notify(queue: .main) {
                self.progressAllert.dismiss()
                self.kalodaView.resetCurrentCardIndex()
                self.kalodaView.reloadData()
            }
        }
      
    }

    // MARK: - Actions
    
    
    @IBAction func didTapPremium(_ sender: Any) {
        self.navigateToPremiumScreen()
    }
    
    @IBAction func didTapWedding(_ sender: Any) {
        segmeentsSelected = .inviationCard
        animateSelection(selected: weddingView, deselected: buisnessView)
        fetchInvitaionCards()
    }

    @IBAction func didTapBuisness(_ sender: Any) {
        segmeentsSelected = .BusinessCard
        animateSelection(selected: buisnessView, deselected: weddingView)
        fetchBusinessCards()
    }
    
    
    // MARK: - Navigate To PremiumScreen
    private func navigateToPremiumScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let premiumVC = storyboard.instantiateViewController(withIdentifier: "PremiumVC") as? PremiumVC {
            premiumVC.modalPresentationStyle = .fullScreen
            premiumVC.modalTransitionStyle = .crossDissolve
            present(premiumVC, animated: true)
        }
    }

    // MARK: - UI Animation
    func animateSelection(selected: DesignableView, deselected: DesignableView) {
        UIView.animate(withDuration: 0.3, animations: {
            selected.backgroundColor = #colorLiteral(red: 0.842, green: 0.978, blue: 0.366, alpha: 1)
            deselected.backgroundColor = #colorLiteral(red: 0.922, green: 0.929, blue: 0.941, alpha: 1)
            selected.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            deselected.transform = .identity
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                selected.transform = .identity
            }
        })
    }
}
extension CardVC: KolodaViewDataSource, KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        switch  segmeentsSelected {
            
        case .inviationCard:
            imageView.image = invitationsImagesStored[index]
        case .BusinessCard:
            imageView.image = imagesStored[index]
        }
        imageView.isUserInteractionEnabled = true // Enable tap interaction
        
        // Add tap gesture with index
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(_:)))
        tap.name = "\(index)" // Store index in gesture's name
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        
        switch  segmeentsSelected {
            
        case .inviationCard:
            return invitationsImagesStored.count
        case .BusinessCard:
            return imagesStored.count
        }
        
      
        
    }
    
    @objc func handleCardTap(_ sender: UITapGestureRecognizer) {
        if let indexString = sender.name, let index = Int(indexString) {
            print("🔘 Card tapped at index: \(index)")
            switch segmeentsSelected {
                
            case .inviationCard:
                
                self.selectedInnvitationImage = invitationsImagesStored[index]
                self.selectedInvitationCard = fetchedInvitationCards[index]
            case .BusinessCard:
                
                self.selectedImage = imagesStored[index]
                self.selectedCard = fetchedCards[index]
            }
            self.showCostumAlert()
            // Optional: Handle navigation, alert, or custom logic
            // showCardDetail(at: index)
        }
    }
    
    
    // MARK: - CostumAlert
    func showCostumAlert() {
        let premiumAlert = PremiumAlert.instantiateFromNib()
        // Set the dismiss action
        premiumAlert.delegate = self
        // Present the alert using Malert
        let malert = Malert(customView: premiumAlert)
        present(malert, animated: true)
    }

    
    
    
}
extension CardVC: PremiumAlertDelegate {

    

    // MARK: - PremiumAlertDelegate Methods

    func didSelectView() {
        print("Handled View tap in VC")
     
        
        switch segmeentsSelected {
            
        case .inviationCard:
            guard let selectedImage = self.selectedInnvitationImage, let selectedCard = selectedInvitationCard else { return }

              //   Dismiss Malert first before presenting new VC
                self.dismiss(animated: true) { [weak self] in
                    self?.navigateToPreVieeScreen(invitationCard: selectedCard)
               
            }
        case .BusinessCard:
            
            guard let selectedImage = self.selectedImage, let selectedCard = selectedCard else { return }

                // Dismiss Malert first before presenting new VC
                self.dismiss(animated: true) { [weak self] in
                    self?.navigateToViewCardScreen(image: selectedImage, card: selectedCard)
               
            }
        }
        
        
        
        // Perform View logic
    }

    func didSelectEditCard() {
        print("Handled Edit Card")
        
        
        switch segmeentsSelected {
        case .inviationCard:
            self.dismiss(animated: true) { [weak self] in
                guard let selectedImage = self!.selectedInnvitationImage, let selectedCard = self!.selectedInvitationCard else { return }
                self?.navigateToPInvitaionCard(invitationCard: selectedCard)
            }
        case .BusinessCard:
            self.dismiss(animated: true) { [weak self] in
                guard let selectedCard = self!.selectedCard else { return }
                self?.navigateToParentCreatteCard(card: selectedCard)
            }
        }
        
    }

    func didSelectRedesign() {
        print("Handled Re-design")
        
        
        switch segmeentsSelected {
        case .inviationCard:
            self.dismiss(animated: true) { [weak self] in
                guard let selectedCard = self!.selectedInvitationCard else { return }
                self?.navigateToStyleCardScreen(card: selectedCard)
            }
        case .BusinessCard:
            self.dismiss(animated: true) { [weak self] in
                guard let selectedCard = self!.selectedCard else { return }
                self?.navigateToStyleCardScreen(card: selectedCard)
                
                
            }
        }
        
        
      
       
    }

    func didSelectAnalytics() {
        print("Handled View Analytics")
    }

    func didSelectAddToWallet() {
        print("Handled Add to Wallet")
    }

    func didSelectSharing() {
        print("Handled Sharing")
    }

    func didSelectDelete() {
        print("Handled Delete")
        
        switch segmeentsSelected {
            
        case .inviationCard:
            if let ownerID = selectedInvitationCard?.ownerId, let cardKey = selectedInvitationCard?.qrCode {
                self.dismiss(animated: true) { [weak self] in
                    self?.deleteCard(ownerID: ownerID, cardKey: cardKey)
                    
                }
            }
        case .BusinessCard:
            if let ownerID = selectedCard?.ownerId, let cardKey = selectedCard?.qrCode {
                self.dismiss(animated: true) { [weak self] in
                    guard let selectedCard = self!.selectedCard else { return }
                    self?.deleteCard(ownerID: ownerID, cardKey: cardKey)
                    
                }
            }
        }
    }
    
    // MARK: - Navigate to View Card Screen
    private func navigateToViewCardScreen(image: UIImage, card: UserBusinessCardModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewAsVC = storyboard.instantiateViewController(withIdentifier: "ViewAsVC") as? ViewAsVC {
            print()
            viewAsVC.cardInfo = card
            viewAsVC.modalTransitionStyle = .crossDissolve
            viewAsVC.modalPresentationStyle = .fullScreen
            present(viewAsVC, animated: true)
        }
    }
    
    
    
    // MARK: - Navigate TO Invitation PreViee Controller
    
    private func navigateToPreVieeScreen(invitationCard: InvitationModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let invitationPreViewVC = storyboard.instantiateViewController(withIdentifier: "InvitationPreViewVC") as? InvitationPreViewVC {
            invitationPreViewVC.modalTransitionStyle = .crossDissolve
            invitationPreViewVC.userCard = invitationCard
            invitationPreViewVC.userFromMyCardsScreen = true
            
            invitationPreViewVC.modalPresentationStyle = .fullScreen
            present(invitationPreViewVC, animated: true)
        }
    }
    
    
    // MARK: - Navigate to Style Card Screen
    private func navigateToStyleCardScreen(card: UserBusinessCardModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let styleVC = storyboard.instantiateViewController(withIdentifier: "StyleVC") as? StyleVC {
            styleVC.cardInfo = card
            styleVC.segmeentsSelected = .BusinessCard
            styleVC.modalTransitionStyle = .crossDissolve
            styleVC.modalPresentationStyle = .fullScreen
            present(styleVC, animated: true)
        }
    }
    
    
    private func navigateToStyleCardScreen(card: InvitationModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let styleVC = storyboard.instantiateViewController(withIdentifier: "StyleVC") as? StyleVC {
            styleVC.userCard = card
            styleVC.segmeentsSelected = .inviationCard
            styleVC.modalTransitionStyle = .crossDissolve
            styleVC.modalPresentationStyle = .fullScreen
            present(styleVC, animated: true)
        }
    }
    
    
    
    func deleteCard(ownerID: String, cardKey: String) {
        
        switch segmeentsSelected  {
            
        case .inviationCard:
            FirebaseManager.shared.deletUserInvitationCard(ownerId: ownerID, cardKey: cardKey) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Deleted", message: "The business card was successfully deleted.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self?.fetchInvitaionCards()
                        }))
                        self?.present(alert, animated: true)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            }
        case .BusinessCard:
            FirebaseManager.shared.deleteUserBusinessCard(ownerId: ownerID, cardKey: cardKey) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Deleted", message: "The business card was successfully deleted.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self?.fetchBusinessCards()
                        }))
                        self?.present(alert, animated: true)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
        
        
       
    }
    
    private func navigateToParentCreatteCard(card: UserBusinessCardModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let parentCreatteCard = storyboard.instantiateViewController(withIdentifier: "ParentCreatteCard") as? ParentCreatteCard {
            parentCreatteCard.updateCardModel = card
            parentCreatteCard.modalPresentationStyle = .fullScreen
            parentCreatteCard.modalTransitionStyle = .crossDissolve
            present(parentCreatteCard, animated: true)
        }
    }
    
    
    // MARK: - Navigate To Invitaion Card
    
    private func navigateToPInvitaionCard(invitationCard: InvitationModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let invitationCardVC = storyboard.instantiateViewController(withIdentifier: "InvitationCardVC") as? InvitationCardVC {
            invitationCardVC.updatedModel = invitationCard
            invitationCardVC.userFromCardScreen = true
            invitationCardVC.modalPresentationStyle = .fullScreen
            invitationCardVC.modalTransitionStyle = .crossDissolve
            present(invitationCardVC, animated: true)
        }
    }
    
    
    
}


