import SwiftUI

struct PhotoConfirmView: View {
    let image: UIImage
    let onConfirm: (UIImage) -> Void
    let onRetake: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .clipped()

            VStack {
                Spacer()
                actionBar
                    .background(.ultraThinMaterial)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    private var actionBar: some View {
        HStack(spacing: 16) {
            Button {
                onRetake()
            } label: {
                Text("Retake")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.primary.opacity(0.3), lineWidth: 1.5)
                    )
            }

            Button {
                onConfirm(image)
            } label: {
                HStack(spacing: 6) {
                    Text("Use Photo")
                    Image(systemName: "arrow.right")
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.blue, in: RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
}

#Preview {
    PhotoConfirmView(
        image: UIImage(systemName: "car.fill")!,
        onConfirm: { _ in },
        onRetake: {}
    )
}
