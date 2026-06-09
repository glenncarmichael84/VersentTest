import SwiftUI
import MapKit

struct CarDetailView: View {
    @State var car: Car

    @Environment(FirebaseService.self) private var firebaseService
    @Environment(GeminiService.self) private var geminiService
    @Environment(\.dismiss) private var dismiss

    @State private var showDeleteAlert = false
    @State private var showAddPhotoCamera = false
    @State private var currentPhotoPage = 0
    @State private var isFetchingFact = false
    @State private var deleteError: String?

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMMM yyyy 'at' h:mm a"
        return f
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                photoCarousel
                    .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 20) {
                    headerSection

                    factSection

                    mapSection

                    capturedDateSection

                    deleteSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(car.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Car", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task { await deleteCar() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Remove \(car.displayName) from your collection? This cannot be undone.")
        }
        .sheet(isPresented: $showAddPhotoCamera) {
            CameraView(
                onCapture: { image in
                    showAddPhotoCamera = false
                    Task { await appendPhoto(image) }
                },
                onCancel: {
                    showAddPhotoCamera = false
                }
            )
            .ignoresSafeArea()
        }
        .task {
            if !car.hasFact {
                await fetchFact()
            }
        }
    }

    // MARK: Photo Carousel

    private var photoCarousel: some View {
        ZStack(alignment: .bottomTrailing) {
            if car.photoURLs.isEmpty {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.15))
                    Image(systemName: "car.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .clipped()
            } else {
                TabView(selection: $currentPhotoPage) {
                    ForEach(Array(car.photoURLs.enumerated()), id: \.offset) { index, urlStr in
                        if let url = URL(string: urlStr) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .failure, .empty:
                                    ZStack {
                                        Rectangle().fill(Color.secondary.opacity(0.15))
                                        Image(systemName: "photo")
                                            .font(.system(size: 40))
                                            .foregroundStyle(.secondary)
                                    }
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .tag(index)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 320)
                .clipped()
                .overlay(alignment: .bottom) {
                    if car.photoURLs.count > 1 {
                        pageDotsOverlay
                    }
                }
            }

            addPhotoButton
                .padding(16)
        }
    }

    private var pageDotsOverlay: some View {
        HStack(spacing: 6) {
            ForEach(0..<car.photoURLs.count, id: \.self) { index in
                Circle()
                    .fill(index == currentPhotoPage ? Color.white : Color.white.opacity(0.5))
                    .frame(width: index == currentPhotoPage ? 8 : 6,
                           height: index == currentPhotoPage ? 8 : 6)
                    .animation(.easeInOut(duration: 0.2), value: currentPhotoPage)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(.ultraThinMaterial, in: Capsule())
        .padding(.bottom, 12)
    }

    private var addPhotoButton: some View {
        Button {
            showAddPhotoCamera = true
        } label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 34))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: Header

    private var headerSection: some View {
        HStack(spacing: 14) {
            BrandLogoView(make: car.make, size: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(car.make)
                    .font(.headline)
                Text(car.model)
                    .font(.title2)
                    .fontWeight(.bold)
                if let year = car.year {
                    Text(String(year))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        )
    }

    // MARK: Fact Section

    private var factSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Interesting Fact", systemImage: "lightbulb.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.orange)

            if isFetchingFact {
                HStack {
                    ProgressView()
                        .scaleEffect(0.85)
                    Text("Fetching fact…")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else if let fact = car.interestingFact, !fact.isEmpty {
                Text(fact)
                    .font(.callout)
                    .italic()
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("No fact available.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        )
    }

    // MARK: Map Section

    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Spotted At", systemImage: "map.fill")
                .font(.system(size: 15, weight: .semibold))

            Map(initialPosition: .region(MKCoordinateRegion(
                center: car.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))) {
                Annotation("", coordinate: car.coordinate) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 28, height: 28)
                        Image(systemName: "car.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .disabled(true)
        }
    }

    // MARK: Captured Date

    private var capturedDateSection: some View {
        HStack(spacing: 10) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text("Captured")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(Self.dateFormatter.string(from: car.capturedAt))
                    .font(.subheadline)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        )
    }

    // MARK: Delete

    private var deleteSection: some View {
        VStack(spacing: 8) {
            if let error = deleteError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("Delete from Collection", systemImage: "trash")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.red.opacity(0.1))
                    )
            }
        }
    }

    // MARK: Actions

    private func fetchFact() async {
        guard !car.hasFact else { return }
        isFetchingFact = true
        do {
            let fact = try await geminiService.generateFact(
                make: car.make,
                model: car.model,
                year: car.year
            )
            car.interestingFact = fact
            var updated = car
            updated.interestingFact = fact
            try await firebaseService.updateCar(updated)
            car = updated
        } catch {
            // Silently fail; fact stays nil
        }
        isFetchingFact = false
    }

    private func appendPhoto(_ image: UIImage) async {
        do {
            let newURLs = try await firebaseService.addPhotos(to: car.id, images: [image])
            car.photoURLs.append(contentsOf: newURLs)
        } catch {
            // Silently fail; user can try again
        }
    }

    private func deleteCar() async {
        do {
            try await firebaseService.deleteCar(car.id)
            dismiss()
        } catch {
            deleteError = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        CarDetailView(car: Car(
            id: "preview",
            photoURLs: [],
            make: "Porsche",
            model: "911",
            year: 2022,
            latitude: -33.8688,
            longitude: 151.2093,
            capturedAt: Date(),
            capturedBy: "user1",
            interestingFact: "The Porsche 911 has been in continuous production since 1963, making it one of the longest-running sports cars in automotive history."
        ))
        .environment(FirebaseService())
        .environment(GeminiService())
    }
}
