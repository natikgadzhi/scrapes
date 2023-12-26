//
//  BookDetailsView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI

struct BookDetailsView: View {
    
    var book: Book

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
        }
        .navigationTitle(book.title)
    }
}

#Preview {
    NavigationStack {
        BookDetailsView(book: Book.mockBooks[1])
    }
}
