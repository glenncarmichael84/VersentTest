import SwiftUI

struct MainTabView: View {
    @Environment(FirebaseService.self) private var firebaseService
    @Environment(LocationService.self) private var locationService
    @Environment(GeminiService.self) private var geminiService

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("My Cars", systemImage: "car.fill") {
                MyCarsView()
            }
            Tab("Friends", systemImage: "person.2.fill") {
                FriendsView()
            }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
        .environment(FirebaseService())
        .environment(LocationService())
        .environment(GeminiService())
}
