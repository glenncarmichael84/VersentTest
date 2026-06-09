import SwiftUI

struct CarCardView: View {
    let car: Car

    var body: some View {
        HStack(spacing: 12) {
            thumbnailView

            VStack(alignment: .leading, spacing: 5) {
                Text(car.make + " " + car.model)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                    + (car.year.map { Text(" \($0)").font(.system(size: 15)).foregroundStyle(.secondary) } ?? Text(""))

                HStack(spacing: 6) {
                    BrandLogoView(make: car.make, size: 18)
                    Text(car.make)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    Text(coordinateString)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background.opacity(0.8))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        )
    }

    private var thumbnailView: some View {
        Group {
            if let urlStr = car.photoURLs.first, let url = URL(string: urlStr) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure, .empty:
                        placeholderThumb
                    @unknown default:
                        placeholderThumb
                    }
                }
            } else {
                placeholderThumb
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var placeholderThumb: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.secondary.opacity(0.15))
            .overlay {
                Image(systemName: "car.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.secondary.opacity(0.5))
            }
    }

    private var coordinateString: String {
        let lat = String(format: "%.2f", car.latitude)
        let lon = String(format: "%.2f", car.longitude)
        return "\(lat), \(lon)"
    }
}

#Preview {
    CarCardView(car: Car(
        id: "1",
        photoURLs: [],
        make: "BMW",
        model: "M3",
        year: 2023,
        latitude: -33.87,
        longitude: 151.21,
        capturedAt: Date(),
        capturedBy: "user1",
        interestingFact: nil
    ))
    .padding()
}
