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
    
    var book: Book
    
    @State private var isLoading = false
    @State private var copiedHighlightId: String? = nil

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
        .task(id: book) {
            self.isLoading = true
            defer {
                self.isLoading = false
            }
            
            do {
                let highlights = try await KindleAPI.shared.getHighlights(for: book)
                
                for highlight in highlights {
                    if book.highlights.contains(where: { $0.id == highlight.id }) {
                        
                        // This skips updating highlights that already exists
                        // TODO: We should update existing highlights when they are re-fetched. One way to
                        //       do that would be to remove them and re-insert.
                        print("Skipping updating a highlight \(highlight.id) as it already exists")
                        continue
                    } else {
                        book.highlights.append(highlight)
                    }
                }
                
                try modelContext.save()
            } catch {
                print(error)
            }
        }
        .navigationTitle(book.title)
    }

    private func copyAllHighlights() {
        let markdownHighlights = book.highlights.map { "- \($0.highlightText) (Page: \($0.page))" }.joined(separator: "\n")
        UIPasteboard.general.setValue(markdownHighlights, forPasteboardType: UTType.plainText.identifier)
        // Consider adding a visual feedback here
    }
}



#Preview {
    NavigationStack {
        BookDetailsView(book: MockData.bookWithHighlights)
    }
}


//import SwiftUI
//import SwiftData
//
//struct BookDetailsView: View {
//    
//    @Environment(\.modelContext) var modelContext
//    
//    var book: Book
//    
//    @State var isLoading = false
//    
//    var body: some View {
//        ZStack {
//            if !book.highlights.isEmpty {
//                VStack(alignment: .leading) {
//                    HStack {
//                        Text("You have \(book.highlights.count) highlights")
//
//                        Spacer()
//
//                        Button(action: {
//                            print("copy")
//                        }, label: {
//                            Label("Copy Everything", systemImage: "square.and.arrow.up.on.square")
//                        })
//                        .padding(.horizontal)
//                        .buttonStyle(.borderedProminent)
//                    }
//
//                    List {
//                        ForEach(book.highlights) { highlight in
//                            VStack {
//                                Text(highlight.text)
//                                    .padding(.bottom, 10)
//                                    .listRowSeparator(.hidden)
//                                Text(highlight.color)
//                                Text("\(highlight.page)")
//                                Text("\(highlight.position)")
//                            }
//                            
//                        }
//                    }
//                    .listStyle(.plain)
//                }
//                .padding()
//            }
//            
//            if isLoading {
//                LoadingView()
//            }
//        }
//        .task(id: book) {
//            self.isLoading = true
//            
//            do {
//                book.highlights = try await KindleAPI.shared.getHighlights(for: book)
//            } catch {
//                print(error)
//            }
//            
//            do {
//                try modelContext.save()
//            } catch {
//                print(error)
//            }
//            
//            self.isLoading = false
//        }
//        .navigationTitle(book.title)
//    }
//}
//
//#Preview {
//    NavigationStack {
//        BookDetailsView(book: MockData.books[1])
//    }
//}
