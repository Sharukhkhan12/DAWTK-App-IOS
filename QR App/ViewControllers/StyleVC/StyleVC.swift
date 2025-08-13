//
//  StyleViewController.swift
//  QR App
//
//  Created by MacBook Air on 30/07/2025.
//


import UIKit

class StyleVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    var fonts = UIFont.familyNames.sorted()
    var onFontSelected: ((String) -> Void)?
    var colorCursor: UIView?
    var collectionView: UICollectionView!
    var colors: [UIColor] = []
    let rows = 6
    let columns = 20
    var selectedIndexPath: IndexPath?
    var cardInfo: UserBusinessCardModel?
    var selectedIdentifier = ""
    var progressAlert = ProgressAlertView()
    var selectedTemplateView: UIView?

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var COlorPaleteView: UIView!
    @IBOutlet weak var ViewScreen: UIView!
    @IBOutlet weak var SelectedView: UIView!
    @IBOutlet weak var ColorPalette: UIView!
    @IBOutlet weak var TextFielsFont: UITextField!
    @IBOutlet weak var TextView: UIView!
    @IBOutlet weak var grenView: UIView!
    @IBOutlet weak var StyleView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        COlorPaleteView.backgroundColor = .white
        tableView.isHidden = true
                colors = generateColorPalette(rows: rows, columns: columns)
                
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

                
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                collectionView.translatesAutoresizingMaskIntoConstraints = false
                collectionView.dataSource = self
                collectionView.delegate = self
        
        
                collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
                collectionView.backgroundColor = .white
                
        COlorPaleteView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: COlorPaleteView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: COlorPaleteView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: COlorPaleteView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: COlorPaleteView.trailingAnchor)
        ])
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        collectionView.addGestureRecognizer(panGesture)
        setup()
        setupText()
        nibRegister()
        tableView.dataSource = self
        tableView.delegate = self
       
        DispatchQueue.main.async {
            self.loadTheView()
        }
        
    }
    
    
    
    
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        
        // Find the indexPath at that location
        if let indexPath = collectionView.indexPathForItem(at: location),
           indexPath != selectedIndexPath {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            self.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    
    
    func loadTheView() {
        loadSelectedCardView(in: self.ViewScreen) { [weak self] templateView in
            guard let self = self, let templateView = templateView else { return }

            // Clear previous preview
            self.ViewScreen.subviews.forEach { $0.removeFromSuperview() }

            // Add the selected template view
            self.ViewScreen.addSubview(templateView)
            self.selectedTemplateView = templateView // ← ✅ Assign here

            // Force layout before scaling
            self.ViewScreen.layoutIfNeeded()
            templateView.layoutIfNeeded()

            // 🔁 Auto scale to fit, if conforming
            if let scalable = templateView as? ScalableCardView {
                scalable.scaleToFit(in: self.ViewScreen)
            }
        }
    }
   
    func loadSelectedCardView(in container: UIView, completion: @escaping (UIView?) -> Void) {
        guard let templateName = cardInfo?.templateName else {
            print("❌ No template name in cardInfo")
            completion(nil)
            return
        }

        guard let logoURL = URL(string: cardInfo?.companyLogoPath ?? ""),
              let profileURL = URL(string: cardInfo?.profilePhotoPath ?? ""),
              let qrCardURL = URL(string: cardInfo?.qrCodeFilePath ?? "") else {
            print("❌ Invalid image URLs")
            completion(nil)
            return
        }

        // 🔄 Add activity indicator to container view
        progressAlert.show()

        let group = DispatchGroup()
        var logoImage: UIImage?
        var profileImage: UIImage?
        var qrCodeFilePath: UIImage?

        group.enter()
        URLSession.shared.dataTask(with: logoURL) { data, _, _ in
            if let data = data { logoImage = UIImage(data: data) }
            group.leave()
        }.resume()

        group.enter()
        URLSession.shared.dataTask(with: profileURL) { data, _, _ in
            if let data = data { profileImage = UIImage(data: data) }
            group.leave()
        }.resume()

        group.enter()
        URLSession.shared.dataTask(with: qrCardURL) { data, _, _ in
            if let data = data { qrCodeFilePath = UIImage(data: data) }
            group.leave()
        }.resume()

        group.notify(queue: .main) {
            self.progressAlert.dismiss()

            var view: UIView?

            switch templateName {
            case "1":
                if let cell = Bundle.main.loadNibNamed("Template8CVC", owner: nil, options: nil)?.first as? Template8CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "2":
                if let cell = Bundle.main.loadNibNamed("Template7CVC", owner: nil, options: nil)?.first as? Template7CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "3":
                if let cell = Bundle.main.loadNibNamed("Template6CVC", owner: nil, options: nil)?.first as? Template6CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "4":
                if let cell = Bundle.main.loadNibNamed("Template5CVC", owner: nil, options: nil)?.first as? Template5CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "5":
                if let cell = Bundle.main.loadNibNamed("Template4CVC", owner: nil, options: nil)?.first as? Template4CVC {
                    cell.configure(with: self.cardInfo!)
                    cell.buismesslogo.image = logoImage
                    cell.profileImage.image = profileImage
                    cell.qrimageofCard.image = qrCodeFilePath
                    view = cell
                }
            case "6":
                if let cell = Bundle.main.loadNibNamed("Template3CVC", owner: nil, options: nil)?.first as? Template3CVC {
                    cell.configure(with: self.cardInfo!)
                    view = cell
                }
            case "7":
                if let cell = Bundle.main.loadNibNamed("Template2CVC", owner: nil, options: nil)?.first as? Template2CVC {
                    cell.configure(with: self.cardInfo!)
                    view = cell
                }
            default:
                print("⚠️ Unknown template identifier: \(templateName)")
            }

            completion(view)
        }
    }


    
  

    
    func nibRegister()
    {
        let nib = UINib(nibName:"FontTableViewCell" , bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FontCell")
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func openTextfont(_ sender: UIButton) {
        tableView.isHidden.toggle()
        
        
    }
    


    func generateColorPalette(rows: Int, columns: Int) -> [UIColor] {
        var palette: [UIColor] = []

        for row in 0..<rows {
            for column in 0..<columns {
                let hue = CGFloat(column) / CGFloat(columns)
                let saturation = CGFloat(row + 1) / CGFloat(rows + 1)
                let brightness: CGFloat = 1.0
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                palette.append(color)
            }
        }
        return palette
    }
    
    
    
    
    func setup()
    {
        ViewScreen.layer.cornerRadius = 10
        ViewScreen.clipsToBounds = true
        grenView.layer.cornerRadius = 10
        grenView.clipsToBounds = true
        TextView.layer.cornerRadius = 10
        TextView.clipsToBounds = true
        TextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        TextView.layer.borderWidth = 1.0
        TextFielsFont.placeholder = " Choose font"
        ColorPalette.layer.cornerRadius = 10
        ColorPalette.clipsToBounds = true
        SelectedView.layer.cornerRadius = 10
        SelectedView.clipsToBounds = true

        
    }
    func setupText() {
        TextFielsFont.attributedPlaceholder = NSAttributedString(
            string: "   Choose font",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )

        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return colors.count
     }

    
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
         let color = colors[indexPath.item]
         cell.configure(with: color, selected: indexPath == selectedIndexPath)
         return cell
     }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previous = selectedIndexPath
        selectedIndexPath = indexPath
        if let previous = previous {
            collectionView.reloadItems(at: [previous])
        }
        collectionView.reloadItems(at: [indexPath])
        
        // Get selected color
        let selectedColor = colors[indexPath.item]
        
        // Set selected color to views
        SelectedView.backgroundColor = selectedColor
//        ViewScreen.backgroundColor = selectedColor
        if let scalable = selectedTemplateView as? ScalableCardView,
           let cardView = scalable.cardContentView {
            cardView.backgroundColor = selectedColor
        }
        // 👇 CURSOR ADDITION 👇

        // Remove previous cursor
        colorCursor?.removeFromSuperview()

        // Get the selected cell
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        // Create new square cursor
        let cursorSize: CGFloat = 24
        let cursor = UIView(frame: CGRect(x: 0, y: 0, width: cursorSize, height: cursorSize))
        cursor.center = cell.center
        cursor.backgroundColor = .clear
        cursor.layer.borderWidth = 1
        cursor.layer.borderColor = UIColor.white.cgColor
        cursor.layer.cornerRadius = 2// square
        cursor.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        collectionView.addSubview(cursor)
        colorCursor = cursor

        // Animate cursor "pop"
        UIView.animate(withDuration: 0.3) {
            cursor.transform = .identity
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(columns)
        let height = collectionView.bounds.height / CGFloat(rows)
        return CGSize(width: width, height: height)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return fonts.count
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 // or any height you prefer (e.g., 70, 80)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell", for: indexPath) as? FontTableViewCell else {
            return UITableViewCell()
        }

        let fontName = fonts[indexPath.row]
        cell.fontsLabel.text = fontName
        cell.fontsLabel.font = UIFont(name: fontName, size: 17)
        
        return cell
    }
    
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFont = fonts[indexPath.row]
        
        // Set selected font to text field
        TextFielsFont.text = selectedFont
        TextFielsFont.font = UIFont(name: selectedFont, size: 18)
        
        // Hide the table view after selection
        tableView.isHidden = true
    }


   }
    
