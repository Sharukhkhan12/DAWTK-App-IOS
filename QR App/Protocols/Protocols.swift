//
//  Protocols.swift
//  QR App
//
//  Created by Touheed khan on 20/08/2025.
//

import Foundation
import UIKit

// For Biussness Cards
protocol ScalableCardView {
    func scaleToFit(in container: UIView)
    var cardContentView: UIView? { get } // 👈 Add this

}

// MARK: - Protocol for Font Customization
protocol FontCustomizable {
    func applyFont(_ fontName: String)
}

protocol InvitationScalableCardView {
    func scaleToFit(in container: UIView)
    var cardContentView: UIView? { get } // 👈 Add this

}

// MARK: - Protocol for Font Customization
protocol InvitationFontCustomizable {
    func applyFont(_ fontName: String)
}
