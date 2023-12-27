//
//  URLSession+Stubs.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/26/23.
//

import Foundation

/// A lightweight wrapper around a `URLSession` to conditionally allow stubbing network requests in test and preview environments.
struct URLSessionWrapper {
    let urlSession = URLSession.shared
    
    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        if ProcessInfo.isTest {
            print("Stubbing the requests")
            return try await urlSession.data(for: request)
        } else {
            return try await urlSession.data(for: request)
        }
    }
}
