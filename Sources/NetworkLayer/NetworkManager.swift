//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Alper Gok on 12.03.2025.
//

import Foundation
import os



@available(iOS 14.0, *)
@available(macOS 11.0, *)
public actor NetworkManager {
    public static let shared = NetworkManager()
    private let decoder: JSONDecoder
    private var logger = Logger(subsystem: "unknwnCorp.WeatherApp", category: "Networking")
    
    private init() {
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func request<T: Codable>(endpoint: Endpoint) async throws -> T {
        
        // MARK: -  Components
        guard var components = URLComponents(string: endpoint.baseURL + endpoint.path) else {
            logger.error("❌ Invalid URL: \(endpoint.baseURL + endpoint.path)")
            throw NetworkError.invalidURL
        }
        
        // MARK: -  Parameters (For GET Request)
        if endpoint.method == .get, let parameters = endpoint.parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
        }
        
        // MARK: -  Final URL
        guard let url = components.url else {
            logger.error("❌ Failed to create valid URL from components")
            throw NetworkError.invalidURL
        }
        logger.info("🌍 Request URL: \(url.absoluteString)")
        
        // MARK: -  Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        
        // MARK: -  Request Body for (POST, PUT, DELETE)
        if endpoint.method != .get, let parameters = endpoint.parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                logger.info("📦 Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "Empty")")
            } catch {
                logger.error("❌ Failed to encode request body")
                throw NetworkError.decodingError
            }
        }
        
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("❌ Invalid server response")
                throw NetworkError.noData
            }
            logger.info("✅ Response Status Code: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                logger.error("❌ Request failed with status code: \(httpResponse.statusCode)")
                throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
            }
            
            logger.info("📥 Received Data: \(String(data: data, encoding: .utf8) ?? "Unreadable")")
            
            return try decoder.decode(T.self, from: data)
            
        }  catch {
            logger.error("❌ Network/Decoding Error: \(error.localizedDescription)")
            throw NetworkError.unknown(error)
        }
    }
}




