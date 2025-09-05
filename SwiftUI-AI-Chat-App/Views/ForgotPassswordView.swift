//
//  ForgotPassswordView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 05/09/25.
//

import SwiftUI

struct ForgotPassswordView: View {
    
    @StateObject private var vm = ForgotPasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.white)
                    
                }
                .frame(width: 40, height: 40)
                .background(.secondaryBackground)
                .clipShape(.circle)
                Spacer()
            }
            
            Text("Forgot Password")
                .foregroundColor(.primaryText)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                
                // Input Fields
                FormTextField(placeholder: "Email", text: $vm.email, keyboardType: .emailAddress)
                
                // Error Message
                if let error = vm.errorMessage {
                    HStack {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                        Spacer()
                    }
                }
                
                // Success Message
                if vm.isEmailSent {
                    HStack {
                        Text("Password reset email has been sent. Please check your inbox. If you don’t see the email, check your spam/junk folder.")
                            .foregroundColor(.green)
                            .font(.caption)
                        Spacer()
                    }
                }
                
                
                // Reset Password Button
                Button(action: {
                    Task {
                        await vm.resetPassword()
                    }
                }) {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundStyle(.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(.primaryOrange)
                            .cornerRadius(10)
                    } else {
                        Text("Reset Password")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .foregroundStyle(.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(.primaryOrange)
                            .cornerRadius(10)
                    }
                }
                .disabled(vm.isLoading)
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 25)
//        .padding(.top, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
        .navigationBarHidden(true)
        .onChange(of: vm.isEmailSent) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    dismiss()
                })
            }
        }
    }
}

#Preview {
    ForgotPassswordView()
}
