import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = AppConfig.analysisHistoryCollection;

  Future<void> saveAnalysis({
    required String idea,
    required Map<String, dynamic> analysis,
  }) async {
    try {
      await _firestore.collection(_collection).add({
        'idea': idea,
        'analysis': analysis,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save analysis: $e');
    }
  }

  Stream<QuerySnapshot> getAnalysisHistory() {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteAnalysis(String documentId) async {
    try {
      await _firestore.collection(_collection).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete analysis: $e');
    }
  }
}
