//
//  UserBusinessCardModel.swift
//  QR App
//
//  Created by Touheed khan on 16/06/2025.
//


struct UserBusinessCardModel: Codable {
    var applePay: String = ""
    var companyLogoPath: String = ""
    var companyName: String = ""
    var createdDate: String = ""
    var deviceName: String = ""
    var email: String = ""
    var expiryDate: String = ""
    var facebookLink: String = ""
    var fullName: String = ""
    var googlePay: String = ""
    var instagramLink: String = ""
    var jobTitle: String = ""
    var linkedinLink: String = ""
    var location: String = ""
    var locationLink: String = ""
    var mainCardFilePath: String = ""
    var nft: String = ""
    var ownerId: String = ""
    var phoneNo: String = ""
    var profilePhotoPath: String = ""
    var qrCode: String = ""
    var qrCodeFilePath: String = ""
    var snapchatLink: String = ""
    var templateName: String = ""
    var tiktokLink: String = ""
    var websiteUrl: String = ""
    var whatsappLink: String = ""
    var additionalFont: String = ""
    var additionalBgColor: String = ""
    var xlink: String = ""

    // ✅ Default memberwise initializer
    init(
        applePay: String = "",
        companyLogoPath: String = "",
        companyName: String = "",
        createdDate: String = "",
        deviceName: String = "",
        email: String = "",
        expiryDate: String = "",
        facebookLink: String = "",
        fullName: String = "",
        googlePay: String = "",
        instagramLink: String = "",
        jobTitle: String = "",
        linkedinLink: String = "",
        location: String = "",
        locationLink: String = "",
        mainCardFilePath: String = "",
        nft: String = "",
        ownerId: String = "",
        phoneNo: String = "",
        profilePhotoPath: String = "",
        qrCode: String = "",
        qrCodeFilePath: String = "",
        snapchatLink: String = "",
        templateName: String = "",
        tiktokLink: String = "",
        websiteUrl: String = "",
        whatsappLink: String = "",
        additionalFont: String = "",
        additionalBgColor: String = "",
        xlink: String = ""
    ) {
        self.applePay = applePay
        self.companyLogoPath = companyLogoPath
        self.companyName = companyName
        self.createdDate = createdDate
        self.deviceName = deviceName
        self.email = email
        self.expiryDate = expiryDate
        self.facebookLink = facebookLink
        self.fullName = fullName
        self.googlePay = googlePay
        self.instagramLink = instagramLink
        self.jobTitle = jobTitle
        self.linkedinLink = linkedinLink
        self.location = location
        self.locationLink = locationLink
        self.mainCardFilePath = mainCardFilePath
        self.nft = nft
        self.ownerId = ownerId
        self.phoneNo = phoneNo
        self.profilePhotoPath = profilePhotoPath
        self.qrCode = qrCode
        self.qrCodeFilePath = qrCodeFilePath
        self.snapchatLink = snapchatLink
        self.templateName = templateName
        self.tiktokLink = tiktokLink
        self.websiteUrl = websiteUrl
        self.whatsappLink = whatsappLink
        self.additionalFont = additionalFont
        self.additionalBgColor = additionalBgColor
        self.xlink = xlink
    }

    // ✅ toDictionary stays as-is
    func toDictionary() -> [String: Any] {
        [
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

    // ✅ Safe decoding from Firebase
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.applePay = try container.decodeIfPresent(String.self, forKey: .applePay) ?? ""
        self.companyLogoPath = try container.decodeIfPresent(String.self, forKey: .companyLogoPath) ?? ""
        self.companyName = try container.decodeIfPresent(String.self, forKey: .companyName) ?? ""
        self.createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate) ?? ""
        self.deviceName = try container.decodeIfPresent(String.self, forKey: .deviceName) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.expiryDate = try container.decodeIfPresent(String.self, forKey: .expiryDate) ?? ""
        self.facebookLink = try container.decodeIfPresent(String.self, forKey: .facebookLink) ?? ""
        self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        self.googlePay = try container.decodeIfPresent(String.self, forKey: .googlePay) ?? ""
        self.instagramLink = try container.decodeIfPresent(String.self, forKey: .instagramLink) ?? ""
        self.jobTitle = try container.decodeIfPresent(String.self, forKey: .jobTitle) ?? ""
        self.linkedinLink = try container.decodeIfPresent(String.self, forKey: .linkedinLink) ?? ""
        self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        self.locationLink = try container.decodeIfPresent(String.self, forKey: .locationLink) ?? ""
        self.mainCardFilePath = try container.decodeIfPresent(String.self, forKey: .mainCardFilePath) ?? ""
        self.nft = try container.decodeIfPresent(String.self, forKey: .nft) ?? ""
        self.ownerId = try container.decodeIfPresent(String.self, forKey: .ownerId) ?? ""
        self.phoneNo = try container.decodeIfPresent(String.self, forKey: .phoneNo) ?? ""
        self.profilePhotoPath = try container.decodeIfPresent(String.self, forKey: .profilePhotoPath) ?? ""
        self.qrCode = try container.decodeIfPresent(String.self, forKey: .qrCode) ?? ""
        self.qrCodeFilePath = try container.decodeIfPresent(String.self, forKey: .qrCodeFilePath) ?? ""
        self.snapchatLink = try container.decodeIfPresent(String.self, forKey: .snapchatLink) ?? ""
        self.templateName = try container.decodeIfPresent(String.self, forKey: .templateName) ?? ""
        self.tiktokLink = try container.decodeIfPresent(String.self, forKey: .tiktokLink) ?? ""
        self.websiteUrl = try container.decodeIfPresent(String.self, forKey: .websiteUrl) ?? ""
        self.whatsappLink = try container.decodeIfPresent(String.self, forKey: .whatsappLink) ?? ""
        self.additionalFont = try container.decodeIfPresent(String.self, forKey: .additionalFont) ?? ""
        self.additionalBgColor = try container.decodeIfPresent(String.self, forKey: .additionalBgColor) ?? ""
    }
}

