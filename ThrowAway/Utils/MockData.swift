//
//  MockData.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/26/23.
//

import Foundation
import SwiftData


@MainActor
class MockData {
    
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Book.self, configurations: config)

            for book in MockData.books {
                container.mainContext.insert(book)
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
    
    static let books: [Book] = {
        [
            Book(id: "1", title: "All Tomorrow's Parties", author: "William Gibson", modifiedAt: Date()),
            Book(id: "2", title: "Idoru", author: "William Gibson", modifiedAt: Date.distantPast),
            Book(id: "3", title: "Virtual Light", author: "William Gibson", modifiedAt: Date.distantPast)
        ]
    }()
}
