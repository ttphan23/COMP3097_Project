//
//  EducationAppApp.swift
//  EducationApp
//
//  Created by Thinh Phan on 2026-01-28.
//

import SwiftUI

@main
struct EducationApp: App {
    @StateObject private var persistenceManager = DataPersistenceManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(persistenceManager.appData.preferences.darkModeEnabled ? .dark : .light)
        }
    }
}
