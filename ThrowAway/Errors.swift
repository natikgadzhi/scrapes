//
//  Errors.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import Foundation

enum KindleError: String, Error {
    
    /// No cookies are set on the Kindle API Client
    case noCookies = "Couldn't authenticate the request to Kindle."
    
    /// Couldn't parse HTTP response into a string
    case badHTTPResponse = "Kindle Cloud Reader error."
    
    /// Couldn't parse Books from a response
    case errorParsingBooks = "Couldn't parse the books from Kindle markup."
}
