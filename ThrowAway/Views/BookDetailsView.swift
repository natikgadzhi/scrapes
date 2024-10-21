//
//  BookDetailsView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct BookDetailsView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) var viewModel
    @State private var isLoading = false
    
    var book: Book
    
    var body: some View {
        ZStack {
            if !book.highlights.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("You have \(book.highlights.count) highlights")
                        Spacer()
                        Button(action: {
                            copyAllHighlights()
                        }, label: {
                            Label("Copy All", systemImage: "doc.on.doc")
                        })
                        .padding(.horizontal)
                        .buttonStyle(.borderedProminent)
                    }
                    
                    List {
                        ForEach(book.highlights) { highlight in
                            HighlightRowView(highlight: highlight)
                        }
                    }
                    .listStyle(.plain)
                }
                .padding()
            }
            
            if isLoading {
                LoadingView()
            }
        }
        .navigationTitle(book.title)
        .task(id: book) {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let highlights = try await KindleAPI.shared.getHighlights(for: book)
                
                await MainActor.run {
                    for highlight in highlights {
                        if book.highlights.contains(where: { $0.id == highlight.id }) {
                            print("Skipping updating a highlight \(highlight.id) as it already exists")
                            continue
                        } else {
                            book.highlights.append(highlight)
                        }
                    }
                }
                
                try modelContext.save()
            } catch {
                viewModel.recentError = error
            }
        }
    }
    
    private func copyAllHighlights() {
        let markdownHighlights = book.highlights.map { "- \($0.highlightText) (Page: \($0.page))" }.joined(separator: "\n")
        UIPasteboard.general.setValue(markdownHighlights, forPasteboardType: UTType.plainText.identifier)
        // Consider adding a visual feedback here
    }
}


#Preview {
    NavigationStack {
        BookDetailsView(book: MockData.books.first!)
            .environment(ViewModel())
    }
}
