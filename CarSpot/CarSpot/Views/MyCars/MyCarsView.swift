import SwiftUI

struct MyCarsView: View {
    @Environment(FirebaseService.self) private var firebaseService
    @Environment(LocationService.self) private var locationService
    @Environment(GeminiService.self) private var geminiService

    @State private var viewModel: MyCarsViewModel?
    @State private var showAddCar = false
    @State private var showFilterSheet = false
    @State private var selectedCar: Car? = nil

    var body: some View {
        NavigationStack {
            Group {
                if let vm = viewModel {
                    contentView(vm: vm)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("My Cars")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: filterIsActive(vm: viewModel) ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddCar = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                if let vm = viewModel {
                    filterSheet(vm: vm)
                }
            }
            .fullScreenCover(isPresented: $showAddCar) {
                AddCarFlow()
                    .environment(firebaseService)
                    .environment(locationService)
                    .environment(geminiService)
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = MyCarsViewModel(firebaseService: firebaseService)
            }
        }
    }

    @ViewBuilder
    private func contentView(vm: MyCarsViewModel) -> some View {
        if vm.filteredCars.isEmpty && vm.searchText.isEmpty && vm.selectedMakeFilter == nil {
            emptyStateView
        } else {
            @Bindable var vmBinding = vm
            ScrollView {
                LazyVStack(spacing: 10) {
                    if vm.filteredCars.isEmpty {
                        emptySearchState
                    } else {
                        ForEach(vm.filteredCars) { car in
                            Button {
                                selectedCar = car
                            } label: {
                                CarCardView(car: car)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    Task {
                                        try? await vm.deleteCar(car)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .searchable(text: $vmBinding.searchText, prompt: "Search make, model…")
            .navigationDestination(item: $selectedCar) { car in
                CarDetailView(car: car)
                    .environment(firebaseService)
                    .environment(geminiService)
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.fill")
                .font(.system(size: 72))
                .foregroundStyle(.secondary.opacity(0.4))
            VStack(spacing: 8) {
                Text("Start your collection")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                Text("Tap the + button to photograph and log your first spotted car.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Button {
                showAddCar = true
            } label: {
                Label("Add First Car", systemImage: "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue, in: Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptySearchState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("No results")
                .font(.headline)
            Text("Try adjusting your search or filters.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 60)
    }

    @ViewBuilder
    private func filterSheet(vm: MyCarsViewModel) -> some View {
        @Bindable var vmBinding = vm
        NavigationStack {
            Form {
                Section("Sort Order") {
                    Picker("Sort by", selection: $vmBinding.sortOrder) {
                        ForEach(SortOrder.allCases) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section("Filter by Make") {
                    Button("All Makes") {
                        vm.selectedMakeFilter = nil
                    }
                    .foregroundStyle(vm.selectedMakeFilter == nil ? .blue : .primary)

                    ForEach(vm.availableMakes, id: \.self) { make in
                        Button {
                            vm.selectedMakeFilter = make
                        } label: {
                            HStack {
                                BrandLogoView(make: make, size: 24)
                                Text(make)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if vm.selectedMakeFilter == make {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter & Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showFilterSheet = false
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func filterIsActive(vm: MyCarsViewModel?) -> Bool {
        guard let vm else { return false }
        return vm.selectedMakeFilter != nil || vm.sortOrder != .newest
    }
}

#Preview {
    MyCarsView()
        .environment(FirebaseService())
        .environment(LocationService())
        .environment(GeminiService())
}
