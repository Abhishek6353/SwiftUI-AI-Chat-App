//
//  GeminiResponse.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 03/09/25.
//

import Foundation

struct GeminiResponse: Codable {
    let candidates: [Candidate]
}

struct Candidate: Codable {
    let content: Content
}

struct Content: Codable {
    let parts: [Part]
}

struct Part: Codable {
    let text: String?
}
