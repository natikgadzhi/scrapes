//
//  BookListItemView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/25/23.
//

import SwiftUI

struct BookListItemView: View {
    
    var book: Book
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    var body: some View {
        
        NavigationLink(value: book) {
            HStack {
                if let coverURL = book.coverImageURL {
                    AsyncImage(url: coverURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 60)
                    } placeholder: {
                        LoadingView()
                    }
                } else {
                    Image(systemName: "book.closed")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 60)
                }
                VStack(alignment: .leading) {
                    
                    Text(book.title)
                    
                    Text(book.author)
                        .font(.caption)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text("\(book.modifiedAt, formatter: dateFormatter)")
                            .font(.caption2)
                    }
                    .padding(.bottom, 2)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookListItemView(book: MockData.books.first!)
    }
}
