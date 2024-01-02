//
//  IconHostView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 1/1/24.
//

import SwiftUI

// Used to present the icon and a button to save the icon into the Pictures folder.
// Intended to be used in development only.
struct IconHostView: View {
    var body: some View {
        VStack {
            
            iconView()
                .padding()
            
            Button("Save Icon") {
                print("Saving!")
                
                if let image = self.iconView().snapshot() {
                    if let imageData = image.pngData() {
                        let pictures = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
                        let fileName = "icon-from-swiftUI.png"
                        let fileURL = pictures.appendingPathComponent(fileName)
                        
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
    
    func iconView() -> IconView {
        return IconView(size: 1024)
    }
}

#Preview {
    IconHostView()
}
