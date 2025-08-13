//
//  NibProfileView.swift
//  QRScan
//
//  Created by iMac on 19/07/2025.
//

import UIKit

class UserProfileViews: UIView {

    class func loadFromNib() -> UserProfileViews? {
           return self.loadFromNibb(withName: "UserProfileViews")
       }

}
extension UIView {
    class func loadFromNibb<T>(withName nibName: String) -> T? {
        let nib = UINib.init(nibName: nibName, bundle: nil)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        for object in nibObjects {
            if let result = object as? T {
                return result
            }
        }
        return nil
    }

}
