# NetworkLayer

A simple and reusable network layer for Swift using `async/await`.

## Features
- Supports `GET`, `POST`, `PUT`, `DELETE`
- Uses `async/await` for modern Swift concurrency
- Lightweight and easy to integrate

## Installation
### Swift Package Manager (SPM)
1. Open Xcode and go to **File > Add Packages**.
2. Enter the GitHub URL (after pushing it).
3. Add it to your project.

## Usage

### 1. API Configuration (`WeatherAPIConfiguration.swift`)
```swift
import NetworkLayer

struct WeatherAPIConfiguration: APIConfiguration {
    var baseURL = "https://api.openweathermap.org/data/2.5"
    var defaultHeaders:[String: String]? = ["Content-Type": "application/json"]
}
```

### 2. Making a Network Request (`WeatherRequest.swift`)
```swift
import NetworkLayer

let endpoint = Endpoint.customRequest(
    config: WeatherAPIConfiguration(),
    path: "/weather",
    method: .get,
    parameters: ["q": "London"],
    headers: nil
)

Task {
    do {
        let weather: WeatherModel = try await NetworkManager.shared.request(endpoint: endpoint)
        print(weather)
    } catch {
        print(error)
    }
}
```


