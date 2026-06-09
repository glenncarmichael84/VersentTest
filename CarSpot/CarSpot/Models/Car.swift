import Foundation
import CoreLocation

struct Car: Identifiable, Codable, Hashable {
    var id: String
    var photoURLs: [String]
    var make: String
    var model: String
    var year: Int?
    var latitude: Double
    var longitude: Double
    var capturedAt: Date
    var capturedBy: String
    var interestingFact: String?

    var displayName: String {
        if let year = year {
            return "\(year) \(make) \(model)"
        }
        return "\(make) \(model)"
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var hasFact: Bool {
        guard let fact = interestingFact else { return false }
        return !fact.isEmpty
    }
}
