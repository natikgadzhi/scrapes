//
//  MockData.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/26/23.
//

import Foundation
import SwiftData
import SwiftSoup

@MainActor
class MockData {
    
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Book.self, Highlight.self, configurations: config)
            
            for book in MockData.books {
                container.mainContext.insert(book)
            }
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
    
    static let books: [Book] = {
        let coverURL = URL(string: "https://m.media-amazon.com/images/I/81Dd92++GgS._SY160.jpg")
        
        var books = [Book]()
        for i in 1...10 {
            let book = Book(id: "\(i)", title: "Programming Book \(i)", author: "Author Name \(i)", modifiedAt: Date(), coverImageURL: coverURL, highlights: generateHighlights(forBookId: "\(i)"))
            books.append(book)
        }
        return books
    }()
    
    static func generateHighlights(forBookId bookId: String) -> [Highlight] {
        var highlights = [Highlight]()
        
        let highlightTexts = [
            "Code is like humor. When you have to explain it, it’s bad.",
            "The best error message is the one that never shows up.",
            "Debugging is twice as hard as writing the code in the first place.",
            "Simplicity is the soul of efficiency.",
            "It's not a bug – it's an undocumented feature."
        ]
        
        for (index, text) in highlightTexts.enumerated() {
            let highlight = Highlight(id: "\(bookId)-\(index)", type: .highlight, highlightText: text, noteText: nil, position: index * 10, page: index + 1, color: HighlightColor.allCases.randomElement()!)
            highlights.append(highlight)
        }
        
        let note = Highlight(id: "\(bookId)-note", type: .note, highlightText: "Important concept", noteText: "Remember to review this section.", position: 100, page: 10, color: .blue)
        highlights.append(note)
        
        return highlights
    }
}

//import Foundation
//import SwiftData
//import SwiftSoup
//
//@MainActor
//class MockData {
//    
//    static let previewContainer: ModelContainer = {
//        do {
//            let config = ModelConfiguration(isStoredInMemoryOnly: true)
//            let container = try ModelContainer(for: Book.self, configurations: config)
//            
//            for book in MockData.books {
//                container.mainContext.insert(book)
//            }
//            
//            return container
//        } catch {
//            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
//        }
//    }()
//    
//    static let books: [Book] = {
//        [
//            Book(id: "1", title: "All Tomorrow's Parties", author: "William Gibson", modifiedAt: Date(), coverImageURL: URL(string: "https://m.media-amazon.com/images/I/81Dd92++GgS._SY160.jpg")),
//            Book(id: "2", title: "Idoru", author: "William Gibson", modifiedAt: Date.distantPast, coverImageURL: URL(string: "https://m.media-amazon.com/images/I/81Dd92++GgS._SY160.jpg")),
//            Book(id: "3", title: "Virtual Light", author: "William Gibson", modifiedAt: Date.distantPast, coverImageURL: URL(string: "https://m.media-amazon.com/images/I/81Dd92++GgS._SY160.jpg")),
//        ]
//    }()
//}
