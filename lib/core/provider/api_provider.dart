// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ApplicationProgramInterfaceProvider extends ChangeNotifier {
  // Instance for google generative model
  final GenerativeModel model;

  // Constructor
  ApplicationProgramInterfaceProvider(String apiKey)
    : model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

  Future<Map<String, dynamic>?> breakdownGeneration(String idea) async {
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

    final response = await model.generateContent([Content.text(prompt)]);
    final rawText = response.text;

    if (rawText == null) return null;

    try {
      return jsonDecode(rawText) as Map<String, dynamic>;
    } catch (e) {
      debugPrint("JSON parsing error: $e");
      return null;
    }
  }
}
