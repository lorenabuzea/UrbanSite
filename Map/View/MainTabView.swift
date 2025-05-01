//
//  MainTabView.swift
//  Map
//
//  Created by Lorena Buzea on 27.04.2025.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            IssuesMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            UploadIssueView()
                .tabItem {
                    Label("Report", systemImage: "camera")
                }
            AccountView()
                .tabItem {
                Label("Account", systemImage: "person.circle")
                            }
        }
    }
}
