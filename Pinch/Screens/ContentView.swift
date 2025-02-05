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
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen = false

    let pages = pagesData
    @State private var pageIndex = 1

    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex-1].imageName
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                
                // MARK: - PAGE IMAGE
                Image(currentPage())
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 12))
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded { _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
                    .gesture(
                        MagnifyGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value.magnification
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30),
                alignment: .top
            )
            .overlay(
                Group {
                    HStack {
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }

                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale >= 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 12))
                    .opacity(isAnimating ? 1 : 0)
                }.padding(.bottom, 30),
                alignment: .bottom
            )
            .overlay(
                HStackLayout(spacing: 12) {
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .clipShape(.rect(cornerRadius: 8))
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                                isDrawerOpen.toggle()
                                resetImageState()
                            }
                    }
                    
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 12))
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215),
                alignment: .topTrailing
            )
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
