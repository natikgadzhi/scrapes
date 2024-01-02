//
//  ViewModel.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI
import SwiftData

@Observable class ViewModel {
    
    var unauthenticated: Bool   = true
    var isLoading: Bool         = false
    var recentError: Error?     = nil
    
    // TODO: This might be a problem if we'll init two VMs in some code
    public init() {
        KindleAPI.shared.delegate = self
    }
    
    // KindleAPI calls the delegate and sets the authentication flag.
    func onSuccessfulAuth() {
        DispatchQueue.main.async {
            self.unauthenticated = false
        }
    }
    
    // FIXME: Clearly I'm doing threading wrong.
    func withLoading(perform: @escaping (() async throws -> Void)) async {
        DispatchQueue.main.async { self.isLoading = true }
        do {
            try await perform()
        } catch {
            DispatchQueue.main.async {
                self.recentError = error
            }
        }
        DispatchQueue.main.async { self.isLoading = false }
    }
}
