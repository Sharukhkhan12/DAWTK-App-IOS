//
//  FirebaseManager.swift
//  QR App
//
//  Created by Touheed khan on 02/06/2025.
//


//
//  FirebaseManager.swift
//  QR App
//
//  Created by Touheed khan on 02/06/2025.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import FirebaseCore

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    
    private init() {
           // Ensure Firebase is configured once
           if FirebaseApp.app() == nil {
               FirebaseApp.configure()
               print("✅ Firebase configured")
           }
       }
    
    func sendOTP(to phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                completion(.failure(error))
            } else if let verificationID = verificationID {
                completion(.success(verificationID))
            } else {
                // Handle rare unexpected nil
                completion(.failure(NSError(domain: "com.yourapp.firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."])))
            }
        }
    }


       // MARK: - Phone Auth: Verify OTP
       func verifyOTP(verificationID: String, verificationCode: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
           let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
           
           Auth.auth().signIn(with: credential) { authResult, error in
               if let error = error {
                   completion(.failure(error))
               } else if let authResult = authResult {
                   completion(.success(authResult))
               }
           }
       }
    
    
    // MARK: - Save User BusinessCard
    func saveUserBusinessCard(card: UserBusinessCardModel, completion: @escaping (Result<String, Error>) -> Void) {
        let ref = Database.database().reference().child("UserBusinessCard").childByAutoId()
        let cardKey = ref.key ?? UUID().uuidString // fallback in case of nil

        var updatedCard = card
        updatedCard.ownerId = cardKey // optional if you want to store the key inside

        ref.setValue(updatedCard.toDictionary()) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(cardKey))
            }
        }
    }
   
    // MARK: - Delete UserBusinessCard by cardKey and match ownerId
    
    func deleteUserBusinessCard(ownerId: String, cardKey: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = Database.database().reference().child("UserBusinessCard").child(cardKey)

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

    
    
    // MARK: - Save UserModel using auto-generated Firebase key
    func saveUserModelUnderAuthUID(user: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Firebase", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
            return
        }

        
        
        let ref = Database.database().reference().child("Users").child(uid)
        ref.setValue(user.toDictionary()) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }


    

    // MARK: - Login
    
    
    
    
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result))
            }
        }
    }
    
    

    // MARK: - Sign Up
    func signUpUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result))
            }
        }
    }

    // MARK: - Send Verification Email
    func sendVerificationEmail(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return completion(.failure(NSError(domain: "Firebase", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user."])))
        }

        user.sendEmailVerification { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Upload Image to Firebase Storage with Retry Logic
    func uploadImageToStorage(image: UIImage, cardKey: String, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
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



         func testHTTPSConnection() {
            guard let testURL = URL(string: "https://firebasestorage.googleapis.com") else { return }

            URLSession.shared.dataTask(with: testURL) { _, response, error in
                if let error = error {
                    print("🔥 HTTPS test failed: \(error.localizedDescription)")
                } else {
                    print("🌐 HTTPS test succeeded: \(response?.url?.host ?? "Unknown host")")
                }
            }.resume()
        }
    
   

    
   


    // MARK: - Check Email Verification
    func checkEmailVerified(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return completion(.failure(NSError(domain: "Firebase", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user logged in."])))
        }

        user.reload { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user.isEmailVerified))
            }
        }
    }


    // MARK: - Mark as Verified
    func markUserAsVerified(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(uid)
        userRef.updateData(["isEmailVerified": true]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Sign Out
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    
    // MARK: - Fetch Business Cards by Owner ID
    func fetchBusinessCardsByOwnerID(ownerId: String, completion: @escaping (Result<[UserBusinessCardModel], Error>) -> Void) {
        let ref = Database.database().reference().child("UserBusinessCard")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var matchedCards: [UserBusinessCardModel] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any],
                   let currentOwnerId = dict["ownerId"] as? String,
                   currentOwnerId == ownerId {
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: dict)
                        let card = try JSONDecoder().decode(UserBusinessCardModel.self, from: jsonData)
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
    
    // MARK: - Update UserBusinessCard by qrCode
    func updateUserBusinessCard(byQRCode qrCode: String, updatedCard: UserBusinessCardModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = Database.database().reference().child("UserBusinessCard")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any],
                   let existingQRCode = dict["qrCode"] as? String,
                   existingQRCode == qrCode {
                    
                    let cardRef = ref.child(snap.key) // path to the matching card
                    cardRef.setValue(updatedCard.toDictionary()) { error, _ in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                    return
                }
            }
            
            // No match found
            completion(.failure(NSError(domain: "Firebase", code: 404, userInfo: [NSLocalizedDescriptionKey: "No card found with matching QR code."])))
        }
    }
}



