//
//  IssuesViewModel.swift
//  Map
//
//  Created by Lorena Buzea on 27.04.2025.
//


import FirebaseFirestore
import CoreLocation

class IssuesViewModel: ObservableObject {
    @Published var issues: [UrbanIssue] = []
    
    private var db = Firestore.firestore()
    
    init() {
        fetchIssues()
    }
    
    func fetchIssues() {
        db.collection("issues").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching issues: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            self.issues = documents.compactMap { doc -> UrbanIssue? in
                let data = doc.data()
                
                guard let imageUrl = data["imageUrl"] as? String,
                      let description = data["description"] as? String,
                      let category = data["category"] as? String,
                      let location = data["location"] as? GeoPoint else {
                          return nil
                      }
                
                return UrbanIssue(
                    id: doc.documentID,
                    imageUrl: imageUrl,
                    description: description,
                    category: category,
                    location: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                )
            }
        }
    }
}
