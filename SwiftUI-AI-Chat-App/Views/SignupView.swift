//
//  SignupView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import SwiftUI

struct SignupView: View {
    
    @StateObject private var vm = SignupViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ScrollView {
            VStack {
                Text("Sign Up")
                    .foregroundColor(.primaryText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 60)
                
                VStack(spacing: 20) {
                    
                    // Input Fields
                    FormTextField(placeholder: "Name", text: $vm.name)
                    FormTextField(placeholder: "Email", text: $vm.email)
                    FormTextField(placeholder: "Password", text: $vm.password, isSecure: true)
                    
                    // Error Message
                    if let error = vm.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(alignment: .trailing)
                    }
                    
                    
                    Spacer().frame(height: 10)
                    
                    // Sign Up Button
                    Button(action: {
                        Task {
                            await vm.signUp()
                        }
                    }) {
                        if vm.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(.primaryOrange)
                                .cornerRadius(10)
                        } else {
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .font(.system(size: 22))
                                .foregroundStyle(.primaryWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(.primaryOrange)
                                .cornerRadius(10)
                        }
                    }
                    
                    
                    Spacer().frame(height: 10)
                    
                    // Navigate back to Login
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.primaryText)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Login")
                                .foregroundColor(vm.isLoading ? .primaryOrange.opacity(0.5) : .primaryOrange)
                                .fontWeight(.bold)
                        }
                        .disabled(vm.isLoading)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 40)
                
                Spacer()
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
        .navigationBarHidden(true)
        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
    }
    
}

#Preview {
    SignupView()
}
