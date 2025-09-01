//
//  SplashScreenView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 01/09/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            HomeView() // 👈 your main app view
        } else {
            VStack() {
                Image("logo") // Replace with your logo
                    .resizable()
                    .frame(width: 300, height: 300)
                    .background(.primaryBackground)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0)) {
                            self.scale = 1.2
                            self.opacity = 1.0
                        }
                    }
            }
            .onAppear {
                // Switch to main view after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.primaryBackground)
            .ignoresSafeArea()
        }
    }
}


#Preview {
    SplashScreenView()
}
