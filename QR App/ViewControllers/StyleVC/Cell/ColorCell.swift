//
//  ColorCell.swift
//  QRScan
//
//  Created by iMac on 22/07/2025.
//

import UIKit

class ColorCell: UICollectionViewCell {
    private let cursorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCursorView()
        contentView.layer.cornerRadius = 0
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCursorView()
    }

    private func setupCursorView() {
        cursorView.layer.borderColor = UIColor.white.cgColor
        cursorView.layer.borderWidth = 20
        cursorView.layer.cornerRadius = 20
        cursorView.backgroundColor = .clear
        cursorView.isHidden = true
        cursorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cursorView)

        NSLayoutConstraint.activate([
            cursorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cursorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cursorView.widthAnchor.constraint(equalToConstant: 0),
            cursorView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }

    func configure(with color: UIColor, selected: Bool) {
        contentView.backgroundColor = color
        cursorView.isHidden = !selected
    }

    
}

