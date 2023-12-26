//
//  KindleAPI.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import Foundation
import WebKit
import SwiftSoup

enum KindleEndpoint: String {
    case login      = "https://www.amazon.com/ap/signin?openid.pape.max_auth_age=1209600&openid.return_to=https%3A%2F%2Fread.amazon.com%2Fkindle-library&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=amzn_kindle_mykindle_us&openid.mode=checkid_setup&language=en_US&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&pageId=amzn_kindle_mykindle_us&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0"
    
    case books      = "https://read.amazon.com/notebook?ref_=kcr_notebook_lib&language=en-US"

    case library    = "https://read.amazon.com/kindle-library"

    var url: URL {
        URL(string: self.rawValue)!
    }
}

class KindleAPI: NSObject {
    
    static var shared = KindleAPI()
    
    private var cookies: [HTTPCookie]?
    
    // Upstream View Model
    var delegate: ViewModel? = nil
    
    func getBooks() async throws -> [Book] {
        let request = try self.makeRequest(url: KindleEndpoint.books.url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let responseBody = String(data: data, encoding: .utf8)
        guard let responseBody = responseBody else {
            throw KindleError.badHTTPResponse
        }
        
        // Parsing.
        // Perhaps we can extract this into a helper,
        // depending on what Highlights parsing is going to look like.
        let page = try SwiftSoup.parse(responseBody)
        
        let booksMarkup = try page.select(".kp-notebook-library-each-book")
        guard !booksMarkup.isEmpty() else {
            throw KindleError.errorParsingBooks
        }
        
        let books = try booksMarkup.map { try Book(from: $0) }
        
        return books
    }
    
    func getHighlights(for book: Book) async throws -> [Highlight] {
        let urlString = "https://read.amazon.com/notebook?asin=\(book.id)&contentLimitState=&"

        let request = try self.makeRequest(url: URL(string: urlString)!)
        let (data, _) = try await URLSession.shared.data(for: request)

        let responseBody = String(data: data, encoding: .utf8)
        guard let responseBody = responseBody else {
            throw KindleError.badHTTPResponse
        }

        let page = try SwiftSoup.parse(responseBody)

        let annoationsMarkup = try page.select(".kp-notebook-annotations")

        let highlights = try annoationsMarkup.map { try Highlight(for: book, from: $0) }

        return highlights
    }
    
    
    /// Makes a new `URLRequest` and sets the headers into it
    private func makeRequest(url: URL) throws -> URLRequest {
        guard let cookies = cookies else {
            throw KindleError.noCookies
        }
        
        var request = URLRequest(url: url)
        let headers = HTTPCookie.requestHeaderFields(with: cookies)
        for (name, value) in headers {
            request.addValue(value, forHTTPHeaderField: name)
        }
        
        return request
    }
    
}

extension KindleAPI: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.url == KindleEndpoint.library.url {
            let dataStore = webView.configuration.websiteDataStore
            
            dataStore.httpCookieStore.getAllCookies { [self] cookies in
                self.cookies = cookies
                self.delegate?.onSuccessfulAuth()
            }
        }
        decisionHandler(.allow)
    }
}
