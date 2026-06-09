import SwiftUI

struct BrandLogoView: View {
    let make: String
    var size: CGFloat = 40

    var body: some View {
        AsyncImage(url: logoURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
            case .failure, .empty:
                fallbackBadge
            @unknown default:
                fallbackBadge
            }
        }
        .frame(width: size, height: size)
    }

    private var logoURL: URL? {
        let slug = slugify(make: make)
        return URL(string: "https://www.carlogos.org/car-logos/\(slug)-logo.png")
    }

    private var fallbackBadge: some View {
        Circle()
            .fill(brandColor(for: make))
            .frame(width: size, height: size)
            .overlay(
                Text(abbreviation(for: make))
                    .font(.system(size: size * 0.35, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            )
    }

    private func abbreviation(for make: String) -> String {
        let words = make.split(separator: " ").map { String($0) }
        if words.count >= 2 {
            let first = words[0].prefix(1)
            let second = words[1].prefix(1)
            return "\(first)\(second)".uppercased()
        }
        return String(make.prefix(2)).uppercased()
    }

    func slugify(make: String) -> String {
        make
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "é", with: "e")
            .replacingOccurrences(of: "ë", with: "e")
            .replacingOccurrences(of: "ü", with: "u")
            .replacingOccurrences(of: "ä", with: "a")
            .replacingOccurrences(of: "ö", with: "o")
            .filter { $0.isLetter || $0.isNumber || $0 == "-" }
    }

    func brandColor(for make: String) -> Color {
        switch make.lowercased() {
        case "bmw":
            return Color(red: 0.0, green: 0.47, blue: 0.85)
        case "ferrari":
            return Color(red: 0.83, green: 0.07, blue: 0.07)
        case "mercedes-benz", "mercedes":
            return Color(red: 0.37, green: 0.37, blue: 0.37)
        case "toyota":
            return Color(red: 0.78, green: 0.08, blue: 0.08)
        case "honda":
            return Color(red: 0.80, green: 0.09, blue: 0.09)
        case "ford":
            return Color(red: 0.0, green: 0.30, blue: 0.66)
        case "chevrolet":
            return Color(red: 0.82, green: 0.63, blue: 0.11)
        case "audi":
            return Color(red: 0.87, green: 0.05, blue: 0.05)
        case "volkswagen":
            return Color(red: 0.10, green: 0.27, blue: 0.60)
        case "porsche":
            return Color(red: 0.71, green: 0.07, blue: 0.07)
        case "lamborghini":
            return Color(red: 0.95, green: 0.67, blue: 0.0)
        case "maserati":
            return Color(red: 0.0, green: 0.42, blue: 0.65)
        case "bugatti":
            return Color(red: 0.0, green: 0.18, blue: 0.55)
        case "rolls-royce", "rolls royce":
            return Color(red: 0.45, green: 0.40, blue: 0.35)
        case "bentley":
            return Color(red: 0.20, green: 0.40, blue: 0.25)
        case "tesla":
            return Color(red: 0.87, green: 0.13, blue: 0.13)
        case "jaguar":
            return Color(red: 0.20, green: 0.55, blue: 0.30)
        case "land rover":
            return Color(red: 0.0, green: 0.38, blue: 0.22)
        case "lexus":
            return Color(red: 0.62, green: 0.50, blue: 0.35)
        case "infiniti":
            return Color(red: 0.25, green: 0.25, blue: 0.25)
        case "acura":
            return Color(red: 0.70, green: 0.07, blue: 0.07)
        case "alfa romeo":
            return Color(red: 0.72, green: 0.06, blue: 0.06)
        case "aston martin":
            return Color(red: 0.0, green: 0.42, blue: 0.35)
        case "subaru":
            return Color(red: 0.0, green: 0.28, blue: 0.67)
        case "mazda":
            return Color(red: 0.73, green: 0.06, blue: 0.06)
        case "nissan":
            return Color(red: 0.73, green: 0.07, blue: 0.07)
        case "hyundai":
            return Color(red: 0.0, green: 0.30, blue: 0.65)
        case "kia":
            return Color(red: 0.15, green: 0.15, blue: 0.15)
        case "volvo":
            return Color(red: 0.0, green: 0.32, blue: 0.61)
        case "peugeot":
            return Color(red: 0.15, green: 0.15, blue: 0.50)
        case "renault":
            return Color(red: 0.87, green: 0.60, blue: 0.0)
        case "citroën", "citroen":
            return Color(red: 0.87, green: 0.32, blue: 0.0)
        case "fiat":
            return Color(red: 0.68, green: 0.05, blue: 0.05)
        case "cadillac":
            return Color(red: 0.40, green: 0.55, blue: 0.72)
        case "lincoln":
            return Color(red: 0.15, green: 0.15, blue: 0.15)
        case "dodge":
            return Color(red: 0.65, green: 0.05, blue: 0.05)
        case "chrysler":
            return Color(red: 0.30, green: 0.35, blue: 0.65)
        case "jeep":
            return Color(red: 0.40, green: 0.55, blue: 0.30)
        case "ram":
            return Color(red: 0.60, green: 0.07, blue: 0.07)
        case "gmc":
            return Color(red: 0.55, green: 0.57, blue: 0.60)
        case "buick":
            return Color(red: 0.15, green: 0.38, blue: 0.55)
        case "genesis":
            return Color(red: 0.20, green: 0.20, blue: 0.20)
        case "mini":
            return Color(red: 0.0, green: 0.0, blue: 0.0)
        case "mitsubishi":
            return Color(red: 0.75, green: 0.07, blue: 0.07)
        case "mclaren":
            return Color(red: 0.92, green: 0.43, blue: 0.0)
        case "pagani":
            return Color(red: 0.40, green: 0.30, blue: 0.20)
        case "lotus":
            return Color(red: 0.80, green: 0.65, blue: 0.0)
        case "rivian":
            return Color(red: 0.0, green: 0.60, blue: 0.50)
        default:
            return Color(red: 0.40, green: 0.40, blue: 0.45)
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        BrandLogoView(make: "BMW", size: 50)
        BrandLogoView(make: "Ferrari", size: 50)
        BrandLogoView(make: "Tesla", size: 50)
        BrandLogoView(make: "Unknown Make", size: 50)
    }
    .padding()
}
