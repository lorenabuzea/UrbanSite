//
//  UrbanIssue.swift
//  Map
//
//  Created by Lorena Buzea on 27.04.2025.
//


import Foundation
import FirebaseFirestore
import CoreLocation

struct UrbanIssue: Identifiable {
    var id: String
    var imageUrl: String
    var description: String
    var category: String
    var location: CLLocationCoordinate2D
}
