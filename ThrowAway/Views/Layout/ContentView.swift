//
//  ContentView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/23/23.
//


import SwiftUI
import SwiftData

/// Main view of the app.
/// ContentView owns the view model, and routes the possible states of the view model between authenticated and non-authenticated state.
struct ContentView: View {
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.unauthenticated {
                // On a Mac, welcome screen goes into an overlay.
                // On iOS, just use the whole screen.
#if targetEnvironment(macCatalyst)
                EmptyView()
#else
                WelcomeView()
#endif
            } else {
                BooksListView(viewModel: viewModel)
            }

            if let error = viewModel.recentError {
                ErrorView(error: error)
            }
        }
//#if targetEnvironment(macCatalyst)
//        .sheet(isPresented: $viewModel.unauthenticated, content: {
//            WelcomeView()
//        })
//#endif
    }
}

#Preview {
    ContentView()
}
