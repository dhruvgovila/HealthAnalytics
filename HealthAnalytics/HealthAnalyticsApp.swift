//
//  HealthAnalyticsApp.swift
//  HealthAnalytics
//
//  Created by Govila, Dhruv on 25/09/2022.
//

import SwiftUI

@main
struct HealthAnalyticsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
