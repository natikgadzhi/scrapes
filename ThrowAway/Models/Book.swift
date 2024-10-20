//
//  Book.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import Foundation
import SwiftData
import SwiftUI
import SwiftSoup

/// Represents a single book in Kindle's website representation
@Model class Book {
    
    /// `id` is based on `asin`, but required for `Identifiable` conformance.
    @Attribute(.unique) var id: String
    var title: String
    
    var author: String
    var modifiedAt: Date
    
    var coverImageURL: URL?
    
    @Relationship(deleteRule: .cascade, inverse: \Highlight.book) var highlights: [Highlight]
    
    public init(id: String, title: String, author: String, modifiedAt: Date, coverImageURL: URL? = nil, highlights: [Highlight] = [Highlight]()) {
        self.id = id
        self.title = title
        self.author = author
        self.modifiedAt = modifiedAt
        self.coverImageURL = coverImageURL
        self.highlights = highlights
    }
    
    /// Make a new `Book` from a `SwiftSoup.Element` and return it.
    public init(from markup: SwiftSoup.Element) throws {
        let id = markup.id()
        self.id = id
        
        let title = try markup.select("h2").first()?.text()
        guard let title = title else {
            throw KindleError.errorParsingBooks
        }
        self.title = title
        
        let authorString = try markup.select("p.kp-notebook-searchable").first()?.text()
        guard let authorString = authorString else {
            throw KindleError.errorParsingBooks
        }
        self.author = authorString
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEEE MMM d, yyyy"
        
        let modifiedAtString = try markup.select("#kp-notebook-annotated-date-\(id)").val()
        let modifiedAt = dateFormatter.date(from: modifiedAtString)
        guard let modifiedAt = modifiedAt else {
            throw KindleError.errorParsingBooks
        }
        self.modifiedAt = modifiedAt
        
        // Parse cover URL
        if let imgElement = try markup.select("img.kp-notebook-cover-image").first() {
            let coverURLString = try imgElement.attr("src")
            if let coverImageURL = URL(string: coverURLString) {
                self.coverImageURL = coverImageURL
            }
        }
        
        self.highlights = [Highlight]()
    }
}
