//
//  SessionManager.swift
//  Map
//
//  Created by Lorena Buzea on 29.04.2025.
//

import SwiftUI
import FirebaseAuth

class SessionManager: ObservableObject {
    @Published var isLoggedIn = false
    
    init(){
        isLoggedIn = Auth.auth().currentUser != nil
        Auth.auth().addStateDidChangeListener{_, user in
            self.isLoggedIn = user != nil}
    }
    
    func signOut(){
        try? Auth.auth().signOut()
        isLoggedIn = false
    }
}
