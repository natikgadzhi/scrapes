//
//  URLSession+Stubs.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/26/23.
//

import Foundation

/// A lightweight wrapper around a `URLSession` to conditionally allow stubbing network requests in test and preview environments.
class URLSessionWrapper {
    
    var cache: [URL: (Data, URLResponse)] = [URL: (Data, URLResponse)]()
    
    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        
        // When replaying a session, try fetching it from cache and returning.
        // If no record was cached, this will throw an error.
        if ProcessInfo.isReplayingSession {
            let (data, response) = try self.readTape(url: request.url!)
            return (data, response)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Prepare the cache directory to record the session if the recording flag is set
        if ProcessInfo.isRecordingSession {
            try self.writeTape(data: data, response: response, url: request.url!)
        }

        return (data, response)
    }
    
    func writeTape(data: Data, response: URLResponse, url: URL) throws {
        
        
        cache[url] = (data, response)
        
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let urlSessionCacheDirectory = cachesDirectory.appending(path: "kindle-api-urlsession-cache")
        try FileManager.default.createDirectory(at: urlSessionCacheDirectory, withIntermediateDirectories: true)
        
        let filePath = urlSessionCacheDirectory.appending(path: url.path() + ".txt")
        
        try String(data: data, encoding: .utf8)?.write(toFile: filePath.absoluteString, atomically: true, encoding: .utf8)
        
    }
    
    func readTape(url: URL) throws -> (Data, URLResponse) {
        if cache.keys.contains(url) {
            return cache[url]!
        } else {
            throw URLSessionWrapperError.notCached
        }
    }
}

enum URLSessionWrapperError: String, Error {
    case notCached = "This URL is not available in the response cache"
}
