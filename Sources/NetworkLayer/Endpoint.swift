//
//  Endpoint.swift
//
//  Created by Alper Gok on 12.03.2025.
//


public protocol Endpoint: Sendable {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}


