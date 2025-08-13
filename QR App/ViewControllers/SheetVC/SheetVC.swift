//
//  SelectedImage.swift
//  QR App
//
//  Created by Touheed khan on 16/06/2025.
//


import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import TOCropViewController
enum SelectedImage {
    case view
    case share
    case delete
   
}


enum CheckUserTapAction {
    case camera
    case gallery
   
}

 protocol SaveFilesSelectedImage: AnyObject {
      func selectedImage(imagePurpose: SelectedImage)
}

// MARK: - Protocol update
@objc protocol ImageSelectedFromSheet: AnyObject {
    @objc  func imageSelected(processImage: UIImage, imageURL: URL)
}


class SheetVC: UIViewController {
    
    enum SheetPurpose {
        case backgroundRemover
        case objectRemover
       
    }
    
  
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Image"
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.textColor = .black
        return label
    }()

    
    lazy var sheetMenuTV: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "SheetTVC", bundle: nil), forCellReuseIdentifier: "SheetTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white // Set background to white explicitly
        return tableView
    }()
    
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleLabel,sheetMenuTV])
        stackView.axis = .vertical
        stackView.spacing = 0.0
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    
    // Constants
    
    var checkUserTapAction: CheckUserTapAction = .gallery
    var purpose: SheetPurpose?
    var defaultHeight: CGFloat = 210
    var dismissibleHeight: CGFloat = 160
    var maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 34
    var currentContainerHeight: CGFloat = 260
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    // Declarations
    var sheetsMenus: [SheetMenuModel] = []
    var userFromSaveScreen: Bool = false
    weak var delegete: ImageSelectedFromSheet?
    var imagePurposeDelegate: SaveFilesSelectedImage?
    var selectedImage: UIImage?

    
    var selectedIndex: Int?
    var userFrom = ""
    var progressAlert = ProgressAlertView()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetMenuTV.overrideUserInterfaceStyle = .light

        self.view.backgroundColor = UIColor.white
        if self.userFromSaveScreen ==  true {
            self.titleLabel.isHidden = true
            
        } else {
            self.titleLabel.isHidden = false

        }
        setUp()
        self.setupView()
        self.setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        setupPanGesture()
     
    }
    
   
    

    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    
    
    
    // MARK: - Setup
    func setUp() {
        sheetsMenus = [ SheetMenuModel(Image: "BottomSheetImg1", title: "Camera"),
                        SheetMenuModel(Image: "BottomSheetImg2", title: "Gallery")]
        
     }
    
    // MARK: - Navigate Home to Remove ObjectVC
    
    func navigateHometoRemoveObject(selectedImage: UIImage) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let nextVC = storyboard.instantiateViewController(withIdentifier: "RemoveObjectVC") as? RemoveObjectVC {
//            nextVC.modalTransitionStyle = .crossDissolve
//            nextVC.modalPresentationStyle = .fullScreen
//            nextVC.selectedImage = selectedImage
//            
//            self.present(nextVC, animated: true, completion: nil)
//        }
    }
    
    // MARK: - Set Up Open ICloudSheet
    func setUpOpenICloudSheet() {
        
        let pdfConversionsNib = UINib(nibName: "OpenICloundCell", bundle: nil)
        sheetMenuTV.register(pdfConversionsNib, forCellReuseIdentifier: "OpenICloundCell")
        sheetsMenus = [ SheetMenuModel(Image: "filesIcon", title: "Files"),
                        SheetMenuModel(Image: "galleryIcon", title: "Photos"),
       ]
        
        sheetMenuTV.estimatedRowHeight = 90

    }

    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    // MARK: - Set Up Constraint

    func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    
    // MARK: - Set Up Pan Gesture

    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            } else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            } else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            } else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    
    
    // MARK: - Animate Container Height
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    
    // MARK: - Animate Present Containor

    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Animate Show DimmedView

    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    
    // MARK: - Animate Show Dismiss

    func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
}
extension SheetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return sheetsMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SheetTVC", for: indexPath) as! SheetTVC
        let menu = sheetsMenus[indexPath.row]
        cell.sheetMenuImg.image = UIImage(named: menu.Image ?? "")
        cell.sheetMenulbl.text = menu.title
        cell.sheetMenulbl.textColor = .black
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            self.openCamera()
           
        case 1:
            openGallery()
            print("Gallery")
          
           
        default:
            print("No Selected")
        }
    

    }
    
    // MARK: - Open Gallery
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            print("Photo library not available")
        }
    }

  

    // MARK: - Open Camera
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
  
}
extension SheetVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let selectedImage = info[.originalImage] as? UIImage {
                // Present crop controller
                let cropVC = TOCropViewController(image: selectedImage)
                cropVC.delegate = self
                // Optional: configure style/settings
                self.present(cropVC, animated: true)
            } else {
                // Fallback: dismiss sheet if no image
                self.dismiss(animated: true)
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    // MARK: - TOCropViewControllerDelegate

    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        // Use the cropped image
        
        
        
        self.selectedImage = image
        
        var url: URL?
          do {
              url = try temporaryURL(for: image)
          } catch {
              print("Warning: could not write image to temp URL: \(error)")
          }
        
        self.delegete?.imageSelected(processImage: image, imageURL: url!)
        cropViewController.dismiss(animated: true) {
            self.dismiss(animated: true) // Dismiss SheetVC after crop
        }
    }

    func cropViewControllerDidCancel(_ cropViewController: TOCropViewController) {
        cropViewController.dismiss(animated: true) {
            self.dismiss(animated: true)
        }
    }
    
    func temporaryURL(for image: UIImage, quality: CGFloat = 0.9) throws -> URL {
            guard let jpegData = image.jpegData(compressionQuality: quality) else {
                throw NSError(domain: "ImageEncoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data."])
            }
            let tempDir = FileManager.default.temporaryDirectory
            let fileName = "selected_image_\(UUID().uuidString).jpg"
            let fileURL = tempDir.appendingPathComponent(fileName)
            try jpegData.write(to: fileURL, options: .atomic)
            return fileURL
        }
    
    
}

