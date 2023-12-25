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

    let modifiedAt: Date

    /// Make a new `Book` from a `SwiftSoup.Element` and return it.
    /// TODO: Add more fields into `Book`
    static func fromHTML(_ markup: SwiftSoup.Element) throws -> Book {
        let asin = markup.id()

        let title = try markup.select("h2").first()?.text()
        guard let title = title else {
            throw KindleError.errorParsingBooks
        }

        let authorString = try markup.select("p.kp-notebook-searchable").first()?.text()
        guard let authorString = authorString else {
            throw KindleError.errorParsingBooks
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEEE MMM d, yyyy"

        let modifiedAtString = try markup.select("#kp-notebook-annotated-date-\(asin)").val()
        let modifiedAt = dateFormatter.date(from: modifiedAtString)
        guard let modifiedAt = modifiedAt else {
            throw KindleError.errorParsingBooks
        }

        return Book(title: title, author: authorString, asin: asin, modifiedAt: modifiedAt)
    }
    
}

extension Book {
    static var mockBooks: [Book] {
        [
            Book(title: "All Tomorrow's Parties", author: "William Gibson", asin: "1", modifiedAt: Date()),
            Book(title: "Idoru", author: "William Gibson", asin: "2", modifiedAt: Date.distantPast),
            Book(title: "Virtual Light", author: "William Gibson", asin: "3", modifiedAt: Date.distantPast)
        ]
    }
}

/// Highlight is a single highlight block in a book.
struct Highlight: Identifiable, Hashable {

    // QTIzRkhUSFVLRTgwRFc6QjAwNFczRk00QTo1NTQyOkhJR0hMSUdIVDphMzFmMWNiODMtMTlmNC00MzMxLWE0MTAtYzIzYTM3YzFjYTg0
    let id: String

    // Highlight or Note
    let type: String

    // Highlight text
    let text: String
    
    // Position in the book
    let position: Int

    // Page number in the book
    let page: Int

    // kp-highlight-yellow, etc
    let color: String


    static func fromHTML(_ markup: SwiftSoup.Element ) throws -> Highlight {

        let id = markup.id()

        let text = try markup.select("#highlight").first()?.text()
        guard let text = text else {
            throw KindleError.errorParsingBooks
        }

        return Highlight(id: id, type: "Highlight", text: text, position: 0, page: 0, color: "yellow")
    }

}
