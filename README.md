# BasicLocationTT

## Project Notes

### Device / Simulator Used

- Simulator: iPhone 17 Pro
- iOS version: iOS 26.4
- Project deployment target: iOS 26.4

### Weather API

This project uses the Open-Meteo Forecast API:

`https://api.open-meteo.com/v1/forecast`

Required query parameters used by the app:

- `latitude`: latitude from Core Location
- `longitude`: longitude from Core Location
- `current_weather=true`: requests the current weather object
- `temperature_unit=fahrenheit`: returns temperature in Fahrenheit
- `windspeed_unit=mph`: returns wind speed in miles per hour
- `timezone=auto`: lets Open-Meteo choose the timezone from the coordinate

### URL Construction

The weather request URL is built with `URLComponents` in `WeatherService`. The app sets the scheme, host, and path, then adds each parameter as a `URLQueryItem`:

```swift
var components = URLComponents()
components.scheme = "https"
components.host = "api.open-meteo.com"
components.path = "/v1/forecast"
components.queryItems = [
    URLQueryItem(name: "latitude", value: String(coordinate.latitude)),
    URLQueryItem(name: "longitude", value: String(coordinate.longitude)),
    URLQueryItem(name: "current_weather", value: "true"),
    URLQueryItem(name: "temperature_unit", value: "fahrenheit"),
    URLQueryItem(name: "windspeed_unit", value: "mph"),
    URLQueryItem(name: "timezone", value: "auto")
]
```

### MVVM Structure

The app uses a simple MVVM structure:

- Models: `CheckIn` and `WeatherModel` hold app data.
- Views: `ContentView`, `LocationReadyView`, and `PermissionView` display the UI and call view model actions.
- ViewModels: `LocationViewModel` manages location state and formatted coordinates, while `WeatherViewModel` manages weather loading, refresh behavior, and error messages.
- Services: `LocationService` wraps `CLLocationManager`, and `WeatherService` builds the API request, calls Open-Meteo, decodes the response, and maps weather codes into readable summaries.
