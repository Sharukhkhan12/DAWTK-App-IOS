//
//  CardView.swift
//  QR App
//
//  Created by Touheed khan on 30/05/2025.
//


import UIKit

class CardView: UIView {

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = .white
        
        // Rounded corners
        layer.cornerRadius = 10
        
        // Shadow setup
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        
        // Important so shadow is visible outside bounds
        layer.masksToBounds = false
    }
}
