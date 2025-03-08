# Recipe AI

A sleek, dark-themed iOS app that generates meal suggestions and cooking instructions based on ingredients you have at home, powered by Google's Gemini AI.

## Features

- **Dark, Minimalist UI**: Beautiful dark-themed interface with a clean, modern design
- **Ingredient Management**: Add and remove ingredients you have available
- **AI-Powered Suggestions**: Get meal ideas that use some or all of your ingredients
- **Cooking Instructions**: View detailed, step-by-step instructions for making each meal
- **Powered by Gemini**: Uses Google's Gemini AI (gemini-2.0-flash) for intelligent recipe generation

## Setup Instructions

### Prerequisites

- Xcode 15.0 or later
- iOS 16.0+ deployment target
- Swift 5.9+
- Google Gemini API key

### Installation

1. Clone this repository to your local machine.
2. Open `RecipeAI.xcodeproj` in Xcode.

### Adding the Google Generative AI Swift Package

1. In Xcode, go to File > Add Packages...
2. In the search field, paste the repository URL: `https://github.com/google/generative-ai-swift`
3. Click "Add Package" to integrate it into your project.

### Setting up Your API Key

1. Open the `Services/GeminiService.swift` file.
2. Replace `"YOUR_GEMINI_API_KEY_HERE"` with your actual Gemini API key.

```swift
private let apiKey = "YOUR_ACTUAL_API_KEY"
```

⚠️ **Note**: For production environments, it's recommended to use a secure method to store your API key, such as:
- Environment variables
- Apple's Keychain Services
- Swift Package Manager's Secret Management
- Info.plist with appropriate security measures

### Running the App

1. Select your target device/simulator from the device selector in Xcode.
2. Click the "Run" button (▶️) or press `Cmd+R` to build and run the app.

## Usage

1. **Add Ingredients**: Enter the ingredients you have available at home.
2. **Generate Meals**: Tap the "Generate Meal Ideas" button to get AI-powered suggestions.
3. **View Recipe**: Tap on any meal suggestion to see detailed cooking instructions.
4. **Try Again**: If you're not satisfied with the suggestions, you can regenerate them.

## Project Structure

- **Models/**: Data structures for the app
- **Services/**: Networking and API services, including Gemini API integration
- **Views/**: SwiftUI views for the user interface

## Security Considerations

This app uses the Google Gemini API, which sends your ingredient data to Google's servers for processing. Ensure you comply with all relevant privacy regulations when using and distributing this app.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 