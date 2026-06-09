import Foundation
import GoogleGenerativeAI
import Observation

struct CarIdentification: Codable {
    let make: String
    let model: String
    let year: Int?
}

@Observable
class GeminiService {
    private let model: GenerativeModel

    init() {
        model = GenerativeModel(name: "gemini-1.5-flash", apiKey: Config.geminiAPIKey)
    }

    func identifyCar(imageData: Data) async throws -> CarIdentification {
        let prompt = "Identify this car. Respond ONLY with JSON: {\"make\":\"...\",\"model\":\"...\",\"year\":2020 or null}"
        let imageContent = ModelContent.Part.data(mimetype: "image/jpeg", imageData)
        let response = try await model.generateContent(prompt, imageContent)

        guard let text = response.text else {
            throw GeminiError.noResponse
        }

        let cleaned = extractJSON(from: text)
        let data = cleaned.data(using: .utf8) ?? Data()
        let identification = try JSONDecoder().decode(CarIdentification.self, from: data)
        return identification
    }

    func generateFact(make: String, model: String, year: Int?) async throws -> String {
        let yearPart = year.map { "\($0) " } ?? ""
        let prompt = "Give me ONE interesting fact about the \(yearPart)\(make) \(model) in 2-3 sentences. Be specific about history, performance, or unique characteristics."
        let response = try await self.model.generateContent(prompt)

        guard let text = response.text else {
            throw GeminiError.noResponse
        }

        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func extractJSON(from text: String) -> String {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let start = cleaned.firstIndex(of: "{"),
           let end = cleaned.lastIndex(of: "}") {
            return String(cleaned[start...end])
        }
        return cleaned
    }
}

enum GeminiError: LocalizedError {
    case noResponse
    case parseError

    var errorDescription: String? {
        switch self {
        case .noResponse:
            return "No response from Gemini."
        case .parseError:
            return "Could not parse Gemini response."
        }
    }
}
