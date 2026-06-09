import SwiftUI

struct FriendsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                Image(systemName: "person.2.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.secondary)

                Text("Coming Soon")
                    .font(.title2)
                    .bold()

                Text("Share your collection and see your friends' spotted cars.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()
            }
            .padding(32)
            .navigationTitle("Friends")
        }
    }
}

#Preview {
    FriendsView()
}
