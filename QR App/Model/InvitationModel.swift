//
//  InvitationModel.swift
//  QR App
//
//  Created by Touheed khan on 28/06/2025.
//

import Foundation

struct InvitationModel: Codable {
    var ownerId: String = ""
    var qrCode: String = ""
    var profilePhotoPath: String = ""
    var mainCardFilePath: String = ""
    var qrCodeFilePath: String = ""

    var groomName: String = ""
    var brideName: String = ""
    var date: String = ""
    var islamicDate: String = ""
    var eventTime: String = ""
    var buffetTime: String = ""
    var venue: String = ""
    var locationLink: String = ""
    var rsvpDetail: String = ""

    var templateName: String = ""
    var children: Bool = false
    var photography: Bool = false
    var smoking: Bool = false

    var applePay: String = ""
    var googlePay: String = ""
    var nft: String = ""

    var createdDate: String = ""
    var expiryDate: String = ""

    var additionalBgColor: String = ""
    var additionalFont: String = ""

    // ✅ Default initializer (keeps previous usage intact)
    init(
        ownerId: String = "",
        qrCode: String = "",
        profilePhotoPath: String = "",
        mainCardFilePath: String = "",
        qrCodeFilePath: String = "",
        groomName: String = "",
        brideName: String = "",
        date: String = "",
        islamicDate: String = "",
        eventTime: String = "",
        buffetTime: String = "",
        venue: String = "",
        locationLink: String = "",
        rsvpDetail: String = "",
        templateName: String = "",
        children: Bool = false,
        photography: Bool = false,
        smoking: Bool = false,
        applePay: String = "",
        googlePay: String = "",
        nft: String = "",
        createdDate: String = "",
        expiryDate: String = "",
        additionalBgColor: String = "",
        additionalFont: String = ""
    ) {
        self.ownerId = ownerId
        self.qrCode = qrCode
        self.profilePhotoPath = profilePhotoPath
        self.mainCardFilePath = mainCardFilePath
        self.qrCodeFilePath = qrCodeFilePath
        self.groomName = groomName
        self.brideName = brideName
        self.date = date
        self.islamicDate = islamicDate
        self.eventTime = eventTime
        self.buffetTime = buffetTime
        self.venue = venue
        self.locationLink = locationLink
        self.rsvpDetail = rsvpDetail
        self.templateName = templateName
        self.children = children
        self.photography = photography
        self.smoking = smoking
        self.applePay = applePay
        self.googlePay = googlePay
        self.nft = nft
        self.createdDate = createdDate
        self.expiryDate = expiryDate
        self.additionalBgColor = additionalBgColor
        self.additionalFont = additionalFont
    }

    // ✅ Safe decoding from Firebase
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.ownerId = try container.decodeIfPresent(String.self, forKey: .ownerId) ?? ""
        self.qrCode = try container.decodeIfPresent(String.self, forKey: .qrCode) ?? ""
        self.profilePhotoPath = try container.decodeIfPresent(String.self, forKey: .profilePhotoPath) ?? ""
        self.mainCardFilePath = try container.decodeIfPresent(String.self, forKey: .mainCardFilePath) ?? ""
        self.qrCodeFilePath = try container.decodeIfPresent(String.self, forKey: .qrCodeFilePath) ?? ""
        self.groomName = try container.decodeIfPresent(String.self, forKey: .groomName) ?? ""
        self.brideName = try container.decodeIfPresent(String.self, forKey: .brideName) ?? ""
        self.date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
        self.islamicDate = try container.decodeIfPresent(String.self, forKey: .islamicDate) ?? ""
        self.eventTime = try container.decodeIfPresent(String.self, forKey: .eventTime) ?? ""
        self.buffetTime = try container.decodeIfPresent(String.self, forKey: .buffetTime) ?? ""
        self.venue = try container.decodeIfPresent(String.self, forKey: .venue) ?? ""
        self.locationLink = try container.decodeIfPresent(String.self, forKey: .locationLink) ?? ""
        self.rsvpDetail = try container.decodeIfPresent(String.self, forKey: .rsvpDetail) ?? ""
        self.templateName = try container.decodeIfPresent(String.self, forKey: .templateName) ?? ""
        self.children = try container.decodeIfPresent(Bool.self, forKey: .children) ?? false
        self.photography = try container.decodeIfPresent(Bool.self, forKey: .photography) ?? false
        self.smoking = try container.decodeIfPresent(Bool.self, forKey: .smoking) ?? false
        self.applePay = try container.decodeIfPresent(String.self, forKey: .applePay) ?? ""
        self.googlePay = try container.decodeIfPresent(String.self, forKey: .googlePay) ?? ""
        self.nft = try container.decodeIfPresent(String.self, forKey: .nft) ?? ""
        self.createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate) ?? ""
        self.expiryDate = try container.decodeIfPresent(String.self, forKey: .expiryDate) ?? ""
        self.additionalBgColor = try container.decodeIfPresent(String.self, forKey: .additionalBgColor) ?? ""
        self.additionalFont = try container.decodeIfPresent(String.self, forKey: .additionalFont) ?? ""
    }

    // ✅ Firebase dictionary representation stays unchanged
    func toDictionary() -> [String: Any] {
        return [
            "ownerId": ownerId,
            "qrCode": qrCode,
            "profilePhotoPath": profilePhotoPath,
            "mainCardFilePath": mainCardFilePath,
            "qrCodeFilePath": qrCodeFilePath,
            "groomName": groomName,
            "brideName": brideName,
            "date": date,
            "islamicDate": islamicDate,
            "eventTime": eventTime,
            "buffetTime": buffetTime,
            "venue": venue,
            "locationLink": locationLink,
            "rsvpDetail": rsvpDetail,
            "templateName": templateName,
            "children": children,
            "photography": photography,
            "smoking": smoking,
            "applePay": applePay,
            "googlePay": googlePay,
            "nft": nft,
            "createdDate": createdDate,
            "expiryDate": expiryDate,
            "additionalBgColor": additionalBgColor,
            "additionalFont": additionalFont
        ]
    }
}


