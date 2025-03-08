import SwiftUI

struct IngredientsView: View {
    @State private var ingredients: [String] = []
    @State private var newIngredient: String = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    // UI constants
    private let backgroundColor = Color(red: 0.1, green: 0.1, blue: 0.12)
    private let cardColor = Color(red: 0.15, green: 0.15, blue: 0.18)
    private let accentColor = Color.mint
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Ingredients input section
                VStack(spacing: 15) {
                    HStack {
                        TextField("Enter an ingredient", text: $newIngredient)
                            .padding()
                            .background(cardColor)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .autocorrectionDisabled()
                            .submitLabel(.done)
                            .onSubmit {
                                addIngredient()
                            }
                        
                        Button(action: addIngredient) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(accentColor)
                        }
                        .disabled(newIngredient.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    
                    // Ingredient list
                    ScrollView {
                        if ingredients.isEmpty {
                            Text("Add ingredients you have at home")
                                .foregroundColor(.gray)
                                .padding(.top, 30)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(ingredients, id: \.self) { ingredient in
                                    IngredientRow(ingredient: ingredient) {
                                        if let index = ingredients.firstIndex(of: ingredient) {
                                            ingredients.remove(at: index)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .frame(maxHeight: 300)
                }
                .padding()
                .background(cardColor)
                .cornerRadius(15)
                
                Spacer()
                
                // Generate Meals button
                NavigationLink(destination: MealSuggestionsView(ingredients: ingredients)) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Generate Meal Ideas")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(ingredients.isEmpty ? Color.gray : accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(ingredients.isEmpty)
                .padding(.bottom)
            }
            .padding()
            .alert(errorMessage, isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            }
        }
    }
    
    private func addIngredient() {
        let trimmedIngredient = newIngredient.trimmingCharacters(in: .whitespaces)
        
        if !trimmedIngredient.isEmpty {
            if !ingredients.contains(trimmedIngredient) {
                ingredients.append(trimmedIngredient)
                newIngredient = ""
            } else {
                errorMessage = "This ingredient is already in your list"
                showingError = true
            }
        }
    }
}

struct IngredientRow: View {
    let ingredient: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(ingredient)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color(red: 0.2, green: 0.2, blue: 0.22))
        .cornerRadius(8)
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView()
            .preferredColorScheme(.dark)
    }
} 