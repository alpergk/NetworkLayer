//
//  NetworkManager.swift
//
//  Created by Alper Gok on 12.03.2025.
//
import Foundation

public final class NetworkManager {
    private let config: APIConfiguration
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(
        config: APIConfiguration,
        session: URLSession = {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30
            return URLSession(configuration: config)
        }(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.config = config
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlRequest = try buildRequest(for: endpoint)
        let (data, response) = try await session.data(for: urlRequest)
        try validate(response: response)
        return try decoder.decode(T.self, from: data)
    }
    
    // MARK: - Request Builder
    private func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        // 1. Construct URL
        let urlString = config.baseURL + endpoint.path
        guard var urlComponents = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // 2. Add query parameters for GET requests
        if endpoint.method == .get, let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        // 3. Create request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // 4. Add headers
        let allHeaders = config.defaultHeaders.merging(endpoint.headers ?? [:]) { $1 }
        request.allHTTPHeaderFields = allHeaders
        
        // 5. Add body for non-GET requests
        if endpoint.method != .get, let parameters = endpoint.parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
    
    // MARK: - Response Validation
    private func validate(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
    }
}


