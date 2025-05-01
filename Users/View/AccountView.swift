//
//  AccountView.swift
//  Map
//
//  Created by Lorena Buzea on 29.04.2025.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AccountView: View {
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @EnvironmentObject var session: SessionManager
    @State private var reportCount = 0
    @State private var isLoading = true
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView()
                } else {
                    VStack(spacing: 10) {
                        Text("\(name) \(surname)")
                            .font(.title2)
                            .bold()
                        
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Reports submitted: \(reportCount)")
                            .font(.subheadline)
                            .padding(.top, 5)
                    }

                    NavigationLink(destination: EditCredentialsView()) {
                        Text("Update Credentials")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: MyReportsView()) {
                        Text("View My Reports")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                   

                    Button(action: {
                        session.signOut()
                    }) {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
            }
            .padding()
            .navigationTitle("Account")
            .onAppear(perform: fetchUserData)
        }
    }

    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection("users").document(uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                name = document.get("name") as? String ?? ""
                surname = document.get("surname") as? String ?? ""
                email = document.get("email") as? String ?? ""
                reportCount = document.get("reportCount") as? Int ?? 0
            } else {
                errorMessage = "Failed to load user data"
            }
            isLoading = false
        }
    }
}

extension View {
    func accountButtonStyle() -> some View {
        self.frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
