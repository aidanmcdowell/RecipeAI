import Foundation

// Model for a meal suggestion
struct MealSuggestion: Identifiable {
    let id = UUID()
    let name: String
}

// Model for recipe instructions
struct RecipeInstructions: Identifiable {
    let id = UUID()
    let mealName: String
    let ingredients: [String]
    let instructions: String
} 