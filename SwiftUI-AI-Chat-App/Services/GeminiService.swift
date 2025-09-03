//
//  GeminiService.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 03/09/25.
//

import Foundation

class GeminiService {
    private let apiKey = Config.geminiApiKey
    private let baseURL = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent")!
//    private let baseURL = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent")!

    
    func sendMessage(prompt: String) async throws -> String {
        // Build request
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        // Perform request
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode response
        let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
        return decoded.candidates.first?.content.parts.first?.text ?? "⚠️ No response"
    }
    
}
