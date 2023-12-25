//
//  UnauthenticatedView.swift
//  ThrowAway
//
//  Created by Natik Gadzhi on 12/24/23.
//

import SwiftUI

struct UnauthenticatedView: View {
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        VStack {
            
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

            Button(action: {
                viewModel.isShowingAuth = true
            }, label: {
                Text("Login with Amazon")
                    .bold()
                    .padding(.horizontal, 20)
            })
            .buttonStyle(.borderedProminent)

            VStack(alignment: .leading) {
                Text("Scrapes does not log or store your account credentials anywhere.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

        }
        .sheet(isPresented: $viewModel.isShowingAuth) {
            WebViewSheet(viewModel: viewModel)
        }
    }
}

#Preview {
    UnauthenticatedView(viewModel: ViewModel())
}
