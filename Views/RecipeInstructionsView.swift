import SwiftUI

struct RecipeInstructionsView: View {
    let mealName: String
    let ingredients: [String]
    
    @State private var instructions: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    // UI constants
    private let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.12)
    private let cardColor = Color(red: 0.15, green: 0.15, blue: 0.18)
    private let accentColor = Color.mint
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                if isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(accentColor)
                    Text("Generating recipe instructions...")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else if let error = errorMessage {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        Button(action: loadInstructions) {
                            Text("Try Again")
                                .fontWeight(.semibold)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    Spacer()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Meal name header
                            Text(mealName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            
                            // Ingredients used section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Ingredients")
                                    .font(.headline)
                                    .foregroundColor(accentColor)
                                
                                ForEach(ingredients, id: \.self) { ingredient in
                                    HStack(alignment: .top) {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 6))
                                            .padding(.top, 6)
                                        Text(ingredient)
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(cardColor)
                            .cornerRadius(12)
                            
                            // Instructions section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Instructions")
                                    .font(.headline)
                                    .foregroundColor(accentColor)
                                
                                Text(instructions)
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            .background(cardColor)
                            .cornerRadius(12)
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadInstructions()
        }
    }
    
    private func loadInstructions() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let recipeInstructions = try await GeminiService.shared.generateInstructions(
                    for: mealName,
                    using: ingredients
                )
                
                DispatchQueue.main.async {
                    self.instructions = recipeInstructions
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to generate instructions: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
}

struct RecipeInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipeInstructionsView(
                mealName: "Chicken and Broccoli Stir Fry",
                ingredients: ["Chicken", "Rice", "Broccoli", "Soy Sauce"]
            )
        }
        .preferredColorScheme(.dark)
    }
} 