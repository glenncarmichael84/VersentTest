import Foundation

struct CarMake: Identifiable, Hashable {
    let id: String
    let name: String
    let models: [String]

    init(name: String, models: [String]) {
        self.id = name
        self.name = name
        self.models = models.sorted()
    }
}
