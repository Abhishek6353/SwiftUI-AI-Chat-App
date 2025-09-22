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
        print(decoded.candidates.first?.content ?? "No response")
        return decoded.candidates.first?.content.parts.first?.text ?? "⚠️ No response"
    }
    
    func generateTitle(userMessage: String, aiReply: String) async throws -> String {
        let prompt = "Given the following conversation, generate a relevant topic title in 3-5 words. Only return the title, no explanation.\nUser: \(userMessage)\nGemini: \(aiReply)"
        return try await sendMessage(prompt: prompt)
    }
    
    // Streaming Gemini API response
    func streamMessage(prompt: String, onChunk: @escaping (String) -> Void, onComplete: @escaping (String) -> Void, onError: @escaping (Error) -> Void) {
        guard let streamURL = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:streamGenerateContent?key=\(apiKey)") else {
            onError(NSError(domain: "GeminiService", code:0, userInfo:[NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        var request = URLRequest(url: streamURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ]
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            onError(error)
            return
        }
        print("[DEBUG] Gemini prompt: \(prompt)")
        let handler = GeminiStreamHandler(onChunk: onChunk, onComplete: onComplete, onError: onError)
        let session = URLSession(configuration: .default, delegate: handler, delegateQueue: nil)
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    // Streaming handler for Gemini API
    private class GeminiStreamHandler: NSObject, URLSessionDataDelegate {
        private var buffer = Data()
        private let onChunk: (String) -> Void
        private let onComplete: (String) -> Void
        private let onError: (Error) -> Void
        private var fullText = ""
        
        init(onChunk: @escaping (String) -> Void, onComplete: @escaping (String) -> Void, onError: @escaping (Error) -> Void) {
            self.onChunk = onChunk
            self.onComplete = onComplete
            self.onError = onError
        }
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            buffer.append(data)
            // Try to parse as many JSON objects as possible from the buffer
            while let (object, remaining) = extractJSONObject(from: buffer) {
                buffer = remaining
                do {
                    let chunk = try JSONDecoder().decode(GeminiResponse.self, from: object)
                    if let text = chunk.candidates.first?.content.parts.first?.text {
                        fullText += text
                        onChunk(fullText)
                    }
                } catch {
                    // Ignore parse errors for incomplete objects
                }
            }
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error = error {
                onError(error)
            } else {
                onComplete(fullText)
            }
        }
        
        // Helper: Extracts a JSON object from the start of the data buffer
        private func extractJSONObject(from data: Data) -> (Data, Data)? {
            // Find the first complete JSON object (delimited by balanced braces)
            var depth = 0
            var start: Int? = nil
            for (i, byte) in data.enumerated() {
                if byte == UInt8(ascii: "{") {
                    if depth == 0 { start = i }
                    depth += 1
                } else if byte == UInt8(ascii: "}") {
                    depth -= 1
                    if depth == 0, let s = start {
                        let object = data.subdata(in: s..<i+1)
                        let remaining = data.advanced(by: i+1)
                        return (object, remaining)
                    }
                }
            }
            return nil
        }
    }
}
