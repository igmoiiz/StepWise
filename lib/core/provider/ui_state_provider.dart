import 'package:flutter/material.dart';
import '../models/analysis_models.dart';
import 'firebase_service.dart';

class UIStateProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  int _currentPageIndex = 0;
  bool _isDarkMode = true;
  List<AnalysisHistory> _analysisHistory = [];
  bool _isLoadingHistory = false;
  String? _historyError;

  int get currentPageIndex => _currentPageIndex;
  bool get isDarkMode => _isDarkMode;
  List<AnalysisHistory> get analysisHistory => _analysisHistory;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get historyError => _historyError;

  void setPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void loadAnalysisHistory() {
    _isLoadingHistory = true;
    _historyError = null;
    notifyListeners();

    try {
      _firebaseService.getAnalysisHistory().listen(
        (snapshot) {
          _analysisHistory = snapshot.docs
              .map((doc) => AnalysisHistory.fromFirestore(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ))
              .toList();
          _isLoadingHistory = false;
          notifyListeners();
        },
        onError: (error) {
          // Handle Firebase errors gracefully
          _historyError = null; // Don't show error for Firebase issues
          _analysisHistory = []; // Show empty state instead
          _isLoadingHistory = false;
          notifyListeners();
        },
      );
    } catch (e) {
      // Handle any initialization errors
      _historyError = null;
      _analysisHistory = [];
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<void> deleteAnalysis(String documentId) async {
    try {
      await _firebaseService.deleteAnalysis(documentId);
    } catch (e) {
      _historyError = "Failed to delete analysis: $e";
      notifyListeners();
    }
  }

  void clearHistoryError() {
    _historyError = null;
    notifyListeners();
  }
}
