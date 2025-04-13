//
//  APIConfiguration.swift
//
//  Created by Alper Gok on 12.03.2025.
//


public protocol APIConfiguration {
    var baseURL: String { get }
    var defaultHeaders: [String : String] { get }
}

//struct ProductionConfig: APIConfiguration {
//    let baseURL = "https://api.yourservice.com"
//    let defaultHeaders = [
//        "Accept": "application/json",
//        "Content-Type": "application/json"
//    ]
//}
