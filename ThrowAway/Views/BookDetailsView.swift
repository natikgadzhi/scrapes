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
        VStack(alignment: .leading) {

            Spacer()
        }
        .padding()
        .navigationTitle(book.title)
    }
}


#Preview {
    NavigationStack {
        BookDetailsView(book: Book.mockBooks[1])
    }
}
