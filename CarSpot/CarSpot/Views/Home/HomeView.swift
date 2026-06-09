import SwiftUI

struct HomeView: View {
    @Environment(FirebaseService.self) private var firebaseService
    @State private var viewModel: HomeViewModel?

    private let gridColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if let vm = viewModel {
                    ScrollView {
                        VStack(spacing: 20) {
                            headerSection(vm: vm)
                            statsGrid(vm: vm)
                            topMakesSection(vm: vm)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("CarSpot")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }
            .overlay {
                if firebaseService.isLoading {
                    ProgressView()
                        .scaleEffect(1.2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = HomeViewModel(firebaseService: firebaseService)
            }
        }
    }

    @ViewBuilder
    private func headerSection(vm: HomeViewModel) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("CarSpot")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                Text("Your personal car collection")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 52, height: 52)
                VStack(spacing: 0) {
                    Text("\(vm.totalCars)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("cars")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
        }
        .padding(.top, 8)
    }

    @ViewBuilder
    private func statsGrid(vm: HomeViewModel) -> some View {
        LazyVGrid(columns: gridColumns, spacing: 12) {
            StatCardView(
                title: "Total Spotted",
                value: "\(vm.totalCars)",
                subtitle: vm.totalCars == 1 ? "car" : "cars",
                icon: "car.fill"
            )

            StatCardView(
                title: "Unique Makes",
                value: "\(vm.uniqueMakesCount)",
                subtitle: vm.uniqueMakesCount == 1 ? "brand" : "brands",
                icon: "rectangle.stack.fill"
            )

            StatCardView(
                title: "This Month",
                value: "\(vm.carsThisMonth)",
                subtitle: vm.carsThisMonth == 1 ? "spotted" : "spotted",
                icon: "calendar"
            )

            if let (rareMake, rareModel) = parseRarest(vm.raresCatch) {
                StatCardView(
                    title: "Rarest Find",
                    value: rareMake,
                    subtitle: rareModel,
                    icon: "binoculars.fill"
                )
            } else {
                StatCardView(
                    title: "Rarest Find",
                    value: "Keep hunting!",
                    subtitle: "spot more cars",
                    icon: "binoculars.fill"
                )
            }
        }

        if let popular = vm.mostPopularMake {
            mostSpottedCard(make: popular.make, count: popular.count)
        }

        if let recent = vm.recentCar {
            recentCarCard(car: recent)
        }
    }

    @ViewBuilder
    private func mostSpottedCard(make: String, count: Int) -> some View {
        Group {
            if #available(iOS 26, *) {
                mostSpottedContent(make: make, count: count)
                    .glassEffect()
            } else {
                mostSpottedContent(make: make, count: count)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private func mostSpottedContent(make: String, count: Int) -> some View {
        HStack(spacing: 12) {
            BrandLogoView(make: make, size: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text("MOST SPOTTED")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .kerning(0.5)
                Text(make)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Text("\(count) \(count == 1 ? "car" : "cars") spotted")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background.opacity(0.6))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
    }

    @ViewBuilder
    private func recentCarCard(car: Car) -> some View {
        Group {
            if #available(iOS 26, *) {
                recentCarContent(car: car)
                    .glassEffect()
            } else {
                recentCarContent(car: car)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private func recentCarContent(car: Car) -> some View {
        HStack(spacing: 12) {
            if let urlStr = car.photoURLs.first, let url = URL(string: urlStr) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.2))
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.secondary.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "car.fill")
                            .foregroundStyle(.secondary)
                    }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("LATEST CATCH")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .kerning(0.5)
                Text(car.displayName)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(1)
                Text(car.capturedAt, style: .relative)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background.opacity(0.6))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
    }

    @ViewBuilder
    private func topMakesSection(vm: HomeViewModel) -> some View {
        if !vm.topMakes.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Top Makes")
                    .font(.system(size: 20, weight: .bold, design: .rounded))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(vm.topMakes, id: \.make) { item in
                            topMakeChip(make: item.make, count: item.count)
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
        }
    }

    private func topMakeChip(make: String, count: Int) -> some View {
        VStack(spacing: 8) {
            BrandLogoView(make: make, size: 44)
            Text(make)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(1)
            ZStack {
                Capsule()
                    .fill(Color.blue)
                    .frame(height: 20)
                Text("\(count)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 36)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground).opacity(0.7))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
    }

    private func parseRarest(_ value: String?) -> (String, String)? {
        guard let value = value else { return nil }
        let parts = value.split(separator: " ", maxSplits: 1)
        if parts.count == 2 {
            return (String(parts[0]), String(parts[1]))
        } else if parts.count == 1 {
            return (String(parts[0]), "")
        }
        return nil
    }
}

#Preview {
    HomeView()
        .environment(FirebaseService())
        .environment(LocationService())
        .environment(GeminiService())
}
