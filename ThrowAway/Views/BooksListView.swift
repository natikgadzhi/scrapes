//
//  BooksListView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI

struct BooksListView: View {
    
    var viewModel: ViewModel
    
    @State var selection: Book? = nil
    @State var searchText: String = ""
    
    var body: some View {
        NavigationSplitView {
            List(
                viewModel.books.filter { $0.title.lowercased().contains(self.searchText.lowercased()) || self.searchText.isEmpty },
                id: \.self, selection: $selection
            ) { book in
                NavigationLink(value: book) {
                    Text(book.title)
                        
                }
            }
            .listStyle(.sidebar)
            .searchable(text: $searchText)
        } detail: {
            if let book = selection {
                BookDetailsView(book: book)
            } else {
                Text("Select a book")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    BooksListView(viewModel: ViewModel.mock)
}
