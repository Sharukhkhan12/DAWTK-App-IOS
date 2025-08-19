//
//  FirebaseManager+Extension.swift
//  QR App
//
//  Created by MacBook Air on 31/07/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import FirebaseCore
// Optional alias if you want a semantic method name
extension FirebaseManager {
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        signOut(completion: completion)
    }
    
    // MARK: - Delete user data from Realtime Database by ownerId (UID)
    func deleteUserData(ownerId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = Database.database().reference().child("Users").child(ownerId)

        // Check if user node exists first (optional but safer)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                completion(.failure(NSError(domain: "Firebase", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found in Realtime Database."])))
                return
            }

            // Remove the user node
            ref.removeValue { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }

    
    func loginAndLoadUser(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        loginUser(email: email, password: password) { result in
            switch result {
            case .success(let authResult):
                let uid = authResult.user.uid
                self.fetchUserModel(uid: uid) { fetchResult in
                    switch fetchResult {
                    case .success(let userModel):
                        // Persist shared
                        UserModel.shared = userModel
                        completion(.success(userModel))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Fetches the user data from Realtime Database and decodes into UserModel.
    func fetchUserModel(uid: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let ref = Database.database().reference().child("Users").child(uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(),
                  let dict = snapshot.value as? [String: Any] else {
                let err = NSError(domain: "Firebase", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found."])
                completion(.failure(err))
                return
            }

            do {
                // Convert dictionary to JSON Data then decode
                let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                let user = try JSONDecoder().decode(UserModel.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }
    
    
    func fetchUserBusinessCard(cardKey: String, completion: @escaping (Result<UserBusinessCardModel, Error>) -> Void) {
        let ref = Database.database().reference().child("UserBusinessCard").child(cardKey)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(),
                  let dict = snapshot.value as? [String: Any] else {
                let err = NSError(domain: "Firebase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Business card not found."])
                completion(.failure(err))
                return
            }

            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                let model = try JSONDecoder().decode(UserBusinessCardModel.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }

    
    // MARK: - Save User Invitation Card
    func saveUserInvitationCard(card: InvitationModel, completion: @escaping (Result<String, Error>) -> Void) {
        // Generate Firebase auto ID
        let autoId = Database.database().reference().child("UserInvitationCard").childByAutoId().key ?? UUID().uuidString
        let cardKey = "INV_\(autoId)" // prepend INV_

        let ref = Database.database().reference().child("UserInvitationCard").child(cardKey)

        var updatedCard = card
        updatedCard.ownerId = cardKey

        ref.setValue(updatedCard.toDictionary()) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(cardKey))
            }
        }
    }


    
    
    
}
