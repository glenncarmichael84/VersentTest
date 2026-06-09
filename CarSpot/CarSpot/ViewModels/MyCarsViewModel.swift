import Foundation
import Observation

enum SortOrder: String, CaseIterable, Identifiable {
    case newest = "Newest First"
    case oldest = "Oldest First"
    case makeAZ = "Make A–Z"

    var id: String { rawValue }
}

@Observable
class MyCarsViewModel {
    var searchText = ""
    var selectedMakeFilter: String? = nil
    var sortOrder: SortOrder = .newest

    private let firebaseService: FirebaseService

    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }

    var filteredCars: [Car] {
        var result = firebaseService.cars

        if let makeFilter = selectedMakeFilter, !makeFilter.isEmpty {
            result = result.filter { $0.make == makeFilter }
        }

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                $0.make.lowercased().contains(query) ||
                $0.model.lowercased().contains(query) ||
                (($0.year.map { String($0) }) ?? "").contains(query)
            }
        }

        switch sortOrder {
        case .newest:
            result.sort { $0.capturedAt > $1.capturedAt }
        case .oldest:
            result.sort { $0.capturedAt < $1.capturedAt }
        case .makeAZ:
            result.sort {
                let makeCmp = $0.make.localizedCompare($1.make)
                if makeCmp != .orderedSame { return makeCmp == .orderedAscending }
                return $0.model.localizedCompare($1.model) == .orderedAscending
            }
        }

        return result
    }

    var availableMakes: [String] {
        Array(Set(firebaseService.cars.map { $0.make })).sorted()
    }

    func deleteCar(_ car: Car) async throws {
        try await firebaseService.deleteCar(car.id)
    }
}
