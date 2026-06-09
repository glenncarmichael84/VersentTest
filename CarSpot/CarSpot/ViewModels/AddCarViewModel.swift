import Foundation
import UIKit
import Observation

@Observable
class AddCarViewModel {
    var capturedImages: [UIImage] = []
    var make: String = ""
    var model: String = ""
    var year: Int? = nil
    var isIdentifying = false
    var identificationError: String? = nil
    var isSaving = false
    var showMakePicker = false
    var showModelPicker = false
    var showYearPicker = false
    var selectedYear: Int = Calendar.current.component(.year, from: Date())
    var hasYear = false

    private let geminiService: GeminiService

    init(geminiService: GeminiService) {
        self.geminiService = geminiService
    }

    func identifyCar() async {
        guard let firstImage = capturedImages.first,
              let imageData = firstImage.jpegData(compressionQuality: 0.8) else {
            return
        }

        isIdentifying = true
        identificationError = nil

        do {
            let identification = try await geminiService.identifyCar(imageData: imageData)
            make = identification.make
            model = identification.model
            if let y = identification.year {
                year = y
                selectedYear = y
                hasYear = true
            }
        } catch {
            identificationError = error.localizedDescription
            make = "Unknown"
            model = "Unknown"
        }

        isIdentifying = false
    }

    func save(firebaseService: FirebaseService, locationService: LocationService) async throws {
        isSaving = true
        defer { isSaving = false }

        let coords = try await locationService.captureLocation()

        let carID = UUID().uuidString
        let finalYear: Int? = hasYear ? selectedYear : year

        let car = Car(
            id: carID,
            photoURLs: [],
            make: make.isEmpty ? "Unknown" : make,
            model: model.isEmpty ? "Unknown" : model,
            year: finalYear,
            latitude: coords.lat,
            longitude: coords.lon,
            capturedAt: Date(),
            capturedBy: firebaseService.currentUserID ?? "",
            interestingFact: nil
        )

        _ = try await firebaseService.addCar(car, images: capturedImages)
    }
}
