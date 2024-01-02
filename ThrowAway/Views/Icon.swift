//
//  Icon.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 1/1/24.
//

import SwiftUI

struct IconView: View {
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Color.iconBackground
            
            RadialGradient(gradient: Gradient(colors: [Color.white.opacity(0.175), Color.iconBackground]),
                           center: .center,
                           startRadius: 0,
                           endRadius:  size * 2)
            
            Group {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: size * 0.8))
                    .fontWeight(.thin)
                    .foregroundStyle(Color.bookmark)
                    .overlay(
                        LinearGradient(colors: [Color.black.opacity(0.05), Color.black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .mask {
                                Image(systemName: "bookmark.fill")
                                    .font(.system(size: size * 0.8))
                                    .fontWeight(.thin)
                            }
                    )
                
                Image(systemName: "text.quote")
                    .font(.system(size: size * 0.3))
                    .foregroundStyle(.black.opacity(0.8))
                    .offset(y: -size * 0.1)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: max(size * 0.025, 10), style: .circular))
        .frame(width: size, height: size)
    }
    
    @MainActor func snapshot() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = ImageRenderer(content: self)
        renderer.scale = UIScreen.main.scale // Adjust the scale for higher resolution
        return renderer.uiImage
    }
}

#Preview {
    IconView(size: 200)
}

extension Color {
    static var iconBackground = Color.black
    static var bookmark = Color.yellow
}
