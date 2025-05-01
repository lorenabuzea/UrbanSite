//
//  LogIn.swift
//  Map
//
//  Created by Lorena Buzea on 29.04.2025.
//

import FirebaseAuth
import FirebaseFirestore

func logIn( email: String, password: String){
    Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            return
        }
        print("Logged in!")
    }
}
