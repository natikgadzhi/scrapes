//
//  ContentView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/23/23.
//

import SwiftUI
import SwiftData

/// Main view of the app.
/// ContentView owns the view model, and routes the possible states of the view
/// model between authenticated and non-authenticated state.
struct ContentView: View {
    
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        ZStack {
            if viewModel.unauthenticated {
                WelcomeView()
            } else {
                BooksListView()
            }

            if let error = viewModel.recentError {
                ErrorView(error: error)
            }
        }
    }
}

#Preview {
    ContentView()
}
