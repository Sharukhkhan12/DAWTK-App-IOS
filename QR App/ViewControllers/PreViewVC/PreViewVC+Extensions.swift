//
//  PreViewVC+Extensions.swift
//  QR App
//
//  Created by MacBook Air on 28/07/2025.
//

import Foundation
import UIKit
extension PreViewVC {
     func navigateToTabBarScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC {
            tabBarVC.modalTransitionStyle = .crossDissolve
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true)
        }
    }
}
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
