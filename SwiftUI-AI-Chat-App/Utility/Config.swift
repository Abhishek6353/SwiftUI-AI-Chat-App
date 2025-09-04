//
//  Helper.swift
//  SwiftUI-AI-Chat-App
//
//  Created by Apple on 03/09/25.
//

import Foundation

struct Config {
    static var geminiApiKey: String {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let key = dict["GEMINI_API_KEY"] as? String {
            return key
        }
        fatalError("⚠️ GEMINI_API_KEY not set. Please create Config.plist from Config.plist.example")
    }
}
    