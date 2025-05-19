//
//  MovieApp.swift
//  Movie
//
//  Created by Suresh Kumar on 12/05/25.
//

import SwiftUI

@main
struct MovieApp: App {

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    
    var body: some View {
        TabView {
            HomeListView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

