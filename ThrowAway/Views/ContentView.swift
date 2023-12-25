//
//  ContentView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/23/23.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isAuthenticated {
            BooksListView(viewModel: viewModel)
        } else {
            UnauthenticatedView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
