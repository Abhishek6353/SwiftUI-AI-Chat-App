//
//  LoginView.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var vm = LoginViewModel()
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Login")
                        .foregroundColor(.primaryText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 60)
                    
                    VStack(spacing: 20) {
                        
                        // Input Fields
                        FormTextField(placeholder: "Email", text: $vm.email, keyboardType: .emailAddress)
                        FormTextField(placeholder: "Password", text: $vm.password, isSecure: true)
                        
                        HStack {
                            Spacer()
                            NavigationLink {
                                ForgotPassswordView()
                            } label: {
                                Text("Forgot Password?")
                                    .font(.footnote)
                                    .foregroundColor(.primaryOrange)
                                
                            }
                        }
                        
                        // Error Message
                        if let error = vm.errorMessage {
                            HStack {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Spacer()
                            }
                        }


                        
                        // Login Button
                        Button(action: {
                            Task {
                                await vm.login()
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
                                Text("Login")
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
                        
                        
                        Spacer().frame(height: 10)
                        
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(.primaryText)
                            NavigationLink(destination: SignupView()) {
                                Text("Sign Up")
                                    .foregroundColor( vm.isLoading ? .primaryOrange.opacity(0.5) : .primaryOrange)
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
            .navigationDestination(isPresented: $vm.isLoggedIn) {
                HomeView()
            }
        }
    }
}

#Preview {
    LoginView()
}
