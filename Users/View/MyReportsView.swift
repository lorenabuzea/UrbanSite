import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MyReportsView: View {
    @State private var reports: [ReportItem] = []
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                if isLoading {
                    ProgressView()
                        .padding()
                } else if reports.isEmpty {
                    Text("No reports found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(reports) { report in
                        VStack(alignment: .leading, spacing: 8) {
                            if let url = URL(string: report.imageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(height: 180)
                                            .frame(maxWidth: .infinity)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 180)
                                            .frame(maxWidth: .infinity)
                                            .clipped()
                                            .cornerRadius(10)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 180)
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }

                            Text(report.category)
                                .font(.headline)

                            Text("Status: \(report.status)")
                                .font(.subheadline)
                                .foregroundColor(.orange)

                            Text("Reported on \(formattedDate(report.date))")
                                .font(.caption)
                                .foregroundColor(.gray)

                            Divider()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("My Reports")
        .onAppear(perform: loadReports)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func loadReports() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("issues")
           // .whereField("reporterId", isEqualTo: uid)
            .order(by: "reportedAt", descending: true)
            .getDocuments { snapshot, error in
                isLoading = false
                guard let documents = snapshot?.documents else { return }
                self.reports = documents.compactMap { doc in
                    let data = doc.data()
                    guard let imageUrl = data["imageUrl"] as? String,
                          let category = data["category"] as? String,
                          let status = data["status"] as? String,
                          let timestamp = data["reportedAt"] as? Timestamp else { return nil }

                    return ReportItem(id: doc.documentID,
                                      imageUrl: imageUrl,
                                      category: category,
                                      status: status,
                                      date: timestamp.dateValue())
                }
            }
    }
}

struct ReportItem: Identifiable {
    let id: String
    let imageUrl: String
    let category: String
    let status: String
    let date: Date
}
