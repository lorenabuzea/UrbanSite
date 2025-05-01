//
//  LoginView.swift
//  Map
//
//  Created by Lorena Buzea on 29.04.2025.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var surname = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isSignUp ? "Sign Up" : "Login")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.orange)

            if isSignUp {
                TextField("Name", text: $name)
                TextField("Surname", text: $surname)
            }

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            SecureField("Password", text: $password)

            Button(action: {
                isSignUp ? handleSignUp() : handleLogin()
            }) {
                Text(isSignUp ? "Create Account" : "Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                isSignUp.toggle()
            }) {
                Text(isSignUp ? "Already have an account? Log in" : "Don't have an account? Sign up")
                    .font(.footnote)
                    .foregroundColor(.orange)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }

    func handleSignUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }

            guard let uid = result?.user.uid else { return }
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "name": name,
                "surname": surname,
                "email": email,
                "reportCount": 0
            ])
        }
    }

    func handleLogin() {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }
}
