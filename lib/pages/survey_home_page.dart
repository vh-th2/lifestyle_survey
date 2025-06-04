import 'package:flutter/material.dart';
import '../collections/firebase_service.dart';
import '../models/survey_response.dart';
import '../pages/survey_page.dart';
import '../pages/survey_results_page.dart';

class SurveyHomePage extends StatefulWidget {
  @override
  _SurveyHomePageState createState() => _SurveyHomePageState();
}

class _SurveyHomePageState extends State<SurveyHomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  final GlobalKey<SurveyPageState> _surveyPageKey = GlobalKey<SurveyPageState>();

  int _currentPage = 2;
  bool _showResults = false;
  bool _showSuccessMessage = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildHeader(),
                if (_isLoading) _buildLoadingIndicator(),
                Expanded(
                  child: _showResults
                      ? FutureBuilder<List<SurveyResponse>>(
                    future: _firebaseService.getSurveyResponses(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingIndicator();
                      }
                      if (snapshot.hasError) {
                        return _buildErrorWidget(snapshot.error.toString());
                      }
                      return SurveyResultsPage(
                        surveyResponses: snapshot.data ?? [],
                      );
                    },
                  )
                      : SurveyPage(
                    key: _surveyPageKey,
                    onSubmit: _handleSurveySubmit,
                    showSuccessMessage: _showSuccessMessage,
                  ),
                ),
                _buildPagination(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Error loading data: $error',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(bottom: BorderSide(color: Color(0xFFE9ECEF))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('📊', style: TextStyle(fontSize: 18)),
              SizedBox(width: 10),
              Text(
                'Surveys',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderButton(
                _showResults ? 'BACK TO SURVEY' : 'FILL OUT SURVEY',
                Colors.blue,
                _showResults ? _backToSurvey : _fillSampleData,
              ),
              SizedBox(width: 15),
              _buildHeaderButton(
                'VIEW SURVEY RESULTS',
                Color(0xFF6C757D),
                _viewResults,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 2,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(top: BorderSide(color: Color(0xFFDEE2E6))),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
    );
  }

  Widget _buildPageNav(String text, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFDEE2E6)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text),
      ),
    );
  }

  void _handleSurveySubmit(SurveyResponse response) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _firebaseService.saveSurveyResponse(response);
      setState(() {
        _showSuccessMessage = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save survey: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _viewResults() async {
    setState(() {
      _showResults = true;
      _showSuccessMessage = false;
    });
  }

  void _backToSurvey() {
    setState(() {
      _showResults = false;
    });
  }

  void _fillSampleData() {
    if (_showResults) return;

    final surveyPageState = _surveyPageKey.currentState;
    if (surveyPageState != null) {
      surveyPageState.fillSampleData();
    }
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 1) _currentPage--;
    });
  }

  void _nextPage() {
    setState(() {
      if (_currentPage < 4) _currentPage++;
    });
  }

  void _zoomIn() {
    // Implement zoom functionality if needed
  }
}