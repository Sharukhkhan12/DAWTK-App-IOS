//
//  UserBusinessCardModel.swift
//  QR App
//
//  Created by Touheed khan on 16/06/2025.
//



import Foundation

struct UserBusinessCardModel: Codable {
    var applePay: String
    var companyLogoPath: String
    var companyName: String
    var createdDate: String
    var deviceName: String
    var email: String
    var expiryDate: String
    var facebookLink: String
    var fullName: String
    var googlePay: String
    var instagramLink: String
    var jobTitle: String
    var linkedinLink: String
    var location: String
    var locationLink: String
    var mainCardFilePath: String
    var nft: String
    var ownerId: String
    var phoneNo: String
    var profilePhotoPath: String
    var qrCode: String
    var qrCodeFilePath: String
    var snapchatLink: String
    var templateName: String
    var tiktokLink: String
    var websiteUrl: String
    var whatsappLink: String
    var additionalFont: String
    var additionalBgColor: String

    func toDictionary() -> [String: Any] {
        return [
            "applePay": applePay,
            "companyLogoPath": companyLogoPath,
            "companyName": companyName,
            "createdDate": createdDate,
            "deviceName": deviceName,
            "email": email,
            "expiryDate": expiryDate,
            "facebookLink": facebookLink,
            "fullName": fullName,
            "googlePay": googlePay,
            "instagramLink": instagramLink,
            "jobTitle": jobTitle,
            "linkedinLink": linkedinLink,
            "location": location,
            "locationLink": locationLink,
            "mainCardFilePath": mainCardFilePath,
            "nft": nft,
            "ownerId": ownerId,
            "phoneNo": phoneNo,
            "profilePhotoPath": profilePhotoPath,
            "qrCode": qrCode,
            "qrCodeFilePath": qrCodeFilePath,
            "snapchatLink": snapchatLink,
            "templateName": templateName,
            "tiktokLink": tiktokLink,
            "websiteUrl": websiteUrl,
            "whatsappLink": whatsappLink,
            "additionalFont": additionalFont,
            "additionalBgColor": additionalBgColor
        ]
    }
}


