//
//  SignUp.swift
//  Map
//
//  Created by Lorena Buzea on 29.04.2025.
//

import FirebaseAuth
import FirebaseFirestore

func signUp( email: String, passwor: String, name: String, surname: String){
    Auth.auth().createUser(withEmail: email, password: passwor) { result, error in
        if let error = error{
            print("signup error: \(error.localizedDescription)")
            return
        }
        guard let uid = result?.user.uid else { return }
        
        let db = Firestore.firestore()
        db.collection( "users" ).document( uid ).setData([
            "name": name,
            "surname":surname,
            "email":email,
            "reportCount":0
        ]) {error in
            if let error = error{
                print("Firestore error: \(error.localizedDescription)")
            }
            else{
                print("User created succesfully")
            }
            
        }
    }
}
