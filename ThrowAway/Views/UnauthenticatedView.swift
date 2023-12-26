//
//  UnauthenticatedView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI

struct UnauthenticatedView: View {
    
    @State var isShowingAuth = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Welcome to Scrapes")
                        .lineLimit(3)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 4)

                    Text("Scrapes, well, scrapes your Kindle highlights and notes.")
                        .lineLimit(3)
                        .padding(.bottom)
                }
                .padding(.bottom)

                HStack {
                    Spacer()
                    
                    Button(action: {
                        isShowingAuth = true
                    }, label: {
                        Text("Login with Amazon")
                            .bold()
                            .padding(.horizontal, 20)
                    })
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
                .padding(.bottom)

                VStack(alignment: .leading) {
                    Text("Unlike backend-driven SaaS services, Scrapes does not log or store your account credentials anywhere.")
                        .font(.caption)
                        .lineLimit(6)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 300)

        }
        .sheet(isPresented: $isShowingAuth) {
            WebViewSheet()
        }
    }
}

#Preview {
    UnauthenticatedView()
}
