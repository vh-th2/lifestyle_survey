
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/survey_response.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save survey response to Firestore
  Future<void> saveSurveyResponse(SurveyResponse response) async {
    try {
      await _firestore.collection('survey_responses').add({
        'fullName': response.fullName,
        'email': response.email,
        'dateOfBirth': response.dateOfBirth,
        'contactNumber': response.contactNumber,
        'favoriteFood': response.favoriteFood,
        'ratings': response.ratings,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving survey: $e');
      throw e;
    }
  }

  // Get all survey responses
  Future<List<SurveyResponse>> getSurveyResponses() async {
    try {
      final querySnapshot = await _firestore
          .collection('survey_responses')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return SurveyResponse(
          fullName: data['fullName'] ?? '',
          email: data['email'] ?? '',
          dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
          contactNumber: data['contactNumber'] ?? '',
          favoriteFood: List<String>.from(data['favoriteFood'] ?? []),
          ratings: Map<String, int?>.from(data['ratings'] ?? {}),
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print('Error getting surveys: $e');
      throw e;
    }
  }
}