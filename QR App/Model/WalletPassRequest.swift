//
//  WalletPassRequest.swift
//  QR App
//
//  Created by Touheed khan on 24/08/2025.
//


import Foundation

struct WalletPassRequest {
    let stripImageUrl: String
    let headerLabel: String
    let headerValue: String
    let secondaryLabel: String
    let secondaryValue: String
    let backLabel: String
    let backValue: String
    let logoText: String
    let description: String
    let backgroundColor: String
    let foregroundColor: String
    let labelColor: String
    let barcodeMessage: String
    let cardType: String
    
    /// Convert model into parameters for multipart request
    func toMultipartParameters() -> [MultipartParameter] {
        return [
            MultipartParameter(key: "strip_image_url", type: .text(stripImageUrl), contentType: nil),
            MultipartParameter(key: "header_label", type: .text(headerLabel), contentType: nil),
            MultipartParameter(key: "header_value", type: .text(headerValue), contentType: nil),
            MultipartParameter(key: "secondary_label", type: .text(secondaryLabel), contentType: nil),
            MultipartParameter(key: "secondary_value", type: .text(secondaryValue), contentType: nil),
            MultipartParameter(key: "back_label", type: .text(backLabel), contentType: nil),
            MultipartParameter(key: "back_value", type: .text(backValue), contentType: nil),
            MultipartParameter(key: "logo_text", type: .text(logoText), contentType: nil),
            MultipartParameter(key: "description", type: .text(description), contentType: nil),
            MultipartParameter(key: "background_color", type: .text(backgroundColor), contentType: nil),
            MultipartParameter(key: "foreground_color", type: .text(foregroundColor), contentType: nil),
            MultipartParameter(key: "label_color", type: .text(labelColor), contentType: nil),
            MultipartParameter(key: "barcode_message", type: .text(barcodeMessage), contentType: nil),
            MultipartParameter(key: "card_type", type: .text(cardType), contentType: nil)
        ]
    }
}
// MARK: - Parameter Model
enum ParameterType {
    case text(String)
    case file(String)   // local file path
}

struct MultipartParameter {
    let key: String
    let type: ParameterType
    let contentType: String?
}
