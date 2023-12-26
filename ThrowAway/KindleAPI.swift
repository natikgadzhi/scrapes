//
//  KindleAPI.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import Foundation
import WebKit
import SwiftSoup

/// KindleEndpoint represents API endpoints and auth site that are used to grab the data for books and highlights.
struct KindleEndpoint {
    let urlString: String
    
    var url: URL {
        return URL(string: urlString)!
    }
    
    static var login = KindleEndpoint(urlString: "https://www.amazon.com/ap/signin?openid.pape.max_auth_age=1209600&openid.return_to=https%3A%2F%2Fread.amazon.com%2Fkindle-library&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=amzn_kindle_mykindle_us&openid.mode=checkid_setup&language=en_US&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&pageId=amzn_kindle_mykindle_us&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0")
    
    static var books = KindleEndpoint(urlString: "https://read.amazon.com/notebook?ref_=kcr_notebook_lib&language=en-US")
    
    static var library = KindleEndpoint(urlString: "https://read.amazon.com/kindle-library")
    
    static func highlights(asin: String, cursor: String = "") -> KindleEndpoint {
        return KindleEndpoint(urlString: "https://read.amazon.com/notebook?asin=\(asin)&contentLimitState=\(cursor)&")
    }
}

// TODO:
// Use `ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"]` to check for preview environment and
// avoid making API requests in it.
//
class KindleAPI: NSObject {
    
    /// An instance of `KindleAPI`.
    static var shared = KindleAPI()
    
    /// Cookies to inject as headers into API URLRequests.
    /// They're saved from the authentication web view when it successfully authenticates.
    private var cookies: [HTTPCookie]? = nil
    
    // URLSessionWrapper has an actual URLSession in it,
    // but wraps it in a conditional to allow for test network request stubs.
    private var urlSession = URLSessionWrapper()
    
    // Upstream View Model
    var delegate: ViewModel? = nil
    
    func getBooks() async throws -> [Book] {
        let request = try self.makeRequest(url: KindleEndpoint.books.url)
        
        let (data, _) = try await self.urlSession.data(for: request)
        
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
        let url = KindleEndpoint.highlights(asin: book.id).url
        let request = try self.makeRequest(url: url)
        let (data, _) = try await self.urlSession.data(for: request)

        let responseBody = String(data: data, encoding: .utf8)
        guard let responseBody = responseBody else {
            throw KindleError.badHTTPResponse
        }

        let page = try SwiftSoup.parse(responseBody)
        let allAnnotations = try page.select("#kp-notebook-annotations > div:not(:last-child)")

        let highlights = try allAnnotations.map { try Highlight(for: book, from: $0) }

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
    
    // webView delegate is passed to the authentication webView.
    // It's job is to detect when the webview navigates to the library page (i.e. successfully authenticated)
    // and grab the cookies from the webview.
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
