//
//  NetworkResponse.swift
//  WeatherApp
//
//  Created by Alper Gok on 12.03.2025.
//

import Foundation

public struct NetworkResponse<T: Decodable>: Decodable {
    public let status: Int?
    public let message: String?
    public let data: T?
}
