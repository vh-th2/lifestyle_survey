import 'package:flutter/material.dart';
import '../models/survey_response.dart';

class SurveyResultsPage extends StatelessWidget {
  final List<SurveyResponse> surveyResponses;

  const SurveyResultsPage({
    Key? key,
    required this.surveyResponses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (surveyResponses.isEmpty) {
      return Center(
        child: Text(
          'No survey responses yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            'Survey Results',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          _buildResultsGrid()
        ],
      ),
    );
  }

    Widget _buildResultsGrid() {
      final results = _calculateResults();

      return Column(
        children: [
          _buildResultItem(
              'Total number of surveys :', '${results['totalSurveys']}'),
          _buildResultItem('Average Age :', '${results['averageAge']} years'),
          _buildResultItem('Oldest person who participated in survey :',
              '${results['maxAge']} years'),
          _buildResultItem('Youngest person who participated in survey :',
              '${results['minAge']} years'),
          _buildResultItem('Percentage of people who like Pizza :',
              '${results['pizzaPercentage']}%'),
          _buildResultItem('Percentage of people who like Pasta :',
              '${results['pastaPercentage']}%'),
          _buildResultItem('Percentage of people who like Pap and Wors :',
              '${results['papWorsPercentage']}%'),
          _buildResultItem('People who like to watch movies :',
              '${results['moviesRating']}'),
          _buildResultItem('People who like to listen to radio :',
              '${results['radioRating']}'),
          _buildResultItem(
              'People who like to eat out :', '${results['eatOutRating']}'),
          _buildResultItem(
              'People who like to watch TV :', '${results['tvRating']}'),
        ],
      );
    }

    Widget _buildResultItem(String label, String value) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: Colors.blue, width: 4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF495057),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE9ECEF), width: 2),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    Map<String, dynamic> _calculateResults() {
      if (surveyResponses.isEmpty) {
        return {
          'totalSurveys': 0,
          'averageAge': '0.0',
          'maxAge': 0,
          'minAge': 0,
          'pizzaPercentage': '0.0',
          'pastaPercentage': '0.0',
          'papWorsPercentage': '0.0',
          'moviesRating': '0.0',
          'radioRating': '0.0',
          'eatOutRating': '0.0',
          'tvRating': '0.0',
        };
      }

      // Calculate ages using the getter from SurveyResponse
      final ages = surveyResponses.map((response) => response.age).toList();

      final totalSurveys = surveyResponses.length;
      final averageAge = ages.reduce((a, b) => a + b) / ages.length;
      final maxAge = ages.reduce((a, b) => a > b ? a : b);
      final minAge = ages.reduce((a, b) => a < b ? a : b);

      // Calculate food preferences
      final pizzaCount = surveyResponses
          .where((r) => r.favoriteFood.contains('Pizza'))
          .length;
      final pastaCount = surveyResponses
          .where((r) => r.favoriteFood.contains('Pasta'))
          .length;
      final papWorsCount = surveyResponses
          .where((r) => r.favoriteFood.contains('Pap and Wors'))
          .length;

      final pizzaPercentage = (pizzaCount / totalSurveys * 100);
      final pastaPercentage = (pastaCount / totalSurveys * 100);
      final papWorsPercentage = (papWorsCount / totalSurveys * 100);

      // Calculate average ratings
      double calculateAverageRating(String category) {
        final ratings = surveyResponses
            .map((r) => r.ratings[category])
            .where((rating) => rating != null)
            .cast<int>()
            .toList();

        if (ratings.isEmpty) return 0.0;
        // Invert the scale for proper interpretation
        return (6 - (ratings.reduce((a, b) => a + b) / ratings.length));
      }

      return {
        'totalSurveys': totalSurveys,
        'averageAge': averageAge.toStringAsFixed(1),
        'maxAge': maxAge,
        'minAge': minAge,
        'pizzaPercentage': pizzaPercentage.toStringAsFixed(1),
        'pastaPercentage': pastaPercentage.toStringAsFixed(1),
        'papWorsPercentage': papWorsPercentage.toStringAsFixed(1),
        'moviesRating': calculateAverageRating('movies').toStringAsFixed(1),
        'radioRating': calculateAverageRating('radio').toStringAsFixed(1),
        'eatOutRating': calculateAverageRating('eatOut').toStringAsFixed(1),
        'tvRating': calculateAverageRating('tv').toStringAsFixed(1),
      };
    }
  }