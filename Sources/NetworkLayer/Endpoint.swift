//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Alper Gok on 12.03.2025.
//


import Foundation

public enum Endpoint: EndpointProtocol {
    case customRequest(config: APIConfiguration ,path: String, method: HTTPMethod, parameters: [String: Any]?, headers: [String: String]?)
    

    // MARK: -  BaseURL
    public var baseURL: String {
        switch self {
        case .customRequest(let config,_,_,_,_):
            return config.baseURL
        }
    }
    
    
    // MARK: -  Path
    public var path: String {
        switch self {
        case .customRequest(_,let path,_,_,_):
            return path
        }
    }
    
    // MARK: -  Parameters
    public var parameters: [String : Any]? {
        switch self {
        case .customRequest(_,_, _,let params, _):
            return params
            
        }
    }
    
    // MARK: -  Headers
    public var headers: [String: String]? {
        switch self {
        case .customRequest(let config, _, _,_, let customHeaders):
            return customHeaders ?? config.defaultHeaders
        }
    }
    
    // MARK: -  Methods
    public var method: HTTPMethod {
        switch self {
        case .customRequest(_, _, let method, _, _):
            return method
        }
        
    }
    
    
}
