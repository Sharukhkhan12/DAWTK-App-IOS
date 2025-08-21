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
    
    
    // MARK: - Fetch Card by Key
    func fetchCard(cardKey: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let rootRef = Database.database().reference()
        
        // 🔹 Step 1: Check in UserBusinessCard
        let businessRef = rootRef.child("UserBusinessCard")
        businessRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                print("🔍 Checking in UserBusinessCard...")
                for userChild in snapshot.children.allObjects as! [DataSnapshot] {
                    print("👤 User Node: \(userChild.key)")
                    
                    if userChild.key == cardKey {
                        print("✅ Match found in UserBusinessCard → \(userChild.key) == \(cardKey)")
                        
                        if let dict = userChild.value as? [String: Any] {
                            do {
                                let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                
                                // ✅ Extra fields automatically ignore ho jati hain
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase // optional agar snake_case keys aati hain
                                let model = try decoder.decode(UserBusinessCardModel.self, from: data)
                                
                                completion(.success(model)) // ✅ return UserBusinessCardModel
                                
                                // 🔹 Step 2: Add "Scanned" field under this card
                                let scannedRef = businessRef.child(cardKey).child("Scanned").child(model.ownerId)

                                // Format current date as "YYYYMMDD HH:mm:ss"
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyyMMdd HH:mm:ss"
                                let currentDateStr = formatter.string(from: Date())

                                let scannedData: [String: Any] = [
                                    "ownerId": model.ownerId,
                                    "createdAt": currentDateStr
                                ]

                                scannedRef.setValue(scannedData) { error, _ in
                                    if let error = error {
                                        print("⚠️ Failed to mark as scanned: \(error.localizedDescription)")
                                    } else {
                                        print("✅ Card marked as Scanned successfully at \(currentDateStr)!")
                                    }
                                }
                                
                                return
                            } catch {
                                print("⚠️ Decode error: \(error.localizedDescription)")
                                completion(.failure(error))
                                return
                            }
                        }
                    }

                }
            }
            
            // 🔹 Step 2: Check in UserInvitationCard if not found
            let invitationRef = rootRef.child("UserInvitationCard")
            invitationRef.observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    print("🔍 Checking in UserInvitationCard...")
                    for userChild in snapshot.children.allObjects as! [DataSnapshot] {
                        print("👤 User Node: \(userChild.key)")
                        
                        if userChild.key == cardKey {
                            print("✅ Match found in UserInvitationCard → \(userChild.key) == \(cardKey)")
                            
                            if let dict = userChild.value as? [String: Any] {
                                do {
                                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                                    let model = try JSONDecoder().decode(InvitationModel.self, from: data)
                                    completion(.success(model)) // ✅ return InvitationModel
                                    
                                    let scannedRef = businessRef.child(cardKey).child("Scanned").child(model.ownerId)

                                    // Format current date as "YYYYMMDD HH:mm:ss"
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyyMMdd HH:mm:ss"
                                    let currentDateStr = formatter.string(from: Date())

                                    let scannedData: [String: Any] = [
                                        "ownerId": model.ownerId,
                                        "createdAt": currentDateStr
                                    ]

                                    scannedRef.setValue(scannedData) { error, _ in
                                        if let error = error {
                                            print("⚠️ Failed to mark as scanned: \(error.localizedDescription)")
                                        } else {
                                            print("✅ Card marked as Scanned successfully at \(currentDateStr)!")
                                        }
                                    }
                                    
                                    
                                    return
                                } catch {
                                    completion(.failure(error))
                                    return
                                }
                            }
                        }
                    }
                }
                
                // 🔹 Step 3: If not found anywhere
                print("❌ Card key \(cardKey) not found in any node.")
                let err = NSError(domain: "Firebase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid QR: Card not found"])
                completion(.failure(err))
            }
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
    
    /// Check how many times an ownerId exists in both UserBusinessCard and UserInvitationCard
       func checkOwnerIdOccurrences(ownerId: String, completion: @escaping (Result<[String: Int], Error>) -> Void) {
           let dbRef = Database.database().reference()
           
           // References for both parents
           let businessRef = dbRef.child("UserBusinessCard")
           let invitationRef = dbRef.child("UserInvitationCard")
           
           var results: [String: Int] = [
               "UserBusinessCard": 0,
               "UserInvitationCard": 0
           ]
           
           let dispatchGroup = DispatchGroup()
           var caughtError: Error?
           
           // Check UserBusinessCard
           dispatchGroup.enter()
           businessRef.observeSingleEvent(of: .value) { snapshot in
               if snapshot.exists() {
                   for child in snapshot.children {
                       if let snap = child as? DataSnapshot,
                          let dict = snap.value as? [String: Any],
                          let currentOwnerId = dict["ownerId"] as? String,
                          currentOwnerId == ownerId {
                           results["UserBusinessCard", default: 0] += 1
                       }
                   }
               }
               dispatchGroup.leave()
           } withCancel: { error in
               caughtError = error
               dispatchGroup.leave()
           }
           
           // Check UserInvitationCard
           dispatchGroup.enter()
           invitationRef.observeSingleEvent(of: .value) { snapshot in
               if snapshot.exists() {
                   for child in snapshot.children {
                       if let snap = child as? DataSnapshot,
                          let dict = snap.value as? [String: Any],
                          let currentOwnerId = dict["ownerId"] as? String,
                          currentOwnerId == ownerId {
                           results["UserInvitationCard", default: 0] += 1
                       }
                   }
               }
               dispatchGroup.leave()
           } withCancel: { error in
               caughtError = error
               dispatchGroup.leave()
           }
           
           // When both checks are done
           dispatchGroup.notify(queue: .main) {
               if let error = caughtError {
                   completion(.failure(error))
               } else {
                   completion(.success(results))
               }
           }
       }
    func checkOwnerIdInAcceptedAndScanned(ownerId: String, completion: @escaping (Int, Int) -> Void) {
        let parentNodes = ["UserInvitationCard", "UserBusinessCard"]
        let db = Database.database().reference()
        
        var acceptedCount = 0
        var scannedCount = 0
        let group = DispatchGroup()
        
        for parent in parentNodes {
            group.enter()
            db.child(parent).observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                    // Each INV_* or BUS_* node
                    let node = child
                    
                    // ✅ First check ownerId of this parent node
                    if let dict = node.value as? [String: Any],
                       let invOwnerId = dict["ownerId"] as? String,
                       invOwnerId == ownerId {
                        
                        // ✅ Count Accepted
                        if node.hasChild("Accepted") {
                            let acceptedNode = node.childSnapshot(forPath: "Accepted")
                            acceptedCount += Int(acceptedNode.childrenCount)
                        }
                        
                        // ✅ Count Scanned
                        if node.hasChild("Scanned") {
                            let scannedNode = node.childSnapshot(forPath: "Scanned")
                            scannedCount += Int(scannedNode.childrenCount)
                        }
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(acceptedCount, scannedCount)
        }
    }

    func checkPendingStatus(completion: @escaping (Int) -> Void) {
        let parentNodes = ["UserInvitationCard", "UserBusinessCard"]
        let db = Database.database().reference()
        
        var pendingCount = 0
        let group = DispatchGroup()
        
        for parent in parentNodes {
            group.enter()
            db.child(parent).observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                    let node = child
                    
                    // ✅ If node has no "Accepted", then it's pending
                    if !node.hasChild("Accepted") {
                        pendingCount += 1
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(pendingCount)
        }
    }

    func addStatusToCard(cardKey: String, ownerId: String, status: String) {
        let rootRef = Database.database().reference()
        let statusRef = rootRef.child("UserBusinessCard").child(cardKey).child(status).child(ownerId)
        
        // Format current date as "YYYYMMDD HH:mm:ss"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HH:mm:ss"
        let currentDateStr = formatter.string(from: Date())
        
        let statusData: [String: Any] = [
            "ownerId": ownerId,
            "createdAt": currentDateStr
        ]
        
        statusRef.setValue(statusData) { error, _ in
            if let error = error {
                print("⚠️ Failed to add \(status) for ownerId \(ownerId): \(error.localizedDescription)")
            } else {
                print("✅ \(status) added successfully for ownerId \(ownerId) at \(currentDateStr)")
            }
        }
    }
    
    
    func addStatusToInvitationCard(cardKey: String, ownerId: String, status: String) {
        let rootRef = Database.database().reference()
        let statusRef = rootRef.child("UserInvitationCard").child(cardKey).child(status).child(ownerId)
        
        // Format current date as "YYYYMMDD HH:mm:ss"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HH:mm:ss"
        let currentDateStr = formatter.string(from: Date())
        
        let statusData: [String: Any] = [
            "ownerId": ownerId,
            "createdAt": currentDateStr
        ]
        
        statusRef.setValue(statusData) { error, _ in
            if let error = error {
                print("⚠️ Failed to add \(status) for ownerId \(ownerId) in InvitationCard: \(error.localizedDescription)")
            } else {
                print("✅ \(status) added successfully for ownerId \(ownerId) in InvitationCard at \(currentDateStr)")
            }
        }
    }
    
    

    
    
}
//func fetchCard(cardKey: String, completion: @escaping (Result<Any, Error>) -> Void) {
//    let ref = Database.database().reference()
//    
//    // 🔹 First check UserBusinessCard
//    let businessRef = ref.child("UserBusinessCard").child(cardKey)
//    businessRef.observeSingleEvent(of: .value) { snapshot in
//        if snapshot.exists(), let dict = snapshot.value as? [String: Any] {
//            do {
//                let data = try JSONSerialization.data(withJSONObject: dict, options: [])
//                let model = try JSONDecoder().decode(UserBusinessCardModel.self, from: data)
//                completion(.success(model))
//                return
//            } catch {
//                completion(.failure(error))
//                return
//            }
//        }
//        
//        // 🔹 If not found, check UserInvitationCard
//        let invitationRef = ref.child("UserInvitationCard").child(cardKey)
//        invitationRef.observeSingleEvent(of: .value) { snapshot in
//            if snapshot.exists(), let dict = snapshot.value as? [String: Any] {
//                do {
//                    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
//                    let model = try JSONDecoder().decode(InvitationModel.self, from: data)
//                    completion(.success(model))
//                    return
//                } catch {
//                    completion(.failure(error))
//                    return
//                }
//            }
//            
//            // 🔹 If not found in either node
//            let err = NSError(domain: "Firebase", code: 404, userInfo: [NSLocalizedDescriptionKey: "Card not found in UserBusinessCard or UserInvitationCard."])
//            completion(.failure(err))
//        }
//    }
//}
