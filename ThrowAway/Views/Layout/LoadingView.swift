//
//  SwiftUIView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                .scaleEffect(1.0, anchor: .center)
        }
    }
}

struct WithLoadingView<Content: View>: View {
    @Binding var isLoading: Bool
    
    let content: () -> Content
    
    var body: some View {
        if isLoading {
            LoadingView()
        } else {
            content()
        }
    }
}

#Preview {
    LoadingView()
}
