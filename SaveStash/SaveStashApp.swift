//
//  SaveStashApp.swift
//  SaveStash
//
//  Created by Quentin Gaillardet on 04/11/2023.
//

import SwiftUI
import SwiftData

@main
struct SaveStashApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Task.self)
    }
}
