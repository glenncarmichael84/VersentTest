import SwiftUI

enum AddCarStep: Identifiable {
    case camera
    case confirm(UIImage)
    case details([UIImage])

    var id: String {
        switch self {
        case .camera:
            return "camera"
        case .confirm:
            return "confirm"
        case .details:
            return "details"
        }
    }
}

struct AddCarFlow: View {
    @Environment(FirebaseService.self) private var firebaseService
    @Environment(LocationService.self) private var locationService
    @Environment(GeminiService.self) private var geminiService
    @Environment(\.dismiss) private var dismiss

    @State private var step: AddCarStep = .camera
    @State private var viewModel: AddCarViewModel?

    var body: some View {
        Group {
            switch step {
            case .camera:
                CameraView(
                    onCapture: { image in
                        step = .confirm(image)
                    },
                    onCancel: {
                        dismiss()
                    }
                )
                .ignoresSafeArea()

            case .confirm(let image):
                PhotoConfirmView(
                    image: image,
                    onConfirm: { confirmedImage in
                        let vm = AddCarViewModel(geminiService: geminiService)
                        vm.capturedImages = [confirmedImage]
                        viewModel = vm
                        step = .details([confirmedImage])
                    },
                    onRetake: {
                        step = .camera
                    }
                )
                .ignoresSafeArea()

            case .details:
                if let vm = viewModel {
                    CarDetailsFormView(
                        viewModel: vm,
                        firebaseService: firebaseService,
                        locationService: locationService,
                        onSave: {
                            dismiss()
                        }
                    )
                } else {
                    ProgressView()
                }
            }
        }
    }
}
