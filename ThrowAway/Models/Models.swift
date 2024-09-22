//
//  Book.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import Foundation
import SwiftData
import SwiftSoup

/// Represents a single book in Kindle's website representation
@Model class Book {

    /// `id` is based on `asin`, but required for `Identifiable` conformance.
    @Attribute(.unique) var id: String
    var title: String
    
    var author: String
    var modifiedAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Highlight.book) var highlights: [Highlight]
    
    public init(id: String, title: String, author: String, modifiedAt: Date, highlights: [Highlight] = [Highlight]()) {
        self.id = id
        self.title = title
        self.author = author
        self.modifiedAt = modifiedAt
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
        self.highlights = [Highlight]()
    }
}

// MARK: Highlights

/// Highlight is a single highlight block in a book.
@Model class Highlight {

  // QTIzRkhUSFVLRTgwRFc6QjAwNFczRk00QTo1NTQyOkhJR0hMSUdIVDphMzFmMWNiODMtMTlmNC00MzMxLWE0MTAtYzIzYTM3YzFjYTg0
  @Attribute(.unique) var id: String

  // Highlight or Note
  var type: String

  // Highlight text
  var text: String

  // Position in the book
  var position: Int

  // Page number in the book
  var page: Int

  // kp-highlight-yellow, etc
  var color: String

  var book: Book?

  public init(
    book: Book, id: String, type: String, text: String, position: Int, page: Int, color: String
  ) {
    self.book = book
    self.id = id
    self.type = type
    self.text = text
    self.position = position
    self.page = page
    self.color = color
  }

  public init(id: String, type: String, text: String, position: Int, page: Int, color: String) {
    self.id = id
    self.type = type
    self.text = text
    self.position = position
    self.page = page
    self.color = color
  }

  public init(for book: Book, from markup: SwiftSoup.Element) throws {
    self.book = book
    self.id = markup.id()

    let text = try markup.select("#highlight").first()?.text()
    guard let text = text else {
      throw KindleError.errorParsingBooks
    }
    self.text = text

    // FIXME
    self.type = "Highlight"
    self.position = 0
    self.page = 0
    self.color = "Yellow"
  }

}
