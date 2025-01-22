//
//  ContentView.swift
//  Pinch
//
//  Created by Bhavin Bhadani on 22/01/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - PAGE IMAGE
                Image("magazine-front-cover")
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 12))
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            imageScale = (imageScale == 1) ? 5 : 1
                        }
                    }
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
