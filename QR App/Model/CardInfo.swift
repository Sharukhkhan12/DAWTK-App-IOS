//
//  CardInfo.swift
//  QR App
//
//  Created by Touheed khan on 01/06/2025.
//

import Foundation
struct CardInfo {
    var fullName: String = ""
    var profilePicture: String = "" // Could be a URL or file path later
    var email: String = ""
    var mobileNumber: String = ""
    var companyName: String = ""
    var jobTitle: String = ""
    var websiteURL: String = ""
    var logo: String = "" // Could be a URL or file path later
}


enum CardFieldType: Int, CaseIterable {
    case fullName = 0
    case profilePicture
    case email
    case mobileNumber
    case companyName
    case jobTitle
    case websiteURL
    case logo

    var placeholder: String {
        switch self {
        case .fullName: return "Your full name"
        case .profilePicture: return "Upload profile picture"
        case .email: return "Your email"
        case .mobileNumber: return "Mobile number"
        case .companyName: return "Company Name"
        case .jobTitle: return "Job title"
        case .websiteURL: return "Website URL"
        case .logo: return "Upload logo"
        }
    }

    var showsUploadIcon: Bool {
        return self == .profilePicture || self == .logo
    }
}
