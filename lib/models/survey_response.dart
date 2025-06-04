import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyResponse {
  final String fullName;
  final String email;
  final DateTime dateOfBirth;
  final String contactNumber;
  final List<String> favoriteFood;
  final Map<String, int?> ratings;
  final DateTime timestamp;

  SurveyResponse({
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.contactNumber,
    required this.favoriteFood,
    required this.ratings,
    required this.timestamp,
  });

  // Calculate age from date of birth
  int get age {
    final now = DateTime.now();
    int calculatedAge = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'contactNumber': contactNumber,
      'favoriteFood': favoriteFood,
      'ratings': ratings,
      'timestamp': timestamp,
    };
  }

  // Create from Firestore document
  factory SurveyResponse.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SurveyResponse(
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      contactNumber: data['contactNumber'] ?? '',
      favoriteFood: List<String>.from(data['favoriteFood'] ?? []),
      ratings: Map<String, int?>.from(data['ratings'] ?? {}),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}