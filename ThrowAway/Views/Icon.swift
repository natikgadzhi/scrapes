//
//  Icon.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 1/1/24.
//

import SwiftUI

struct Icon: View {
    var body: some View {
        
        ZStack {
            Color.iconBackground
            
            RadialGradient(gradient: Gradient(colors: [Color.white.opacity(0.175), Color.iconBackground]),
                           center: .center,
                           startRadius: 0,
                           endRadius:  1800)
            
            Group {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 800))
                    .fontWeight(.thin)
                    .foregroundStyle(Color.bookmark)
                    .overlay(
                        LinearGradient(colors: [Color.black.opacity(0.05), Color.black.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .mask {
                                Image(systemName: "bookmark.fill")
                                    .font(.system(size: 800))
                                    .fontWeight(.thin)
                            }
                            .blendMode(.darken)
                    )
                
                
                
                Image(systemName: "text.quote")
                    .font(.system(size: 300))
                    .foregroundStyle(.black.opacity(0.8))
                    .offset(y: -110)
            }
            .offset(x: 0, y: -10)

        }
        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .circular))
        .frame(width: 1024, height: 1024)
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

struct IconHostView: View {
    
    var body: some View {
        VStack {
            iconView()
                .padding()
            
            Button("Save Icon") {
                print("Saving!")
                
                if let image = self.iconView().snapshot() {
                    if let imageData = image.pngData() {
                        // Use the image, e.g., save it to the Photos album
                        // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        
                        let documentsDirectory = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
                        let fileName = "icon-from-swiftUI.png"
                        let fileURL = documentsDirectory.appendingPathComponent(fileName)
                        
                        do {
                            try imageData.write(to: fileURL)
                        } catch {
                            print("Could not save the view into a PNG: \(error.localizedDescription)")
                        }
                    } else {
                        print("Could not save the view into a PNG")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    func iconView() -> Icon {
        return Icon()
    }
}

#Preview {
    IconHostView()
}

// TODO: Move colors into the assets bundle
extension Color {
    static var iconBackground = Color.black
    static var bookmark = Color.yellow
}
