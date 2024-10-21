//
//  ViewModel.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI
import SwiftData

@Observable @MainActor class ViewModel {
    
    /// Whether the client is currently authenticated to fetch data from Kindle API.
    /// Starts as `false`, but can be changed with `onSuccessfulAuth`.
    var unauthenticated: Bool   = true
    
    /// Should the loading view be presented instead of the content on the current screen?
    var isLoading: Bool         = false
    
    /// The most recent error that happened anywhere in the app. Setting this would show the error notification toast.
    var recentError: Error?     = nil
    
    // TODO: This might be a problem if we'll init two VMs in some code
    public init() {
        KindleAPI.shared.delegate = self
    }
    
    /// Toggle `unauthenticated` to be false on successful authentication.
    /// This method is triggered in KindleAPI delegate from the webView.
    func onSuccessfulAuth() {
        self.unauthenticated = false
    }
    
    /// Run the provided function, wrapped in `isLoading` indicator so the views can show the loading view.
    func withLoading(perform: @escaping (() async throws -> Void)) async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            try await perform()
        } catch {
            self.recentError = error
        }
    }
}
