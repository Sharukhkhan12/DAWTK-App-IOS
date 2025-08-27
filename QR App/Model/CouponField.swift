//
//  CouponField.swift
//  QR App
//
//  Created by Touheed khan on 27/08/2025.
//


import Foundation

// MARK: - Reusable Field
struct CouponField {
    let label: String
    let value: String
}

// MARK: - Coupon Model
struct CouponModel {
    var logo: String?                   // local file path or URL
    var logoText: String?
    
    var headerField: CouponField?
    var primaryField: CouponField?
    
    var stripImage: String?             // local file path or URL
    
    var secondaryFields: [CouponField] = []
    var auxiliaryFields: [CouponField] = []
    
    var barcodeMessage: String?
    var barcodeType: String?            // e.g., "PDF417", "QR", "AZTEC"
}

class CouponValidator {
    
    static func validate(coupon: CouponModel) -> [String] {
        var missingFields: [String] = []
        
        if coupon.logo == nil || coupon.logo?.isEmpty == true {
            missingFields.append("Logo")
        }
        
        if coupon.logoText == nil || coupon.logoText?.isEmpty == true {
            missingFields.append("Logo text")
        }
        
        if coupon.headerField == nil {
            missingFields.append("Header fields")
        }
        
        if coupon.primaryField == nil {
            missingFields.append("Primary field")
        }
        
        if coupon.stripImage == nil || coupon.stripImage?.isEmpty == true {
            missingFields.append("Strip image")
        }
        
        if coupon.secondaryFields.isEmpty {
            missingFields.append("Secondary fields")
        }
        
        if coupon.auxiliaryFields.isEmpty {
            missingFields.append("Auxiliary fields")
        }
        
        if coupon.barcodeMessage == nil || coupon.barcodeMessage?.isEmpty == true {
            missingFields.append("Barcode message")
        }
        
        if coupon.barcodeType == nil || coupon.barcodeType?.isEmpty == true {
            missingFields.append("Barcode type")
        }
        
        return missingFields
    }
}
class CouponParameterUpdater {
    
    static func merge(parameters: [[String: Any]], with requiredFields: [[String: Any]]) -> [[String: Any]] {
        var merged: [[String: Any]] = []
        
        // 🔹 Step 1: parameters ko base rakho, aur requiredFields se update karo
        for param in parameters {
            let key = param["key"] as! String
            if let match = requiredFields.first(where: { ($0["key"] as? String)?.lowercased() == key.lowercased() }) {
                // agar requiredFields me value hai to overwrite karo
                var updated = param
                for (k,v) in match { updated[k] = v }
                merged.append(updated)
            } else {
                // otherwise parameter ka default hi use karo
                merged.append(param)
            }
        }
        
        // 🔹 Step 2: agar requiredFields me extra keys hain jo parameters me nahi thi → unhe add kar do
        let parameterKeys = Set(parameters.compactMap { $0["key"] as? String }.map { $0.lowercased() })
        let extras = requiredFields.filter {
            if let key = $0["key"] as? String {
                return !parameterKeys.contains(key.lowercased())
            }
            return false
        }
        
        merged.append(contentsOf: extras)
        
        return merged
    }
}
