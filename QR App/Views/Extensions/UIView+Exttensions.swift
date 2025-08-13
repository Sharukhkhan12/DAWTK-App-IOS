//
//  UIView+Exttensions.swift
//  QR App
//
//  Created by Touheed khan on 30/05/2025.
//

import Foundation
import UIKit

extension UIView {
    class func loadFromNib<T>(withName nibName: String) -> T? {
        let nib = UINib.init(nibName: nibName, bundle: nil)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        for object in nibObjects {
            if let result = object as? T {
                return result
            }
        }
        return nil
    }
    func snapshotImage() -> UIImage {
        // Ensure latest layout
        self.layoutIfNeeded()
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { _ in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        
    }
}
