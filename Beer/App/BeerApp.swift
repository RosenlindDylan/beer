//
//  BeerApp.swift
//  Beer
//
//  Created by Travis Hand on 11/8/25.
//

import SwiftUI
import SwiftData

@main
struct BeerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BeerItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
