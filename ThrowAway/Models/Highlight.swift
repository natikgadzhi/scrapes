//
//  Highlight.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 10/20/24.
//

import SwiftData
import SwiftUI
import SwiftSoup

enum HighlightType: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case note, highlight
}

enum HighlightColor: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case yellow, red, blue, green, purple
    
    // TODO: Improve the color mappings, these are used in the UI And should look nice for backgrounds.
    // It could be a good idea to move these to assets to support both light and dark modes, and move the mapping into a view layer extension.
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
    
    var book: Book?
    
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
        
        // If the note text is present and is not empty, this highlight is actually a note.
        // save the type = .note and the noteText.
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
