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

    func filteredBooks() -> [Book] {
        return self.viewModel.books
            // Only show the ones that are filtered out by the search in the sidebar
            .filter { $0.title.lowercased().contains(self.searchText.lowercased()) || self.searchText.isEmpty }
            // And then sort them by modified at, descending.
            .sorted { $0.modifiedAt > $1.modifiedAt }
    }

    var body: some View {
        
        NavigationSplitView {
            List(filteredBooks(), id: \.self, selection: $selection) { book in
                BookListItemView(book: book)
            }
            .listStyle(.sidebar)
            .searchable(text: $searchText)
            
        } detail: {
            
            if viewModel.isLoading {
                LoadingView()
            } else {
                if let book = selection {
                    BookDetailsView(book: book, viewModel: viewModel)
                } else {
                    Text("Select a book")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    BooksListView(viewModel: ViewModel.mockViewModel)
}
