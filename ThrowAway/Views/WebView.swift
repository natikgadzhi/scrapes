//
//  WebView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/23/23.
//

import SwiftUI
import WebKit

import SwiftSoup

/// WebViewSheet wraps a web view in a sheet presentation with a cancel button on it.
struct WebViewSheet: View {
    
    var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            WebView(url: KindleEndpoint.login.url, navigationDelegate: viewModel.kindleAPI)
                .padding(.vertical)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewModel.isShowingAuth = false
                        }
                    }
                }
        }
    }
}

/// WebView is a SwiftUI wrapper around WKWebView.
/// It takes a `url` and `navigationDelegate` in, and it does not have any navigation logic on it's own.
struct WebView: UIViewRepresentable {
    var url: URL
    var navigationDelegate: WKNavigationDelegate?
    
    func makeUIView(context: Context) -> WKWebView  {
        let prefs = WKPreferences()
        let config = WKWebViewConfiguration()
        config.preferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = navigationDelegate
        
        return webView
    }
    
    // FIXME: Um, I don't think we should load the url on every `updateView`,
    // perhaps only on the first one.
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}

#Preview {
    WebViewSheet(viewModel: ViewModel())
}
