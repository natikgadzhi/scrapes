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
                viewModel.books.filter {
                    $0.title.lowercased().contains(self.searchText.lowercased()) || self.searchText.isEmpty
                },
                id: \.self, selection: $selection
            ) { book in

                // TODO: Extract into BooksListItem
                NavigationLink(value: book) {
                    VStack(alignment: .leading) {
                        Text(book.title)
                        Text(book.author)
                            .font(.caption)
                    }
                    .padding(.vertical, 4)

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

                if viewModel.isLoading {
                    LoadingView()
                }
            }
        }
    }
}

#Preview {
    BooksListView(viewModel: ViewModel.mockViewModel)
}
