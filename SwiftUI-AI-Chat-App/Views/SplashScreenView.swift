//
//  SplashScreenView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 01/09/25.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            if authVM.isLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
            
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.primaryBackground)
            .ignoresSafeArea()
            .task {
                try? await Task.sleep(for: .seconds(1.1))
                withAnimation { isActive = true }
            }
        }
    }
}


#Preview {
    SplashScreenView()
        .environmentObject(AuthViewModel())
}
