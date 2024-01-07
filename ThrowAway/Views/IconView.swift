//
//  Icon.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 1/1/24.
//

import SwiftUI

struct IconView: View {
    // IconView is square. All sizes in the view will scale to this.
    var size: CGFloat
    
    var body: some View {
        ZStack {
            // The background layer.
            Color.iconBackground
            
            // Slight gradient, will us the radiating light.
            RadialGradient(gradient: Gradient(colors: [Color.white.opacity(0.175), Color.iconBackground]),
                           center: .center,
                           startRadius: 0,
                           endRadius:  size * 2)
            
            // Two SF Symbol icons grouped one on fop of the other.
            // Using `Group` allows us to reposition them together on the background if needed.
            Group {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: size * 0.8))
                    .fontWeight(.thin)
                    .foregroundStyle(Color.bookmark)
                    .overlay(
                        // Using overlay with a linear gradient allows you to gradient-fill the icon, using the `mask()` modifier
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
        // iOS app icons don't necessarily need rounded corners.
        // But if you're using this icon elsewhere in the app, this will look nice enough.
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
