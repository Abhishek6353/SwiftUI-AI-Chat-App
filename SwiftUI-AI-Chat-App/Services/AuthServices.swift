//
//  AuthServices.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 04/09/25.
//

import Foundation
import FirebaseAuth

final class AuthServices {
    
    static let shared = AuthServices()
    
    private init() {}
    
    // MARK: - Sign Up
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    
    // MARK: - Login
    func logIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }   
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Logout
    func logOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Current User
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
}
