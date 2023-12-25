//
//  ViewModel.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI

@Observable class ViewModel {
    
    let kindleAPI: KindleAPI
    
    var isAuthenticated: Bool = false
    var isShowingAuth: Bool = false
    var isLoading: Bool = false
    
    var recentError: Error? = nil
    
    var books: [Book]
    
    public init() {
        
        self.books = [Book]()
        
        self.kindleAPI = KindleAPI()
        self.kindleAPI.delegate = self
    }
    
    func onSuccessfulAuth() {
        self.isAuthenticated = true
        self.isShowingAuth = false
    }
    
    func prefetchBooks() {
        Task {
            self.isLoading = true
            
            do {
                self.books = try await self.kindleAPI.getBooks()
            } catch {
                self.isAuthenticated = false
                self.recentError = error
            }
            self.isLoading = false
        }
    }
}

extension ViewModel {
    static var mock: ViewModel {
        let vm = ViewModel()
        vm.books = Book.mockBooks
        return vm
    }
}
