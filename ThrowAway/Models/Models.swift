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

// MARK: Highlights

enum HighlightType: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case note, highlight
    
    var title: String {
        switch self {
        case .note: return "note"
        case .highlight: return "highlight"
        }
    }
}

enum HighlightColor: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case yellow, red, blue, green, purple
    
    var color: Color {
        switch self {
        case .yellow: return .yellow
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .purple: return .purple
        }
    }
}

/// Highlight is a single highlight block in a book.
@Model class Highlight {
    
    // QTIzRkhUSFVLRTgwRFc6QjAwNFczRk00QTo1NTQyOkhJR0hMSUdIVDphMzFmMWNiODMtMTlmNC00MzMxLWE0MTAtYzIzYTM3YzFjYTg0
    @Attribute(.unique) var id: String
    
    // Highlight or Note
    var type: HighlightType
    
    // Highlight text
    var highlightText: String
    
    // Note text. Notes have both the highlight and the note, so this is optional.
    var noteText: String?
    
    // Position in the book
    var position: Int
    
    // Page number in the book. Sometimes this is empty in kindle data.
    var page: Int?
    
    // kp-highlight-yellow, etc
    var color: HighlightColor
    
    var book: Book?
    
    public init(book: Book, id: String, type: HighlightType, highlightText: String, noteText: String? = nil, position: Int, page: Int? = nil, color: HighlightColor) {
        self.book = book
        self.id = id
        self.type = type
        self.highlightText = highlightText
        self.noteText = noteText
        self.position = position
        self.page = page
        self.color = color
    }
    
    public init(id: String, type: HighlightType, highlightText: String, noteText: String? = nil, position: Int, page: Int? = nil, color: HighlightColor) {
        self.id = id
        self.type = type
        self.highlightText = highlightText
        self.noteText = noteText
        self.position = position
        self.page = page
        self.color = color
    }
    
    public init(for book: Book, from markup: SwiftSoup.Element) throws {
        self.book = book
        self.id = markup.id()
        
        let highlightText = try markup.select("#highlight").first()?.text()
        guard let highlightText = highlightText else {
            throw KindleError.errorParsingBooks
        }
        self.highlightText = highlightText
        
        let noteText = try markup.select("#note").first()?.text()
        if let noteText, !noteText.isEmpty {
            self.type = .note
            self.noteText = noteText
        } else {
            self.type = .highlight
            self.noteText = nil
        }
        
        // Parse highlight color
        let highlightContainer = try markup.select(".kp-notebook-highlight").first()
        let colorClass = try highlightContainer?.className() ?? ""
        let colorComponents = colorClass.components(separatedBy: " ")
        let colorString = colorComponents.first(where: { $0.hasPrefix("kp-notebook-highlight-") })?.replacingOccurrences(of: "kp-notebook-highlight-", with: "") ?? "yellow"
        
        self.color = HighlightColor.init(rawValue: colorString)!
        
        // Parse page number
        let headerElement = try markup.select("#annotationHighlightHeader").first()
        let headerText = try headerElement?.text() ?? ""
        let pageRange = headerText.range(of: "Page:\\s*", options: .regularExpression)
        if let pageRange = pageRange {
            let pageString = headerText[pageRange.upperBound...]
                .trimmingCharacters(in: .whitespaces)
            self.page = Int(String(pageString)) ?? 0
        } else {
            self.page = nil
        }
        
        // Parse position
        let locationValue = try markup.select("#kp-annotation-location").first()?.val()
        self.position = Int(locationValue ?? "0") ?? 0
    }
    
}
