import SwiftUI

struct MealSuggestionsView: View {
    let ingredients: [String]
    
    @State private var mealSuggestions: [MealSuggestion] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // UI constants
    private let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.12)
    private let cardColor = Color(red: 0.15, green: 0.15, blue: 0.18)
    private let accentColor = Color.mint
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Ingredients list (compact)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(cardColor)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 5)
                
                if isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(accentColor)
                    Text("Generating meal ideas...")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else if let error = errorMessage {
                    Spacer()
                    VStack(spacing: 15) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        Button(action: generateMealSuggestions) {
                            Text("Try Again")
                                .fontWeight(.semibold)
                                .frame(width: 120)
                                .padding()
                                .background(accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                    Spacer()
                } else if mealSuggestions.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 50))
                            .foregroundColor(accentColor)
                        
                        Text("Get AI-powered meal suggestions based on your ingredients")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        Button(action: generateMealSuggestions) {
                            Text("Generate Suggestions")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                    Spacer()
                } else {
                    // Display meal suggestions
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(mealSuggestions) { meal in
                                NavigationLink(destination: RecipeInstructionsView(mealName: meal.name, ingredients: ingredients)) {
                                    MealSuggestionRow(mealName: meal.name)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Regenerate button
                    Button(action: generateMealSuggestions) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Regenerate Suggestions")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
        }
        .navigationTitle("Meal Suggestions")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if mealSuggestions.isEmpty {
                generateMealSuggestions()
            }
        }
    }
    
    private func generateMealSuggestions() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let suggestions = try await GeminiService.shared.generateMealSuggestions(ingredients: ingredients)
                
                DispatchQueue.main.async {
                    self.mealSuggestions = suggestions
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to generate meal suggestions: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

struct MealSuggestionRow: View {
    let mealName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(mealName)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(red: 0.15, green: 0.15, blue: 0.18))
        .cornerRadius(10)
    }
}

struct MealSuggestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MealSuggestionsView(ingredients: ["Chicken", "Rice", "Broccoli"])
        }
        .preferredColorScheme(.dark)
    }
} 