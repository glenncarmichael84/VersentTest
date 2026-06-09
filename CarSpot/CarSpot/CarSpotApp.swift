import SwiftUI
import Firebase
import FirebaseAuth

@main
struct CarSpotApp: App {
    @State private var firebaseService = FirebaseService()
    @State private var locationService = LocationService()
    @State private var geminiService = GeminiService()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(firebaseService)
                .environment(locationService)
                .environment(geminiService)
                .task {
                    do {
                        try await firebaseService.signInAnonymously()
                        try await firebaseService.fetchCars()
                    } catch {
                        print("Firebase init error: \(error)")
                    }
                    locationService.requestPermissionAndStart()
                }
        }
    }
}
