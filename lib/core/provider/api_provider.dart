// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/analysis_models.dart';
import '../config/app_config.dart';
import 'firebase_service.dart';

class ApplicationProgramInterfaceProvider extends ChangeNotifier {
  // Instance for google generative model
  final GenerativeModel model;
  final FirebaseService _firebaseService = FirebaseService();
  
  bool _isLoading = false;
  String? _error;
  AnalysisResult? _currentAnalysis;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AnalysisResult? get currentAnalysis => _currentAnalysis;

  // Constructor
  ApplicationProgramInterfaceProvider(String apiKey)
    : model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<AnalysisResult?> breakdownGeneration(String idea) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Check if API key is configured
    if (!AppConfig.isApiKeyConfigured) {
      _error = "Gemini API key is not configured. Please add your API key in lib/core/config/app_config.dart";
      _isLoading = false;
      notifyListeners();
      return null;
    }

    final prompt =
        """
        You are StepWise AI. 
        You analyze MVP startup ideas with maximum honesty. 
        Your purpose is not to please the user but to provide a critical, reality-based evaluation. 
        Highlight risks, weaknesses, and potential failure conditions. 
        If the idea has little or no chance of success, you must state it directly. 
        Avoid vague language, avoid excessive optimism, and never assume guaranteed success. 
        Always return JSON with the following fields:
        - domain (string)
        - product_type (string)
        - features (list of features, each with subtasks and complexity)
        - suggested_stack (frontend, backend, infra, db, ai)
        - roadmap (sequential technical steps)
        - market_analysis {
            target_customers (segments with descriptions),
            customer_value (realistic monetary value ranges),
            estimated_market_size (low, medium, high in \$),
            adoption_rate (low/medium/high with reasoning),
            competition_level (low/medium/high with reasoning),
            risks (list of major risk factors),
            success_probability (0-100 realistic percentage),
            detailed_commentary (strictly critical evaluation, not promotional)
        }
        Return ONLY valid JSON, no extra text.

        MVP Idea: $idea

        Break this idea into:
        1. Technical breakdown (features, subtasks, stack, complexity, roadmap).  
        2. Market analysis (customer ranges, value per customer, adoption potential, market size, competition, success chance).  

        Return structured JSON only.
        """;

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final rawText = response.text;

      if (rawText == null) {
        _error = "No response received from AI";
        _isLoading = false;
        notifyListeners();
        return null;
      }

      // Debug: Print the raw response
      debugPrint("Raw Gemini Response: $rawText");
      
      // Clean the response text to extract JSON
      String cleanedText = rawText.trim();
      
      // Remove any markdown code blocks
      if (cleanedText.startsWith('```json')) {
        cleanedText = cleanedText.substring(7);
      }
      if (cleanedText.startsWith('```')) {
        cleanedText = cleanedText.substring(3);
      }
      if (cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(0, cleanedText.length - 3);
      }
      
      // Remove any leading/trailing whitespace again
      cleanedText = cleanedText.trim();
      
      // Find the first { and last } to extract JSON
      int startIndex = cleanedText.indexOf('{');
      int endIndex = cleanedText.lastIndexOf('}');
      
      if (startIndex == -1 || endIndex == -1 || startIndex >= endIndex) {
        _error = "AI returned invalid format. Raw response: ${rawText.substring(0, rawText.length > 100 ? 100 : rawText.length)}...";
        _isLoading = false;
        notifyListeners();
        return null;
      }
      
      cleanedText = cleanedText.substring(startIndex, endIndex + 1);
      
      // Debug: Print the cleaned JSON
      debugPrint("Cleaned JSON: $cleanedText");
      
      final jsonData = jsonDecode(cleanedText) as Map<String, dynamic>;
      debugPrint("JSON Data parsed successfully: ${jsonData.keys}");
      debugPrint("JSON structure: $jsonData");
      
      try {
        // Test with a simple JSON structure first
        debugPrint("Testing AnalysisResult.fromJson with received data...");
        final analysis = AnalysisResult.fromJson(jsonData);
        debugPrint("Analysis object created successfully: ${analysis.domain}");
        
        // Save to Firebase (only if Firebase is available)
        try {
          await _firebaseService.saveAnalysis(
            idea: idea,
            analysis: jsonData,
          );
        } catch (firebaseError) {
          // Continue without Firebase if it fails
          debugPrint("Firebase save failed: $firebaseError");
        }
        
        _currentAnalysis = analysis;
        _isLoading = false;
        debugPrint("Analysis set in provider, notifying listeners");
        notifyListeners();
        return analysis;
      } catch (analysisError) {
        debugPrint("AnalysisResult.fromJson failed: $analysisError");
        _error = "Failed to parse analysis result: ${analysisError.toString()}";
        _isLoading = false;
        notifyListeners();
        return null;
      }
      
    } catch (e) {
      _error = "Failed to analyze idea: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
