//
//  UnauthenticatedView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI

struct WelcomeView: View {
    
    @State var isShowingAuth = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()

                HStack {
                    Spacer()
                    IconView(size: 60)
                        .padding(.trailing)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Welcome to Scrapes")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 4)
                    
                    Text("Scrapes is a small app that helps you grab your highlights, notes, bookmarks, and ideas from Kindle books.")
                        .lineLimit(5)
                }
                
                Spacer()
                
                Button(action: {
                    isShowingAuth = true
                }, label: {
                    Text("Login with Amazon")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                })
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                
                // That VStack just aligns the text to leading. Perhaps there's a better way to do this.
                VStack(alignment: .leading) {
                    Text("""
                        Scrapes does not store your credentials or cookies anywhere.It _doesn't have a backend server_ whatsoever, and works on device. And, it's fully open-source.
                        """)
                        .font(.caption)
                        .lineLimit(6)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: 400)
            .padding()
        }
        .sheet(isPresented: $isShowingAuth) {
            WebViewSheet(url: KindleEndpoint.login.url)
        }
    }
}

#Preview {
    WelcomeView()
}
