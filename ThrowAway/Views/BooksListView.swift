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
    @Environment(ViewModel.self) var viewModel
    
    @Query var books: [Book]
    
    @State var selection: Book? = nil
    @State var searchText: String = ""
    
    /// A helper function to filter out the list of books for the sidebar search results.
    private func filteredBooks() -> [Book] {
        return self.books
            .filter { $0.title.lowercased().contains(self.searchText.lowercased()) || self.searchText.isEmpty }
            .sorted { $0.modifiedAt > $1.modifiedAt }
    }
    
    @Sendable private func fetchBooks() async {
        await viewModel.withLoading {
            modelContext.autosaveEnabled = false
            let books = try await KindleAPI.shared.getBooks()
            for book in books {
                modelContext.insert(book)
            }
            try modelContext.save()
        }
    }
    
    var body: some View {
        NavigationSplitView {
            if viewModel.isLoading {
                LoadingView()
            }
            else {
                if books.isEmpty {
                    Text("No books with highlights in your collection")
                } else {
                    List(filteredBooks(), id: \.self, selection: $selection) { book in
                        BookListItemView(book: book)
                    }
                    .listStyle(.plain)
                    .searchable(text: $searchText)
                    .navigationTitle("Books")
                }
            }
        } detail: {
            if viewModel.isLoading {
                LoadingView()
            } else {
                if let book = selection {
                    BookDetailsView(book: book)
                }
            }
        }
        .task(fetchBooks)
    }
}

#Preview {
    let vm = ViewModel()
    return BooksListView()
        .environment(vm)
        .modelContainer(MockData.previewContainer)
}

#Preview {
    let vm = ViewModel()
    vm.isLoading = true
    return BooksListView()
        .environment(vm)
}
