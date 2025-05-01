import SwiftUI
import MapKit

struct IssuesMapView: View {
    @StateObject private var viewModel = IssuesViewModel()
    @State private var selectedIssues: [UrbanIssue] = []
    @State private var isSheetPresented = false
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 46.7712, longitude: 23.6236),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    @State private var selectedIssue: UrbanIssue?
    @State private var showError = false
    @State private var errorMessage = ""

    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(viewModel.issues) { issue in
                Annotation(issue.id, coordinate: issue.location) {
                    Button(action: {
                        selectedIssues = viewModel.issues.filter { $0.location.latitude == issue.location.latitude && $0.location.longitude == issue.location.longitude }
                        isSheetPresented = true
                    }) {
                        VStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                            Text(issue.category)
                                .font(.caption2)
                                .padding(2)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(5)
                        }
                    }
                    
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            VStack {
                Text("Reported Issues")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(selectedIssues) { issue in
                            VStack(spacing: 10) {
                                AsyncImage(url: URL(string: issue.imageUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 200, height: 150)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 200, height: 150)
                                            .clipped()
                                            .cornerRadius(10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                Text(issue.category)
                                    .font(.headline)
                                
                                Text(issue.description)
                                    .font(.caption)
                                    .lineLimit(2)
                                    .padding(.horizontal, 5)
                            }
                            .frame(width: 220)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.vertical)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                Button("Close") {
                    isSheetPresented = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .presentationDetents([.fraction(0.4)]) //Only use 40% of screen height
        }
    }
}
