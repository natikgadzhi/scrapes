//
//  BookDetailsView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI

struct BookDetailsView: View {

    var book: Book

    @Bindable var viewModel: ViewModel

    var body: some View {
        ZStack {
            if !viewModel.highlights.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("You have \(viewModel.highlights.count) highlights")

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
                        ForEach(viewModel.highlights) { highlight in
                            Text(highlight.text)
                                .padding(.bottom, 10)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
                .padding()
            }

            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle(book.title)
        .onAppear {
            print("details scren on appear")
            self.viewModel.fetchHighlights(for: book)
        }
    }
}

#Preview {
    NavigationStack {
        BookDetailsView(book: Book.mockBooks[1], viewModel: ViewModel())
    }
}
