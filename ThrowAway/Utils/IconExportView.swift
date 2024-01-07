//
//  IconExportView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 1/1/24.
//

import SwiftUI

// Used to present the icon and a button to save the icon into the Pictures folder.
// Intended to be used in development only.
struct IconExportView: View {
    
    var body: some View {
        VStack {
            IconView(size: 200)
                .padding()
            
            Button("Save Icon") {
                self.exportImage()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    /// Make an `IconView` of size `1024`.
    func iconView() -> IconView {
        return IconView(size: 1024)
    }
    
    /// Grab a snapshot of a target view as a ``UIImage``.
    @MainActor func snapshot(of target: some View) -> UIImage? {
        let controller = UIHostingController(rootView: target)
        let view = controller.view
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = ImageRenderer(content: target)
        renderer.scale = UIScreen.main.scale // Adjust the scale for higher resolution
        return renderer.uiImage
    }
    
    @MainActor func exportImage() {
        print("Saving!")
        
        if let image = self.snapshot(of: iconView()) {
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
}

#Preview {
    IconExportView()
}
