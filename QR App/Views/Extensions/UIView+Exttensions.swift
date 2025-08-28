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
extension UIView {
    func showToast(message: String, duration: Double = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: 20,
                                               y: self.frame.size.height - 100,
                                               width: self.frame.size.width - 40,
                                               height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { (_) in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
