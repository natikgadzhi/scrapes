//
//  SwiftUIView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI

struct ErrorView: View {
    
    var error: Error
    
    @State private var offset = CGSize(width: 0, height: -100)
    
    var errorDescription: String {
        if let error = error as? KindleError {
            return error.rawValue
        } else {
            return error.localizedDescription
        }
    }
    
    var body: some View {
        VStack {
            withAnimation {
                HStack {
                    Image(systemName: "exclamationmark.octagon")
                        .padding(.leading, 4)

                    Text(errorDescription)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .padding(.trailing, 4)
                }
                .frame(height: 60)
                .background(
                    // TODO: Replace with a decent color
                    Color
                        .red
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                )
            }
            
            Spacer()
        }
        .offset(offset)
        .onAppear {
            withAnimation(.easeOut(duration: 0.15)) {
                offset.height += 160
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeIn(duration: 0.15)) {
                    offset.height -= 160
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ErrorView(error: KindleError.errorParsingBooks)
}
