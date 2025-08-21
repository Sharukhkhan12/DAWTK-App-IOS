//
//  AppNotifications.swift
//  QR App
//
//  Created by Touheed khan on 16/06/2025.
//

import Foundation

extension Notification.Name {
    static let imageSelectedNotification = Notification.Name("imageSelectedNotification")
    
    static let imageSelectedForLogo = Notification.Name("imageSelectedForLogo")
    
    static let didTapBackButton = Notification.Name("didTapBackButton")
    
    static let didTapBackButtonFromLogoScreen = Notification.Name("didTapBackButtonFromLogoScreen")
    
    static let reloadKolodaCards = Notification.Name("reloadKolodaCards")
    
    static let userFromMyCardsScreen = Notification.Name("userFromMyCardsScreen")

    static let userFromInviationCard = Notification.Name("userFromInviationCard")

    static let reloadViewAnalysisData = Notification.Name("reloadViewAnalysisData")

    
}
