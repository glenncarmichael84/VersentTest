import SwiftUI

struct StatCardView: View {
    let title: String
    let value: String
    var subtitle: String? = nil
    var icon: String? = nil
    var fullWidth: Bool = false

    var body: some View {
        Group {
            if #available(iOS 26, *) {
                cardContent
                    .glassEffect()
            } else {
                cardContent
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                Text(title.uppercased())
                    .font(.system(size: 11, weight: .semibold, design: .default))
                    .foregroundStyle(.secondary)
                    .kerning(0.5)
            }

            Text(value)
                .font(.system(size: fullWidth ? 28 : 24, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.7)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background.opacity(0.6))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        StatCardView(title: "Total Spotted", value: "42", subtitle: "cars in collection", icon: "car.fill")
        StatCardView(title: "Most Spotted", value: "BMW", subtitle: "12 cars", icon: "star.fill", fullWidth: true)
    }
    .padding()
}
