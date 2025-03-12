//
//  NetworkResponse.swift
//  WeatherApp
//
//  Created by Alper Gok on 12.03.2025.
//

import Foundation

struct NetworkResponse<T: Decodable>: Decodable {
    let status: Int?
    let message: String?
    let data: T?
}
