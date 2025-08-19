//
//  CostumAlertForLocationn.swift
//  QR App
//
//  Created by Touheed khan on 16/08/2025.
//

import UIKit

class CostumAlertForLocationn: UIView, UITextViewDelegate {
    
    var pasteAction: (() -> Void)?
    var verifyAction: ((String) -> Void)? // takes the text
    
    @IBOutlet weak var errorMessagelbl: UILabel!
    @IBOutlet weak var editLinkTxtView: UITextView!
    @IBOutlet weak var pasteBtn: UIButton!
    @IBOutlet weak var verifyLinkActionBtn: UIButton!
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter or paste link here..."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    class func instantiateFromNib() -> CostumAlertForLocationn {
        return Bundle.main.loadNibNamed("CostumAlertForLocationn", owner: nil, options: nil)!.first as! CostumAlertForLocationn
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        errorMessagelbl.isHidden = true
        // Setup textView delegate
        editLinkTxtView.delegate = self
        
        // Add placeholder inside textView
        placeholderLabel.frame = CGRect(x: 5, y: 5, width: editLinkTxtView.bounds.width - 10, height: 20)
        editLinkTxtView.addSubview(placeholderLabel)
        placeholderLabel.isHidden = !editLinkTxtView.text.isEmpty
        
        // Add gestures to buttons
        pasteBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePasteTap)))
        verifyLinkActionBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleVerifyTap)))
    }
    
    @objc private func handlePasteTap() {
        pasteAction?()  // call closure instead of hardcoding
        placeholderLabel.isHidden = !(editLinkTxtView.text?.isEmpty ?? true)
    }
    @objc private func handleVerifyTap() {
        let text = editLinkTxtView.text ?? ""
        
        if isValidURL(text) {
            // hide error with fade out
            if !errorMessagelbl.isHidden {
                UIView.animate(withDuration: 0.25) {
                    self.errorMessagelbl.alpha = 0
                } completion: { _ in
                    self.errorMessagelbl.isHidden = true
                }
            }
            verifyAction?(text)
            
        } else {
            errorMessagelbl.text = "please provide correct location"
            
            if errorMessagelbl.isHidden {
                errorMessagelbl.alpha = 0
                errorMessagelbl.isHidden = false
            }
            
            // fade in
            UIView.animate(withDuration: 0.25) {
                self.errorMessagelbl.alpha = 1
            }
        }
    }

    
    
    // Simple URL validation
    private func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

