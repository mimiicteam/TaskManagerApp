//
//  TaskManagerAppUIApp.swift
//  TaskManagerAppUI
//
//  Created by NGUYEN MINH DUC on 06/06/2022.
//

import SwiftUI

@main
struct TaskManagerAppUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

