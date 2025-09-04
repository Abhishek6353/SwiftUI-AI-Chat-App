//
//  FormTextField.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import SwiftUI

struct FormTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(text: $text, prompt: Text(placeholder).foregroundColor(.primaryWhite.opacity(0.7))) {
                    EmptyView()
                }
            } else {
                TextField(text: $text, prompt: Text(placeholder).foregroundColor(.primaryWhite.opacity(0.7))) {
                    EmptyView()
                }

            }
        }
        .padding()
        .background(Color(.secondaryBackground))
        .foregroundColor(.primaryText)
        .cornerRadius(8)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primaryBorder, lineWidth: 2)
        })
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
    }
}

#Preview {
    FormTextField(placeholder: "Enter...", text: Binding<String>.constant(""), isSecure: false)
}
