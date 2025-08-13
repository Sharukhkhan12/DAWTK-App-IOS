//
//  NSLayoutConstraint+Extension.swift
//  QR App
//
//  Created by Touheed khan on 12/07/2025.
//

import Foundation
import UIKit
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
