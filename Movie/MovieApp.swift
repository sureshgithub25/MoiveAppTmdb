//
//  MovieApp.swift
//  Movie
//
//  Created by Suresh Kumar on 12/05/25.
//

import SwiftUI

@main
struct MovieApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
