//
//  DetectWordApp.swift
//  DetectWord
//
//  Created by Confident Macbook on 2021/2/19.
//

import SwiftUI

@main
struct DetectWordApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
