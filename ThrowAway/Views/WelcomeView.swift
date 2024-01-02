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
            VStack(alignment: .leading) {
                Spacer()

                HStack {
                    Spacer()
                    IconView(size: 60)
                        .padding(.trailing)
                    Spacer()
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("Welcome to Scrapes")
                        .lineLimit(1)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 4)
                    
                    Text("Scrapes is a small app that helps you grab your highlights, notes, bookmarks, and ideas from Kindle books.")
                        .lineLimit(5)
                        .padding(.bottom)
                }
                .padding(.bottom)
                
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
                .padding(.bottom)
                .frame(maxWidth: .infinity)
                
                
                VStack(alignment: .leading) {
                    Text("""
                        Scrapes does not store your credentials or cookies anywhere.It _doesn't have a backend server_ whatsoever, and works on device. And, it's fully open-source.
                        """)
                        .font(.caption)
                        .lineLimit(6)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                }
            }
            .padding()
        }
        .sheet(isPresented: $isShowingAuth) {
            WebViewSheet()
        }
    }
}

#Preview {
    WelcomeView()
}
