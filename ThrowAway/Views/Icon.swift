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
                        LinearGradient(colors: [Color.red.opacity(0.05), Color.red.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
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
}

#Preview {
    IconView(size: 200)
}

extension Color {
    static var iconBackground = Color.black
    static var bookmark = Color.yellow
}
