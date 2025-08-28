//
//  Checkout.swift
//  QR App
//
//  Created by Touheed khan on 27/08/2025.
//


import Foundation

struct Checkout: Codable {
    let id: String
    let createdAt: String
    let modifiedAt: String?
    let paymentProcessor: String
    let status: String
    let clientSecret: String
    let url: String
    let expiresAt: String
    let successUrl: String
    let amount: Int
    let discountAmount: Int
    let netAmount: Int
    let taxAmount: Int?
    let totalAmount: Int
    let currency: String
    let productId: String
    let productPriceId: String
    let discountId: String?
    let allowDiscountCodes: Bool
    let requireBillingAddress: Bool
    let isDiscountApplicable: Bool
    let isFreeProductPrice: Bool
    let isPaymentRequired: Bool
    let isPaymentSetupRequired: Bool
    let isPaymentFormRequired: Bool
    let customerId: String?
    let isBusinessCustomer: Bool
    let customerName: String?
    let customerEmail: String?
    let customerIpAddress: String?
    let customerBillingName: String?
    let customerBillingAddress: String?
    let customerTaxId: String?
    let paymentProcessorMetadata: PaymentProcessorMetadata
    let customerBillingAddressFields: AddressFieldVisibility
    let billingAddressFields: AddressFieldRequirement
    let metadata: [String: String]
    let externalCustomerId: String?
    let customerExternalId: String?
    let products: [Product]
    let product: Product
    let productPrice: ProductPrice
    let discount: String?
    let subscriptionId: String?
    let attachedCustomFields: [String]
    let customerMetadata: [String: String]
    let subtotalAmount: Int
}

struct PaymentProcessorMetadata: Codable {
    let publishableKey: String
}

struct AddressFieldVisibility: Codable {
    let country: Bool
    let state: Bool
    let city: Bool
    let postalCode: Bool
    let line1: Bool
    let line2: Bool
}

struct AddressFieldRequirement: Codable {
    let country: String
    let state: String
    let city: String
    let postalCode: String
    let line1: String
    let line2: String
}

struct Product: Codable {
    let id: String
    let name: String
    let description: String
    let recurringInterval: String
    let isRecurring: Bool
    let isArchived: Bool
    let organizationId: String
    let createdAt: String
    let modifiedAt: String
    let prices: [ProductPrice]
    let benefits: [String]
    let medias: [ProductMedia]
}

struct ProductPrice: Codable {
    let id: String
    let amountType: String
    let isArchived: Bool
    let productId: String
    let type: String
    let recurringInterval: String
    let priceCurrency: String
    let priceAmount: Int
    let createdAt: String
    let modifiedAt: String
}

struct ProductMedia: Codable {
    let id: String
    let organizationId: String
    let name: String
    let path: String
    let mimeType: String
    let size: Int
    let storageVersion: String
    let checksumEtag: String
    let checksumSha256Base64: String
    let checksumSha256Hex: String
    let lastModifiedAt: String
    let version: String?
    let service: String
    let isUploaded: Bool
    let createdAt: String
    let sizeReadable: String
    let publicUrl: String
}
