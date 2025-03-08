import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            IngredientsView()
                .navigationTitle("Recipe AI")
                .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(.mint)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
} 