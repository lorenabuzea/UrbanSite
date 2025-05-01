//
//  EditCredentialsView.swift
//  Map
//
//  Created by Lorena Buzea on 29.04.2025.
//


import SwiftUI
import FirebaseAuth

struct EditCredentialsView: View {
    @State private var newPassword = ""
    @State private var updateMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            SecureField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Update Password") {
                updatePassword()
            }
            .accountButtonStyle()

            Text(updateMessage)
                .font(.caption)
                .foregroundColor(.green)
        }
        .navigationTitle("Update Credentials")
        .padding()
    }

    func updatePassword() {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                updateMessage = "Error: \(error.localizedDescription)"
            } else {
                updateMessage = "Password updated successfully!"
            }
        }
    }
}
