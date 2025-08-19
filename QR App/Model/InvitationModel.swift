//
//  InvitationModel.swift
//  QR App
//
//  Created by Touheed khan on 28/06/2025.
//

import Foundation

struct InvitationModel: Codable {
    var ownerId: String
    var qrCode: String
    var profilePhotoPath: String
    var mainCardFilePath: String
    var qrCodeFilePath: String

    var groomName: String
    var brideName: String
    var date: String
    var islamicDate: String
    var eventTime: String
    var buffetTime: String
    var venue: String
    var locationLink: String
    var rsvpDetail: String

    var templateName: String
    var children: Bool
    var photography: Bool
    var smoking: Bool

    var applePay: String
    var googlePay: String
    var nft: String

    var createdDate: String
    var expiryDate: String

    var additionalBgColor: String
    var additionalFont: String

    // Default initializer
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

    // Firebase dictionary representation
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



