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

    // MARK: - Upload Image to Firebase Storage with Retry Logic
    func uploadImageToStorageWithInnvitation(image: UIImage, cardKey: String, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        self.testHTTPSConnection()

        // Convert to PNG data
        guard let imageData = image.pngData() else {
            completion(.failure(NSError(domain: "ImageError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Image conversion to PNG failed."])))
            return
        }

        let path = "UserCard/\(cardKey)/\(fileName).png"
        let ref = Storage.storage().reference().child(path)

        // Set metadata for PNG (optional but good practice)
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"

        ref.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
    
    
    // MARK: - Fetch Invitation Cards by Owner ID
    func fetchInvitationCardsByOwnerID(ownerId: String, completion: @escaping (Result<[InvitationModel], Error>) -> Void) {
        let ref = Database.database().reference().child("UserInvitationCard")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var matchedCards: [InvitationModel] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any],
                   let currentOwnerId = dict["ownerId"] as? String,
                   currentOwnerId == ownerId {
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: dict)
                        let card = try JSONDecoder().decode(InvitationModel.self, from: jsonData)
                        matchedCards.append(card)
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
            }
            
            completion(.success(matchedCards))
        }
    }
    
    
    // MARK: - Delete UserInvitation Card by cardKey and match ownerId
    
    func deletUserInvitationCard(ownerId: String, cardKey: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = Database.database().reference().child("UserInvitationCard").child(cardKey)

        // Step 1: Check if cardKey exists
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else {
                completion(.failure(NSError(domain: "Firebase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Card not found."])))
                return
            }

            // Step 2: Verify ownerId matches
            guard let value = snapshot.value as? [String: Any],
                  let fetchedOwnerId = value["ownerId"] as? String else {
                completion(.failure(NSError(domain: "Firebase", code: 422, userInfo: [NSLocalizedDescriptionKey: "Invalid card data."])))
                return
            }

            guard fetchedOwnerId == ownerId else {
                completion(.failure(NSError(domain: "Firebase", code: 403, userInfo: [NSLocalizedDescriptionKey: "Owner ID mismatch. Not authorized to delete."])))
                return
            }

            // Step 3: Delete card
            ref.removeValue { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    
    
}
