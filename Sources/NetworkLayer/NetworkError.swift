//
//  NetworkError.swift
//
//  Created by Alper Gok on 12.03.2025.
//
import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingFailed(Error)
    case noData
    case unknown(Error)
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid server response"
        case .statusCode(let code): return "HTTP \(code) error"
        case .decodingFailed(let error): return "Decoding failed: \(error.localizedDescription)"
        case .noData: return "No data received"
        case .unknown(let error): return "Unknown error: \(error.localizedDescription)"
        }
    }
}

