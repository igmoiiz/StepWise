# StepWise AI - Brutally Honest Startup Analysis

A Flutter application that provides critical, reality-based evaluation of MVP startup ideas using Google's Gemini AI. StepWise AI analyzes your startup concept with maximum honesty, highlighting risks, weaknesses, and potential failure conditions.

## Features

- **AI-Powered Analysis**: Uses Google Gemini AI to analyze startup ideas with brutal honesty
- **Comprehensive Evaluation**: 
  - Technical breakdown (features, complexity, tech stack)
  - Market analysis (customer segments, market size, competition)
  - Success probability assessment
  - Risk identification
- **Beautiful Material 3 UI**: Modern, animated interface with dark/light theme support
- **Analysis History**: Firebase Firestore integration to save and retrieve past analyses
- **State Management**: Proper Provider-based state management

## Setup Instructions

### 1. Prerequisites
- Flutter SDK (3.9.0 or higher)
- Firebase project setup
- Google Gemini API key

### 2. Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Firestore Database
3. Add your Flutter app to the Firebase project
4. Download and place the configuration files:
   - `android/app/google-services.json` (Android)
   - `ios/Runner/GoogleService-Info.plist` (iOS)

### 3. API Key Configuration
1. Get your Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Open `lib/core/config/app_config.dart`
3. Replace `YOUR_GEMINI_API_KEY_HERE` with your actual API key:
   ```dart
   static const String geminiApiKey = 'your_actual_api_key_here';
   ```

### 4. Installation
```bash
# Clone the repository
git clone <your-repo-url>
cd stepwise

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart          # App configuration and constants
│   ├── models/
│   │   └── analysis_models.dart     # Data models for API responses
│   └── provider/
│       ├── api_provider.dart        # Gemini AI integration
│       ├── firebase_service.dart    # Firebase Firestore service
│       └── ui_state_provider.dart   # UI state management
├── presentation/
│   ├── utilities/
│   │   └── theme.dart              # App themes (light/dark)
│   └── view/
│       └── interface/
│           ├── interface.dart       # Main interface page
│           └── widgets/
│               ├── analysis_input_section.dart    # Input form
│               ├── analysis_results_section.dart  # Results display
│               └── analysis_history_section.dart  # History view
└── main.dart                       # App entry point
```

## How It Works

1. **Input**: User enters their startup idea description
2. **Analysis**: The app sends the idea to Gemini AI with a specialized prompt
3. **Processing**: AI returns structured JSON with comprehensive analysis
4. **Display**: Results are presented in an animated, easy-to-read format
5. **Storage**: Analysis is automatically saved to Firebase for future reference

## Key Features Explained

### AI Analysis Includes:
- **Domain & Product Type**: Classification of the business
- **Technical Breakdown**: Features, complexity, and development roadmap
- **Suggested Tech Stack**: Recommended technologies for implementation
- **Market Analysis**: Target customers, market size, adoption rates
- **Success Probability**: Realistic percentage with reasoning
- **Risk Assessment**: Major risk factors and potential failures
- **Critical Commentary**: Honest evaluation without sugar-coating

### UI Features:
- **Smooth Animations**: Material 3 design with fluid transitions
- **Responsive Design**: Works on phones and tablets
- **Theme Support**: Automatic dark/light mode switching
- **History Management**: View, search, and delete past analyses
- **Error Handling**: Graceful error states and user feedback

## Dependencies

- `flutter`: SDK
- `provider`: State management
- `google_generative_ai`: Gemini AI integration
- `cloud_firestore`: Firebase database
- `firebase_core`: Firebase initialization
- `google_fonts`: Typography
- `firebase_auth`: Authentication (if needed)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

StepWise AI provides analysis based on AI interpretation and should not be considered as professional business advice. Always consult with business professionals and conduct thorough market research before making important business decisions.
