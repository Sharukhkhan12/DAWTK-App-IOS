//
//  PremiumAlert.swift
//  QR App
//
//  Created by Touheed khan on 30/07/2025.
//

import UIKit

protocol PremiumAlertDelegate: AnyObject {
    func didSelectView()
    func didSelectEditCard()
    func didSelectRedesign()
    func didSelectAnalytics()
    func didSelectAddToWallet()
    func didSelectSharing()
    func didSelectDelete()
}


class PremiumAlert: UIView {

    @IBOutlet weak var updateCardlbl: UILabel!
    @IBOutlet weak var optionsTV: UITableView!

    // Data Model: Image name, title, isDestructive, isSystemImage
    private let options: [(image: String, title: String, isDestructive: Bool, isSystemImage: Bool)] = [
        ("eye", "View as", false, true),                         // New system image at index 0
        ("edit", "Edit Card", false, false),
        ("command", "Re-design", false, false),
        ("doughnut chart", "View Analytics", false, false),
        ("credit-card", "Add to Wallet", false, false),
        ("share", "Sharing", false, false),
        ("trash", "Delete", true, false)                     // Red destructive option
    ]
    
    weak var delegate: PremiumAlertDelegate?


    class func instantiateFromNib() -> PremiumAlert {
        return Bundle.main.loadNibNamed("PremiumAlert", owner: nil, options: nil)!.first as! PremiumAlert
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }

    private func setupTableView() {
        optionsTV.delegate = self
        optionsTV.dataSource = self
        optionsTV.register(UINib(nibName: "OptionsTVC", bundle: nil), forCellReuseIdentifier: "OptionsTVC")
        optionsTV.separatorStyle = .none
    }
}

// MARK: - UITableView Delegate & DataSource

extension PremiumAlert: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTVC", for: indexPath) as? OptionsTVC else {
            return UITableViewCell()
        }

        let option = options[indexPath.row]
        cell.optionslbl.text = option.title
        cell.optionslbl.textColor = option.isDestructive ? .red : .label

        // Set image: use system image if marked
        if option.isSystemImage {
            cell.optionsImgView.image = UIImage(systemName: option.image)
        } else {
            cell.optionsImgView.image = UIImage(named: option.image)
        }

        // Bottom line visibility
        cell.bottomline.backgroundColor = option.isDestructive ? .clear : .label

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            print("Action: View")
            delegate?.didSelectView()

        case 1:
            print("Action: Edit Card")
            delegate?.didSelectEditCard()

        case 2:
            print("Action: Re-design")
            delegate?.didSelectRedesign()

        case 3:
            print("Action: View Analytics")
            delegate?.didSelectAnalytics()

        case 4:
            print("Action: Add to Wallet")
            delegate?.didSelectAddToWallet()

        case 5:
            print("Action: Sharing")
            delegate?.didSelectSharing()

        case 6:
            print("Action: Delete")
            delegate?.didSelectDelete()

        default:
            print("Unknown action")
        }
    }



    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

