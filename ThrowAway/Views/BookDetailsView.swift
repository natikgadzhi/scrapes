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
                            HighlightRow(highlight: highlight, copiedHighlightId: $copiedHighlightId)
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
                try modelContext.save()
            } catch {
                print(error)
            }
            self.isLoading = false
        }
        .navigationTitle(book.title)
    }

    private func copyAllHighlights() {
        let markdownHighlights = book.highlights.map { "- \($0.highlightText) (Page: \($0.page))" }.joined(separator: "\n")
        UIPasteboard.general.setValue(markdownHighlights, forPasteboardType: UTType.plainText.identifier)
        // Consider adding a visual feedback here
    }
}

struct HighlightRow: View {
    let highlight: Highlight
    @Binding var copiedHighlightId: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text(highlight.highlightText)
                .font(.system(size: 16, weight: .regular, design: .serif ))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(self.highlight.color.color)
                        .stroke(self.highlight.color.color, lineWidth: 1)
                )
            Text("Page: \(highlight.page), Position: \(highlight.position)")
                .font(.caption)
            
            Button("Copy") {
                UIPasteboard.general.setValue(highlight.highlightText, forPasteboardType: UTType.plainText.identifier)
                copiedHighlightId = highlight.id
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if copiedHighlightId == highlight.id {
                        copiedHighlightId = nil
                    }
                }
            }
            .buttonStyle(.bordered)
            .padding(.top, 4)

            if copiedHighlightId == highlight.id {
                Text("Copied!")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 8)
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
