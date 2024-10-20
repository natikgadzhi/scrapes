//
//  ThrowAwayApp.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/23/23.
//

import SwiftUI
import SwiftData

@main
struct ThrowAwayApp: App {
    
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
        .modelContainer(for: Book.self, inMemory: true)
    }
}
