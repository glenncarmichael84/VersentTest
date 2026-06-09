import Foundation
import CoreLocation
import Observation

@Observable
class LocationService: NSObject, CLLocationManagerDelegate {
    var currentLocation: CLLocation?
    var authStatus: CLAuthorizationStatus = .notDetermined

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        authStatus = manager.authorizationStatus
    }

    func requestPermissionAndStart() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = manager.authorizationStatus
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, location.horizontalAccuracy >= 0 else { return }
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }

    func captureLocation() async throws -> (lat: Double, lon: Double) {
        if let location = currentLocation, location.horizontalAccuracy < 100 {
            return (location.coordinate.latitude, location.coordinate.longitude)
        }

        let timeout: Double = 10
        let start = Date()

        while Date().timeIntervalSince(start) < timeout {
            if let location = currentLocation, location.horizontalAccuracy >= 0 {
                return (location.coordinate.latitude, location.coordinate.longitude)
            }
            try await Task.sleep(nanoseconds: 500_000_000)
        }

        if let location = currentLocation {
            return (location.coordinate.latitude, location.coordinate.longitude)
        }

        throw LocationError.timeout
    }
}

enum LocationError: LocalizedError {
    case timeout
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .timeout:
            return "Could not obtain a GPS location in time."
        case .permissionDenied:
            return "Location permission denied."
        }
    }
}
