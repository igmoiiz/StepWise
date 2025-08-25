import 'package:cloud_firestore/cloud_firestore.dart';

class Subtask {
  final String description;
  final String complexity;

  Subtask({
    required this.description,
    required this.complexity,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      description: json['description'] ?? '',
      complexity: json['complexity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'complexity': complexity,
    };
  }
}

class Feature {
  final String name;
  final List<String> subtasks;
  final String complexity;

  Feature({
    required this.name,
    required this.subtasks,
    required this.complexity,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      name: json['name'] ?? '',
      subtasks: List<String>.from(json['subtasks'] ?? []),
      complexity: json['complexity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subtasks': subtasks,
      'complexity': complexity,
    };
  }
}

class SuggestedStack {
  final String frontend;
  final String backend;
  final String infra;
  final String db;
  final String ai;

  SuggestedStack({
    required this.frontend,
    required this.backend,
    required this.infra,
    required this.db,
    required this.ai,
  });

  factory SuggestedStack.fromJson(Map<String, dynamic> json) {
    return SuggestedStack(
      frontend: json['frontend'] ?? '',
      backend: json['backend'] ?? '',
      infra: json['infra'] ?? '',
      db: json['db'] ?? '',
      ai: json['ai'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frontend': frontend,
      'backend': backend,
      'infra': infra,
      'db': db,
      'ai': ai,
    };
  }
}

class CustomerSegment {
  final String segment;
  final String description;

  CustomerSegment({
    required this.segment,
    required this.description,
  });

  factory CustomerSegment.fromJson(Map<String, dynamic> json) {
    return CustomerSegment(
      segment: json['segment'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'segment': segment,
      'description': description,
    };
  }
}

class CustomerValue {
  final String framer;
  final String vendor;

  CustomerValue({
    required this.framer,
    required this.vendor,
  });

  factory CustomerValue.fromJson(Map<String, dynamic> json) {
    return CustomerValue(
      framer: json['framer'] ?? '',
      vendor: json['vendor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'framer': framer,
      'vendor': vendor,
    };
  }
}

class MarketAnalysis {
  final List<CustomerSegment> targetCustomers;
  final String customerValue;
  final String estimatedMarketSize;
  final String adoptionRate;
  final String adoptionRateReasoning;
  final String competitionLevel;
  final String competitionLevelReasoning;
  final List<String> risks;
  final String successProbability;
  final String detailedCommentary;

  MarketAnalysis({
    required this.targetCustomers,
    required this.customerValue,
    required this.estimatedMarketSize,
    required this.adoptionRate,
    required this.adoptionRateReasoning,
    required this.competitionLevel,
    required this.competitionLevelReasoning,
    required this.risks,
    required this.successProbability,
    required this.detailedCommentary,
  });

  factory MarketAnalysis.fromJson(Map<String, dynamic> json) {
    return MarketAnalysis(
      targetCustomers: (json['target_customers'] as List?)
          ?.map((e) => CustomerSegment.fromJson(e))
          .toList() ?? [],
      customerValue: json['customer_value']?.toString() ?? '',
      estimatedMarketSize: json['estimated_market_size'] ?? '',
      adoptionRate: json['adoption_rate'] ?? '',
      adoptionRateReasoning: json['adoption_rate_reasoning'] ?? '',
      competitionLevel: json['competition_level'] ?? '',
      competitionLevelReasoning: json['competition_level_reasoning'] ?? '',
      risks: List<String>.from(json['risks'] ?? []),
      successProbability: json['success_probability']?.toString() ?? '0',
      detailedCommentary: json['detailed_commentary'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'target_customers': targetCustomers.map((e) => e.toJson()).toList(),
      'customer_value': customerValue,
      'estimated_market_size': estimatedMarketSize,
      'adoption_rate': adoptionRate,
      'adoption_rate_reasoning': adoptionRateReasoning,
      'competition_level': competitionLevel,
      'competition_level_reasoning': competitionLevelReasoning,
      'risks': risks,
      'success_probability': successProbability,
      'detailed_commentary': detailedCommentary,
    };
  }
}

class AnalysisResult {
  final String domain;
  final String productType;
  final List<Feature> features;
  final SuggestedStack suggestedStack;
  final List<String> roadmap;
  final MarketAnalysis marketAnalysis;

  AnalysisResult({
    required this.domain,
    required this.productType,
    required this.features,
    required this.suggestedStack,
    required this.roadmap,
    required this.marketAnalysis,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      domain: json['domain'] ?? '',
      productType: json['product_type'] ?? '',
      features: (json['features'] as List?)
          ?.map((e) => Feature.fromJson(e))
          .toList() ?? [],
      suggestedStack: SuggestedStack.fromJson(json['suggested_stack'] ?? {}),
      roadmap: List<String>.from(json['roadmap'] ?? []),
      marketAnalysis: MarketAnalysis.fromJson(json['market_analysis'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domain': domain,
      'product_type': productType,
      'features': features.map((e) => e.toJson()).toList(),
      'suggested_stack': suggestedStack.toJson(),
      'roadmap': roadmap,
      'market_analysis': marketAnalysis.toJson(),
    };
  }
}

class AnalysisHistory {
  final String id;
  final String idea;
  final AnalysisResult analysis;
  final DateTime timestamp;

  AnalysisHistory({
    required this.id,
    required this.idea,
    required this.analysis,
    required this.timestamp,
  });

  factory AnalysisHistory.fromFirestore(Map<String, dynamic> data, String id) {
    return AnalysisHistory(
      id: id,
      idea: data['idea'] ?? '',
      analysis: AnalysisResult.fromJson(data['analysis'] ?? {}),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
