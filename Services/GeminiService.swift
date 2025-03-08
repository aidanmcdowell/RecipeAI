import Foundation
import GoogleGenerativeAI

class GeminiService {
    static let shared = GeminiService()
    
    // Replace with your actual API key
    private let apiKey = "YOUR_GEMINI_API_KEY_HERE"
    private var model: GenerativeModel
    
    private init() {
        // Initialize the Gemini model with API key
        model = GenerativeModel(
            name: "gemini-2.0-flash",
            apiKey: apiKey
        )
    }
    
    // Generate meal suggestions based on ingredients
    func generateMealSuggestions(ingredients: [String]) async throws -> [MealSuggestion] {
        let prompt = """
        Given these ingredients: \(ingredients.joined(separator: ", ")), 
        suggest 5 possible dishes or meals. 
        The dishes can use any or all of these ingredients.
        Provide ONLY the name of each dish, one per line, with NO numbering, explanations, or additional text.
        """
        
        do {
            let response = try await model.generateContent(prompt)
            
            if let responseText = response.text {
                // Parse response into individual meal suggestions
                let mealNames = responseText
                    .components(separatedBy: .newlines)
                    .filter { !$0.isEmpty }
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                
                return mealNames.map { MealSuggestion(name: $0) }
            } else {
                throw GeminiError.emptyResponse
            }
        } catch {
            throw GeminiError.apiError(error.localizedDescription)
        }
    }
    
    // Generate cooking instructions for a selected meal
    func generateInstructions(for meal: String, using ingredients: [String]) async throws -> String {
        let prompt = """
        Please provide step-by-step cooking instructions for '\(meal)', 
        using these ingredients if possible: \(ingredients.joined(separator: ", ")).
        Format the response as a clear, numbered list of steps.
        """
        
        do {
            let response = try await model.generateContent(prompt)
            
            if let responseText = response.text {
                return responseText
            } else {
                throw GeminiError.emptyResponse
            }
        } catch {
            throw GeminiError.apiError(error.localizedDescription)
        }
    }
}

// Custom errors for the Gemini service
enum GeminiError: Error {
    case emptyResponse
    case apiError(String)
}

extension GeminiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "The AI returned an empty response"
        case .apiError(let message):
            return "API error: \(message)"
        }
    }
} 