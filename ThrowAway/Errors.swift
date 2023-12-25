//
//  Errors.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import Foundation

enum KindleError: Error {
    /// No cookies are set on the Kindle API Client
    case noCookies
    
    /// Couldn't parse HTTP response into a string
    case badHTTPResponse
    
    /// Couldn't parse Books from a response
    case errorParsingBooks
}
