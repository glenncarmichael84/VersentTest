import Foundation
import Observation

@Observable
class HomeViewModel {
    private let firebaseService: FirebaseService

    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }

    var totalCars: Int {
        firebaseService.cars.count
    }

    var mostPopularMake: (make: String, count: Int)? {
        guard !firebaseService.cars.isEmpty else { return nil }
        let counts = makeCounts()
        return counts.max(by: { $0.value < $1.value }).map { ($0.key, $0.value) }
    }

    var uniqueMakesCount: Int {
        Set(firebaseService.cars.map { $0.make }).count
    }

    var carsThisMonth: Int {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)
        guard let start = calendar.date(from: components) else { return 0 }
        return firebaseService.cars.filter { $0.capturedAt >= start }.count
    }

    var raresCatch: String? {
        let counts = makeModelCounts()
        let once = counts.filter { $0.value == 1 }.map { $0.key }
        return once.first
    }

    var recentCar: Car? {
        firebaseService.cars.first
    }

    var topMakes: [(make: String, count: Int)] {
        let counts = makeCounts()
        return counts
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { (make: $0.key, count: $0.value) }
    }

    private func makeCounts() -> [String: Int] {
        var counts: [String: Int] = [:]
        for car in firebaseService.cars {
            counts[car.make, default: 0] += 1
        }
        return counts
    }

    private func makeModelCounts() -> [String: Int] {
        var counts: [String: Int] = [:]
        for car in firebaseService.cars {
            let key = "\(car.make) \(car.model)"
            counts[key, default: 0] += 1
        }
        return counts
    }
}
