import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit
import Observation

@Observable
class FirebaseService {
    var currentUserID: String?
    var cars: [Car] = []
    var isLoading = false

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    func signInAnonymously() async throws {
        let result = try await Auth.auth().signInAnonymously()
        currentUserID = result.user.uid
    }

    func fetchCars() async throws {
        guard let uid = currentUserID else { return }
        isLoading = true
        defer { isLoading = false }

        let snapshot = try await db
            .collection("users")
            .document(uid)
            .collection("cars")
            .getDocuments()

        let fetched = snapshot.documents.compactMap { doc -> Car? in
            carFromDocument(doc)
        }

        cars = fetched.sorted { $0.capturedAt > $1.capturedAt }
    }

    func addCar(_ car: Car, images: [UIImage]) async throws -> Car {
        guard let uid = currentUserID else {
            throw FirebaseServiceError.notAuthenticated
        }

        var uploadedURLs: [String] = []
        for (index, image) in images.enumerated() {
            let url = try await uploadImage(image, path: "users/\(uid)/cars/\(car.id)/photo_\(index).jpg")
            uploadedURLs.append(url)
        }

        var updatedCar = car
        updatedCar.photoURLs = uploadedURLs

        let data = carToDocument(updatedCar)
        try await db
            .collection("users")
            .document(uid)
            .collection("cars")
            .document(updatedCar.id)
            .setData(data)

        cars.insert(updatedCar, at: 0)
        return updatedCar
    }

    func addPhotos(to carID: String, images: [UIImage]) async throws -> [String] {
        guard let uid = currentUserID else {
            throw FirebaseServiceError.notAuthenticated
        }

        guard let index = cars.firstIndex(where: { $0.id == carID }) else {
            throw FirebaseServiceError.carNotFound
        }

        let existingCount = cars[index].photoURLs.count
        var newURLs: [String] = []

        for (i, image) in images.enumerated() {
            let url = try await uploadImage(
                image,
                path: "users/\(uid)/cars/\(carID)/photo_\(existingCount + i).jpg"
            )
            newURLs.append(url)
        }

        cars[index].photoURLs.append(contentsOf: newURLs)

        let data = carToDocument(cars[index])
        try await db
            .collection("users")
            .document(uid)
            .collection("cars")
            .document(carID)
            .setData(data)

        return newURLs
    }

    func deleteCar(_ carID: String) async throws {
        guard let uid = currentUserID else {
            throw FirebaseServiceError.notAuthenticated
        }

        try await db
            .collection("users")
            .document(uid)
            .collection("cars")
            .document(carID)
            .delete()

        cars.removeAll { $0.id == carID }
    }

    func updateCar(_ car: Car) async throws {
        guard let uid = currentUserID else {
            throw FirebaseServiceError.notAuthenticated
        }

        let data = carToDocument(car)
        try await db
            .collection("users")
            .document(uid)
            .collection("cars")
            .document(car.id)
            .setData(data)

        if let index = cars.firstIndex(where: { $0.id == car.id }) {
            cars[index] = car
        }
    }

    private func uploadImage(_ image: UIImage, path: String) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw FirebaseServiceError.imageConversionFailed
        }

        let ref = storage.reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await ref.putDataAsync(data, metadata: metadata)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }

    private func carToDocument(_ car: Car) -> [String: Any] {
        var data: [String: Any] = [
            "id": car.id,
            "photoURLs": car.photoURLs,
            "make": car.make,
            "model": car.model,
            "latitude": car.latitude,
            "longitude": car.longitude,
            "capturedAt": Timestamp(date: car.capturedAt),
            "capturedBy": car.capturedBy
        ]

        if let year = car.year {
            data["year"] = year
        }

        if let fact = car.interestingFact {
            data["interestingFact"] = fact
        }

        return data
    }

    private func carFromDocument(_ document: QueryDocumentSnapshot) -> Car? {
        let data = document.data()

        guard
            let id = data["id"] as? String,
            let photoURLs = data["photoURLs"] as? [String],
            let make = data["make"] as? String,
            let model = data["model"] as? String,
            let latitude = data["latitude"] as? Double,
            let longitude = data["longitude"] as? Double,
            let timestamp = data["capturedAt"] as? Timestamp,
            let capturedBy = data["capturedBy"] as? String
        else {
            return nil
        }

        return Car(
            id: id,
            photoURLs: photoURLs,
            make: make,
            model: model,
            year: data["year"] as? Int,
            latitude: latitude,
            longitude: longitude,
            capturedAt: timestamp.dateValue(),
            capturedBy: capturedBy,
            interestingFact: data["interestingFact"] as? String
        )
    }
}

enum FirebaseServiceError: LocalizedError {
    case notAuthenticated
    case carNotFound
    case imageConversionFailed

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "You are not signed in."
        case .carNotFound:
            return "Car not found in local collection."
        case .imageConversionFailed:
            return "Failed to convert image for upload."
        }
    }
}
