//
//  Models.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 02/09/25.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool   // true = user, false = AI
}
