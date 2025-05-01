//
//  UploadIssueView.swift
//  Map
//
//  Created by Lorena Buzea on 26.04.2025.
//


import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreLocation
import MapKit

struct UploadIssueView: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State private var descriptionText = ""
    @State private var selectedCategory = "Drumuri"
    @State private var isUploading = false
    @State private var uploadStatus: String?
    @StateObject private var locationManager = LocationManager()
    @State private var showError = false
    @State private var errorMessage = ""

    
    let categories = ["Drumuri", "Salubritate", "Mediu", "Transport public", "Accesibilitate"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Selected image preview
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(12)
                } else {
                    Button(action: {
                        isPickerPresented = true
                    }) {
                        VStack {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 60))
                                .padding(.bottom, 8)
                            Text("Select Image")
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                    }
                }
                
                // Textfield for description
                TextField("Enter description (optional)", text: $descriptionText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Picker for category
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Upload Button
                Button(action: uploadIssue) {
                    if isUploading {
                        ProgressView()
                    } else {
                        Text("Upload Issue")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(selectedImage == nil || isUploading)
                .padding(.horizontal)
                
                // Status message
                if let status = uploadStatus {
                    Text(status)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
            }
            .sheet(isPresented: $isPickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .navigationTitle("Report Issue")
        }
    }
    
    private func uploadIssue() {
        guard let image = selectedImage else { return }
        guard let userLocation = locationManager.location else {
                self.errorMessage = "Failed to get your location."
                self.showError = true
                return
            }
        
        isUploading = true
        uploadStatus = nil
        
        IssueUploader.uploadIssue(image: image, 
                                  description: descriptionText,
                                  category: selectedCategory,
                                  location: userLocation) { result in
            DispatchQueue.main.async {
                isUploading = false
                switch result {
                case .success():
                    uploadStatus = "Issue uploaded successfully!"
                    selectedImage = nil
                    descriptionText = ""
                case .failure(let error):
                    uploadStatus = "Failed to upload: \(error.localizedDescription)"
                }
            }
        }
    }
}
