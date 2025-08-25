class AppConfig {
  // Replace this with your actual Gemini API key
  static const String geminiApiKey = 'AIzaSyAxQpllEY7KrxhwTliXmtV7OFJpVQD0IxE';

  // App constants
  static const String appName = 'StepWise AI';
  static const String appDescription = 'Brutally honest startup analysis';
  static const String version = '1.0.0';

  // Firebase collection names
  static const String analysisHistoryCollection = 'analysis_history';

  // Validation
  static bool get isApiKeyConfigured =>
      geminiApiKey != 'YOUR_ACTUAL_GEMINI_API_KEY_HERE' &&
      geminiApiKey.isNotEmpty;
}
