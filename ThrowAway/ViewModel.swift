//
//  ViewModel.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI
import SwiftData

@Observable class ViewModel {
        
    var isAuthenticated: Bool = false
    var isLoading: Bool = false
    
    var recentError: Error? = nil
    
    public init() {
        KindleAPI.shared.delegate = self
    }
    
    func onSuccessfulAuth() {
        self.isAuthenticated = true
    }
    
    func withLoading(perform: @escaping (() async throws -> Void)) {
        Task {
            self.isLoading = true
            do {
                try await perform()
            } catch {
                self.recentError = error
            }
            self.isLoading = false
        }
    }

    func fetchHighlights(for book: Book) {
        Task {
            self.isLoading = true
            
            do {
                let highlights = try await KindleAPI.shared.getHighlights(for: book)
                book.highlights = highlights
            } catch {
                self.isAuthenticated = false
                self.recentError = error
            }
            
            self.isLoading = false
        }
    }
}
