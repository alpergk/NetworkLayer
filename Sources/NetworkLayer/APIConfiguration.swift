//
//  APIConfiguration.swift
//  WeatherApp
//
//  Created by Alper Gok on 12.03.2025.
//

import Foundation

protocol APIConfiguration {
    var baseURL: String { get }
    var defaultHeaders: [String : String]? { get }
}
