//
//  notetakingApp.swift
//  notetaking
//
//  Created by Nikolai Schlegel on 10/25/23.
//

import SwiftUI

@main
struct notetakingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
