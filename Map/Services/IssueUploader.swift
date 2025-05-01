//
//  IssueUploader.swift
//  Map
//
//  Created by Lorena Buzea on 26.04.2025.
//


import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreLocation
import FirebaseAuth

struct IssueUploader {
    
    static func uploadIssue(image: UIImage, 
                             description: String?, 
                             category: String, 
                             location: CLLocationCoordinate2D, 
                             completion: @escaping (Result<Void, Error>) -> Void) {
        
        // 1. Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not convert image to data."])))
            return
        }
        
        // 2. Create a unique storage path
        let filename = UUID().uuidString
        let storageRef = Storage.storage().reference().child("issues/\(filename).jpg")
        
        // 3. Upload the image
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 4. After upload, get download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.failure(NSError(domain: "URLError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve download URL."])))
                    return
                }
                
               
                
                // 5. Save issue info to Firestore
                let db = Firestore.firestore()
                let issuesRef = db.collection("issues")
                
                guard let currentUser = Auth.auth().currentUser else {
                    completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Could not get current user."])))
                    return
                }
                
                let issueData: [String: Any] = [
                    "imageUrl": downloadURL.absoluteString,
                    "description": description ?? "",
                    "category": category,
                    "location": GeoPoint(latitude: location.latitude, longitude: location.longitude),
                    "severityScore": 0, // You can add logic later
                    "status": "reported",
                    "reportedAt": Timestamp(date: Date()),
                    "assignedInstitution": "",
                    "reporterId": currentUser.uid
                ]
                
                issuesRef.addDocument(data: issueData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(())) //data was added succesfully
                        
                            //code to increment reportCount for user
                        let userRef = db.collection("users").document(currentUser.uid)
                                userRef.updateData([
                                    "reportCount": FieldValue.increment(Int64(1))
                                ]) { error in
                                    if let error = error {
                                        print("Failed to increment reportCount: \(error.localizedDescription)")
                                    } else {
                                        print("Successfully incremented reportCount")
                                    }
                                }
                    }
                }
            }
        }
    }
}
