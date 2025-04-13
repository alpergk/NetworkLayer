# NetworkLayer

A generic, reusable network layer for Swift using modern concurrency (`async/await`) with full testability support.

## Features
- **True Generic Design**: Works with any API (weather, social, e-commerce)
- **Protocol-Driven Architecture**: Easy to mock and test
- **Modern Concurrency**: Built with `async/await`
- **Environment Support**: Multiple configurations (prod, staging)
- **Full Error Handling**: Typed network errors

## Installation
### Swift Package Manager (SPM)
1. In Xcode: **File > Add Packages**
2. Paste your GitHub repository URL
3. Select your project target

## Usage

### 1. Define API Configuration
```swift
import NetworkLayer

struct WeatherAPIConfig: APIConfiguration {
    let baseURL = "https://api.openweathermap.org/data/2.5"
    let defaultHeaders = ["Content-Type": "application/json"]
}
```

### 2. Create Endpoints
```swift
import NetworkLayer

struct CityWeatherEndpoint: Endpoint {
    let path: String
    let method: HTTPMethod
    let parameters: [String: Any]?
    let headers: [String: String]?
    
    init(city: String, appId: String) {
        path = "/weather"
        method = .get
        parameters = [
            "q": city,
            "appid": appId,
            "units": "metric"
        ]
        headers = nil // Uses default headers from config
    }
}
```

### 3. Make Network Request
```swift
import NetworkLayer

// Initialize with your configuration
let config = WeatherAPIConfig()
let networkManager = NetworkManager(config: config)

Task {
    do {
        let weather: WeatherResponse = try await networkManager.request(
            CityWeatherEndpoint(city: "London", appId: "YOUR_API_KEY")
        )
        print("Current temperature: \(weather.main.temp)°C")
    } catch let error as NetworkError {
        print("Network error: \(error.localizedDescription)")
    } catch {
        print("Unexpected error: \(error)")
    }
}
```

### 4. Error Handling
```swift 
do {
    // Request...
} catch NetworkError.invalidURL {
    showAlert("Invalid request URL")
} catch NetworkError.statusCode(let code) where code == 401 {
    handleUnauthorizedError()
} catch NetworkError.decodingFailed(let error) {
    print("Decoding failed: \(error)")
}
```

## Advanced Usage

### Handle Different Environments
```swift
// Production config
struct ProdConfig: APIConfiguration {
    let baseURL = "https://api.prod.com"
    let defaultHeaders = ["Authorization": "Bearer PROD_TOKEN"]
}

// Staging config
struct StagingConfig: APIConfiguration {
    let baseURL = "https://api.staging.com"
    let defaultHeaders = [:]
}

// Initialize with environment
#if DEBUG
let config = StagingConfig()
#else
let config = ProdConfig()
#endif

let networkManager = NetworkManager(config: config)
```
