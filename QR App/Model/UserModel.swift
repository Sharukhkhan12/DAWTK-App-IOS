//
//  UserModel.swift
//  QR App
//
//  Created by Touheed khan on 14/06/2025.
//

import Foundation
import UIKit

struct UserModel: Codable {
    var accountType: String
    var authId: String
    var authPass: String
    var authToken: String
    var countryCode: String
    var deleted: Bool
    var deviceName: String
    var email: String
    var fcmToken: String
    var firstName: String
    var lastName: String
    var phoneNo: String
    var profileUrl: String
    var userId: String

    // MARK: - Shared instance
    static var shared: UserModel? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "currentUser"),
                  let user = try? JSONDecoder().decode(UserModel.self, from: data) else {
                return nil
            }
            return user
        }
        set {
            if let newUser = newValue,
               let data = try? JSONEncoder().encode(newUser) {
                UserDefaults.standard.set(data, forKey: "currentUser")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentUser")
            }
        }
    }

    // MARK: - Convert to Dictionary
    func toDictionary() -> [String: Any] {
        return [
            "userId": userId,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phoneNo": phoneNo,
            "countryCode": countryCode,
            "profileUrl": profileUrl,
            "authId": authId,
            "authToken": authToken,
            "authPass": authPass,
            "deviceName": deviceName,
            "accountType": accountType,
            "fcmToken": fcmToken,
            "deleted": deleted
        ]
    }
}
