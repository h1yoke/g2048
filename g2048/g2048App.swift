//
//  g2048App.swift
//  g2048
//
//  Created by Dmitry Protsenko on 05.04.2024.
//

import SwiftUI

@main
struct g2048App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
