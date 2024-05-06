//
//  WebView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/23/23.
//

import SwiftUI
import WebKit

/// WebViewSheet wraps a web view in a navigation stack, to be used in a sheet, with a cancel button on it.
struct WebViewSheet: View {
    
    @Environment(\.dismiss) var dismiss
    var url: URL
    
    var body: some View {
        NavigationStack {
            WebView(url: url, navigationDelegate: KindleAPI.shared)
                .ignoresSafeArea(.container)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
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
        let webView = WKWebView()
        webView.navigationDelegate = navigationDelegate
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    WebViewSheet(url: KindleEndpoint.login.url)
}
