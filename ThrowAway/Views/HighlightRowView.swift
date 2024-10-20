//
//  HighlightRowView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 10/20/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct HighlightRowView: View {
    
    let highlight: Highlight
    
    @Environment(ViewModel.self) var viewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(highlight.highlightText)
                .font(.system(size: 16, weight: .regular, design: .serif ))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(self.highlight.color.color)
                        .stroke(self.highlight.color.color, lineWidth: 1)
                )
            Text("Page: \(highlight.page), Position: \(highlight.position)")
                .font(.caption)
            
            Button("Copy") {
                // TODO: Make sure copying a highlight works on both Mac and iOS
                UIPasteboard.general.setValue(highlight.highlightText, forPasteboardType: UTType.plainText.identifier)
            }
            .buttonStyle(.bordered)
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        //HighlightRowView(highlight: MockData.bookWithHighlights.highlights.first!)
    }
}
