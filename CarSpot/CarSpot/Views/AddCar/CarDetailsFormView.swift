import SwiftUI

struct CarDetailsFormView: View {
    @Bindable var viewModel: AddCarViewModel
    let firebaseService: FirebaseService
    let locationService: LocationService
    let onSave: () -> Void

    @State private var showMakePicker = false
    @State private var showModelPicker = false
    @State private var showExtraCamera = false
    @State private var makeSearchText = ""
    @State private var modelSearchText = ""
    @State private var saveError: String?

    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }

    private var years: [Int] {
        Array((1900...currentYear).reversed())
    }

    private var filteredMakes: [CarMake] {
        if makeSearchText.isEmpty {
            return allCarMakes
        }
        return allCarMakes.filter {
            $0.name.localizedCaseInsensitiveContains(makeSearchText)
        }
    }

    private var filteredModels: [String] {
        let models = make(named: viewModel.make)?.models ?? []
        if modelSearchText.isEmpty {
            return models
        }
        return models.filter { $0.localizedCaseInsensitiveContains(modelSearchText) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    photoStrip

                    if viewModel.isIdentifying {
                        identifyingSection
                    }

                    if !viewModel.isIdentifying {
                        carFieldsSection
                    }

                    if let error = viewModel.identificationError {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal, 16)
                    }

                    if let saveErr = saveError {
                        Text(saveErr)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Car Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isSaving {
                        ProgressView()
                            .scaleEffect(0.85)
                    } else {
                        Button("Save") {
                            Task { await save() }
                        }
                        .fontWeight(.semibold)
                        .disabled(viewModel.isIdentifying || viewModel.make.isEmpty)
                    }
                }
            }
            .sheet(isPresented: $showMakePicker) {
                makePickerSheet
            }
            .sheet(isPresented: $showModelPicker) {
                modelPickerSheet
            }
            .sheet(isPresented: $showExtraCamera) {
                CameraView(
                    onCapture: { image in
                        showExtraCamera = false
                        viewModel.capturedImages.append(image)
                    },
                    onCancel: {
                        showExtraCamera = false
                    }
                )
                .ignoresSafeArea()
            }
            .task {
                await viewModel.identifyCar()
            }
        }
    }

    // MARK: Photo Strip

    private var photoStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(viewModel.capturedImages.enumerated()), id: \.offset) { _, img in
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Button {
                    showExtraCamera = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.secondary.opacity(0.15))
                            .frame(width: 80, height: 80)
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
    }

    // MARK: Identifying

    private var identifyingSection: some View {
        HStack(spacing: 12) {
            ProgressView()
            Text("Identifying your car…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }

    // MARK: Fields

    private var carFieldsSection: some View {
        VStack(spacing: 0) {
            Divider()

            // Make row
            Button {
                makeSearchText = ""
                showMakePicker = true
            } label: {
                HStack {
                    Text("Make")
                        .foregroundStyle(.primary)
                    Spacer()
                    if viewModel.make.isEmpty {
                        Text("Select")
                            .foregroundStyle(.secondary)
                    } else {
                        HStack(spacing: 8) {
                            BrandLogoView(make: viewModel.make, size: 22)
                            Text(viewModel.make)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }

            Divider()
                .padding(.leading, 16)

            // Model row
            Button {
                modelSearchText = ""
                showModelPicker = true
            } label: {
                HStack {
                    Text("Model")
                        .foregroundStyle(.primary)
                    Spacer()
                    if viewModel.model.isEmpty {
                        Text("Select")
                            .foregroundStyle(.secondary)
                    } else {
                        Text(viewModel.model)
                            .foregroundStyle(.secondary)
                    }
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .disabled(viewModel.make.isEmpty)
            .opacity(viewModel.make.isEmpty ? 0.4 : 1.0)

            Divider()
                .padding(.leading, 16)

            // Year toggle
            HStack {
                Toggle("Year", isOn: $viewModel.hasYear)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
            }

            if viewModel.hasYear {
                Divider()
                    .padding(.leading, 16)

                Picker("Year", selection: $viewModel.selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 160)
                .clipped()
                .padding(.horizontal, 8)
            }

            Divider()
        }
        .background(Color(.systemBackground))
    }

    // MARK: Make Picker

    private var makePickerSheet: some View {
        NavigationStack {
            List {
                ForEach(filteredMakes, id: \.name) { carMake in
                    Button {
                        viewModel.make = carMake.name
                        viewModel.model = ""
                        showMakePicker = false
                    } label: {
                        HStack(spacing: 12) {
                            BrandLogoView(make: carMake.name, size: 28)
                            Text(carMake.name)
                                .foregroundStyle(.primary)
                            Spacer()
                            if viewModel.make == carMake.name {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $makeSearchText, prompt: "Search makes")
            .navigationTitle("Select Make")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showMakePicker = false
                    }
                }
            }
        }
    }

    // MARK: Model Picker

    private var modelPickerSheet: some View {
        NavigationStack {
            List {
                ForEach(filteredModels, id: \.self) { model in
                    Button {
                        viewModel.model = model
                        showModelPicker = false
                    } label: {
                        HStack {
                            Text(model)
                                .foregroundStyle(.primary)
                            Spacer()
                            if viewModel.model == model {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $modelSearchText, prompt: "Search models")
            .navigationTitle("Select Model")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showModelPicker = false
                    }
                }
            }
        }
    }

    // MARK: Save

    private func save() async {
        saveError = nil
        do {
            try await viewModel.save(
                firebaseService: firebaseService,
                locationService: locationService
            )
            onSave()
        } catch {
            saveError = error.localizedDescription
        }
    }
}

#Preview {
    let vm = AddCarViewModel(geminiService: GeminiService())
    vm.make = "Toyota"
    vm.model = "GR86"
    vm.hasYear = true
    vm.selectedYear = 2023
    return CarDetailsFormView(
        viewModel: vm,
        firebaseService: FirebaseService(),
        locationService: LocationService(),
        onSave: {}
    )
}
