//
//  BooksListView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI
import SwiftData

struct BooksListView: View {
    
    @Environment(\.modelContext) var modelContext
    var viewModel: ViewModel
    
    @Query var books: [Book]
    
    @State var selection: Book? = nil
    @State var searchText: String = ""
    
    /// A helper function to filter out the list of books for the sidebar search results.
    private func filteredBooks() -> [Book] {
        return self.books
            // Only show the ones that are filtered out by the search in the sidebar
            .filter { $0.title.lowercased().contains(self.searchText.lowercased()) || self.searchText.isEmpty }
            // And then sort them by modified at, descending.
            .sorted { $0.modifiedAt > $1.modifiedAt }
    }
    
    /// `fetchBooks` is called when this view apperas, and it loads the books from the API and into the model context.
    private func fetchBooks() {
        Task {
            // FIXME: This feels slow. I think it's saving every record separately. Wrap them in a single transaction?
            viewModel.withLoading {
                let books = try await KindleAPI.shared.getBooks()
                for book in books {
                    modelContext.insert(book)
                }
                
                try modelContext.save()
            }
        }
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
                    BookDetailsView(book: book)
                } else {
                    Text("Select a book")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onAppear(perform: fetchBooks)
    }
}

#Preview {
    BooksListView(viewModel: ViewModel())
}
