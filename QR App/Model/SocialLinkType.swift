//
//  SocialLinkType.swift
//  QR App
//
//  Created by Touheed khan on 15/06/2025.
//


enum SocialLinkType: Int, CaseIterable {
    case facebook
    case instagram
    case snapchat
    case tiktok
    case x
    case whatsapp

    var placeholder: String {
        switch self {
        case .facebook: return "Enter your facebook link"
        case .instagram: return "Enter your instagram link"
        case .snapchat: return "Enter your snapchat link"
        case .tiktok: return "Enter your tiktok link"
        case .x: return "Enter your X link"
        case .whatsapp: return "Enter your whatsapp link"
        }
    }

    var iconName: String {
        switch self {
        case .facebook: return "Vector" // asset name
        case .instagram: return "instagram"
        case .snapchat: return "snapchat"
        case .tiktok: return "video"
        case .x: return "social-media"
        case .whatsapp: return "whatsapp"
        }
    }

    var showsUploadIcon: Bool {
        return true
    }
}
