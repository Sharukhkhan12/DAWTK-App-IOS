//
//  InvitationFieldType.swift
//  QR App
//
//  Created by Touheed khan on 28/06/2025.
//


enum InvitationFieldType: Int, CaseIterable {
    case profileImage      // 0
    case groomName         // 1
    case brideName         // 2
    case date              // 3
    case islamicDate       // 4
    case eventTime         // 5
    case buffetTime        // 6
    case venue             // 7
    case locationLink      // 8
    case rsvpDetail        // 9

    var placeholder: String {
        switch self {
        case .profileImage: return "Upload Card Image"
        case .groomName: return "Enter Groom Name"
        case .brideName: return "Enter Bride Name"
        case .date: return "Enter Wedding Date"
        case .islamicDate: return "Enter Islamic Date"
        case .eventTime: return "Enter Event Time"
        case .buffetTime: return "Enter Buffet Time"
        case .venue: return "Enter Venue"
        case .locationLink: return "Enter Location Link"
        case .rsvpDetail: return "Enter RSVP Details"
        }
    }

    var showsUploadIcon: Bool {
        return self == .profileImage
    }
}
