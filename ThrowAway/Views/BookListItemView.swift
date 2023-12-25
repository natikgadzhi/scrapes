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
        formatter.dateFormat = "EEEE MMMM dd, yyyy"
        return formatter
    }()
    
    var body: some View {
        
        NavigationLink(value: book) {
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
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    BookListItemView(book: Book.mockBooks.first!)
}
