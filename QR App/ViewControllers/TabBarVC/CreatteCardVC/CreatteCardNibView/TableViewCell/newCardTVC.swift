//
//  newCardTVC.swift
//  QR App
//
//  Created by Touheed khan on 01/06/2025.
//


import UIKit

class newCardTVC: UITableViewCell {

    @IBOutlet weak var uploadIcon: UIImageView!
    @IBOutlet weak var inputTxtField: UITextField!
    
    public let placeholderLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup placeholderLabel appearance
        placeholderLabel.font = inputTxtField.font
        placeholderLabel.textColor = .lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add placeholder label to text field
        inputTxtField.addSubview(placeholderLabel)

        // Constraints for placeholder label inside text field
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: inputTxtField.leadingAnchor, constant: 4),
            placeholderLabel.centerYAnchor.constraint(equalTo: inputTxtField.centerYAnchor)
        ])
        
        // Add editing changed event to hide/show label dynamically
        inputTxtField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    func configurePlaceholder(_ text: String) {
        placeholderLabel.text = text
        placeholderLabel.isHidden = !(inputTxtField.text?.isEmpty ?? true)
    }

    @objc private func textDidChange() {
        placeholderLabel.isHidden = !(inputTxtField.text?.isEmpty ?? true)
    }
}


