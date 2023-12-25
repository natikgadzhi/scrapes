//
//  Book.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import Foundation
import SwiftSoup


/// Represents a single book in Kindle's website representation
struct Book: Identifiable, Hashable {
    
    /// `id` is based on `asin`, but required for `Identifiable` conformance.
    var id: String {
        return asin
    }
    
    let title: String
    let author: String
    
    /// Kindle's ASIN, i.e. B004W3FM4A
    let asin: String
    
    /// Make a new `Book` from a `SwiftSoup.Element` and return it.
    /// TODO: Add more fields into `Book`
    static func fromHTML(_ markup: SwiftSoup.Element) throws -> Book {
        let asin = markup.id()
        let title = try markup.select("h2").first()?.text()
        
        return Book(title: title ?? "whaps", author: "", asin: asin)
    }
}

extension Book {
    static var mockBooks: [Book] {
        [
            Book(title: "All Tomorrow's Parties", author: "William Gibson", asin: "1"),
            Book(title: "Idoru", author: "William Gibson", asin: "2"),
            Book(title: "Virtual Light", author: "William Gibson", asin: "3")
        ]
    }
}

/// Highlight is a single highlight block in a book.
struct Highlight {
    let text: String
    
    // FIXME: That should be something like an index within a book
    let position: String
}
