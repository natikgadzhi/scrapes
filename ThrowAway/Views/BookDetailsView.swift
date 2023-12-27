//
//  BookDetailsView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI
import SwiftData

struct BookDetailsView: View {
    
    @Environment(\.modelContext) var modelContext
    
    var book: Book
    
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            if !book.highlights.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("You have \(book.highlights.count) highlights")

                        Spacer()

                        Button(action: {
                            print("copy")
                        }, label: {
                            Label("Copy Everything", systemImage: "square.and.arrow.up.on.square")
                        })
                        .padding(.horizontal)
                        .buttonStyle(.borderedProminent)
                    }

                    List {
                        ForEach(book.highlights) { highlight in
                            Text(highlight.text)
                                .padding(.bottom, 10)
                                .listRowSeparator(.hidden)
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
        .task(id: book) {
            self.isLoading = true
            
            do {
                book.highlights = try await KindleAPI.shared.getHighlights(for: book)
            } catch {
                print(error)
            }
            
            do {
                try modelContext.save()
            } catch {
                print(error)
            }
            
            self.isLoading = false
        }
        .navigationTitle(book.title)
    }
}

#Preview {
    NavigationStack {
        BookDetailsView(book: MockData.books[1])
    }
}
