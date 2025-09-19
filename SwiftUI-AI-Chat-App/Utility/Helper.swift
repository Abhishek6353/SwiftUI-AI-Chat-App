//
//  Helper.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 19/09/25.
//

import Foundation
struct InputValidator {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    static func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$&*]).{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
