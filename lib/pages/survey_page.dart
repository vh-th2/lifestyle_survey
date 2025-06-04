import 'package:flutter/material.dart';
import '../models/survey_response.dart';

class SurveyPage extends StatefulWidget {
  final Function(SurveyResponse) onSubmit;
  final bool showSuccessMessage;

  const SurveyPage({
    Key? key,
    required this.onSubmit,
    this.showSuccessMessage = false,
  }) : super(key: key);

  @override
  SurveyPageState createState() => SurveyPageState();
}

class SurveyPageState extends State<SurveyPage> {
  // Form controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  DateTime? _selectedDate;

  // Food preferences
  bool _likePizza = false;
  bool _likePasta = false;
  bool _likePapAndWors = false;
  bool _likeOther = false;

  // Ratings (1-5 scale)
  int? _moviesRating;
  int? _radioRating;
  int? _eatOutRating;
  int? _tvRating;

  // Validation error messages
  String? _fullNameError;
  String? _emailError;
  String? _contactError;
  String? _dateError;
  String? _ageError;
  String? _ratingsError;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showSuccessMessage) _buildSuccessMessage(),
          _buildSectionTitle('Personal Details:'),
          SizedBox(height: 20),
          _buildTextField('Full Names', _fullNameController, _fullNameError),
          _buildTextField('Email', _emailController, _emailError, isEmail: true),
          _buildDateField(),
          _buildTextField('Contact Number', _contactController, _contactError, isPhone: true),
          if (_ageError != null) _buildErrorMessage(_ageError!),
          SizedBox(height: 20),
          _buildFoodPreferences(),
          SizedBox(height: 30),
          _buildRatingSection(),
          if (_ratingsError != null) _buildErrorMessage(_ratingsError!),
          SizedBox(height: 30),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xFFD4EDDA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF28A745), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF155724)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Thank you! Your survey response has been recorded.',
              style: TextStyle(
                color: Color(0xFF155724),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xFFF8D7DA),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFDC3545), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Color(0xFF721C24), size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Color(0xFF721C24),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String? errorMessage,
      {bool isEmail = false, bool isPhone = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isEmail
                ? TextInputType.emailAddress
                : isPhone
                ? TextInputType.phone
                : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFF8F9FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                    color: errorMessage != null ? Color(0xFFDC3545) : Color(0xFFE9ECEF),
                    width: 2
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                    color: errorMessage != null ? Color(0xFFDC3545) : Color(0xFFE9ECEF),
                    width: 2
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                    color: errorMessage != null ? Color(0xFFDC3545) : Colors.blue,
                    width: 2
                ),
              ),
              contentPadding: EdgeInsets.all(12),
              errorText: errorMessage,
              errorStyle: TextStyle(
                color: Color(0xFFDC3545),
                fontSize: 12,
              ),
            ),
            onChanged: (value) {
              // Clear error when user starts typing
              if (errorMessage != null) {
                setState(() {
                  if (controller == _fullNameController) _fullNameError = null;
                  if (controller == _emailController) _emailError = null;
                  if (controller == _contactController) _contactError = null;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: _selectDate,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                border: Border.all(
                    color: _dateError != null ? Color(0xFFDC3545) : Color(0xFFE9ECEF),
                    width: 2
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select date of birth',
                    style: TextStyle(
                      color: _selectedDate != null
                          ? Colors.black
                          : Color(0xFF999999),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xFF999999),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_dateError != null)
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                _dateError!,
                style: TextStyle(
                  color: Color(0xFFDC3545),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFoodPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your favorite food? (Select all that apply)',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF555555),
          ),
        ),
        SizedBox(height: 10),
        _buildCheckbox('Pizza', _likePizza, (value) => setState(() => _likePizza = value!)),
        _buildCheckbox('Pasta', _likePasta, (value) => setState(() => _likePasta = value!)),
        _buildCheckbox('Pap and Wors', _likePapAndWors, (value) => setState(() => _likePapAndWors = value!)),
        _buildCheckbox('Other', _likeOther, (value) => setState(() => _likeOther = value!)),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
          Text(
            label,
            style: TextStyle(color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please rate your level of agreement on a scale from 1 to 5, with 1 being "strongly agree" and 5 being "strongly disagree."',
          style: TextStyle(
            color: Color(0xFF666666),
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 20),
        _buildRatingTable(),
      ],
    );
  }

  Widget _buildRatingTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _ratingsError != null ? Color(0xFFDC3545) : Color(0xFFDEE2E6)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          _buildRatingTableHeader(),
          _buildRatingRow('I like to watch movies', _moviesRating, (value) => setState(() {
            _moviesRating = value;
            if (_ratingsError != null) _ratingsError = null;
          })),
          _buildRatingRow('I like to listen to radio', _radioRating, (value) => setState(() {
            _radioRating = value;
            if (_ratingsError != null) _ratingsError = null;
          })),
          _buildRatingRow('I like to eat out', _eatOutRating, (value) => setState(() {
            _eatOutRating = value;
            if (_ratingsError != null) _ratingsError = null;
          })),
          _buildRatingRow('I like to watch TV', _tvRating, (value) => setState(() {
            _tvRating = value;
            if (_ratingsError != null) _ratingsError = null;
          })),
        ],
      ),
    );
  }

  Widget _buildRatingTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(bottom: BorderSide(color: Color(0xFFDEE2E6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(12),
              child: Text(''),
            ),
          ),
          ...['Strongly Agree', 'Agree', 'Neutral', 'Disagree', 'Strongly Disagree']
              .map((header) => Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(
                header,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Color(0xFF495057),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String statement, int? selectedValue, Function(int?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFDEE2E6))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(12),
              child: Text(
                statement,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF495057),
                ),
              ),
            ),
          ),
          ...List.generate(5, (index) => index + 1)
              .map((value) => Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Radio<int>(
                value: value,
                groupValue: selectedValue,
                onChanged: onChanged,
                activeColor: Colors.blue,
              ),
            ),
          ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF28A745), Color(0xFF20C997)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: _submitSurvey,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            'Submit Survey',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.blue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateError = null;
        _ageError = null;
      });
    }
  }

  // Calculate age from date of birth
  int _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int calculatedAge = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Validate phone number format
  bool _isValidPhoneNumber(String phone) {
    // Remove spaces, dashes, and parentheses
    String cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // Check if it's a valid format (at least 10 digits, may start with +)
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(cleanPhone);
  }

  bool _validateForm() {
    bool isValid = true;

    // Clear previous errors
    setState(() {
      _fullNameError = null;
      _emailError = null;
      _contactError = null;
      _dateError = null;
      _ageError = null;
      _ratingsError = null;
    });

    // Validate full name
    if (_fullNameController.text.trim().isEmpty) {
      setState(() {
        _fullNameError = 'Full name is required';
      });
      isValid = false;
    } else if (_fullNameController.text.trim().length < 2) {
      setState(() {
        _fullNameError = 'Full name must be at least 2 characters long';
      });
      isValid = false;
    }

    // Validate email
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
      isValid = false;
    } else if (!_isValidEmail(_emailController.text.trim())) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
      isValid = false;
    }

    // Validate contact number
    if (_contactController.text.trim().isEmpty) {
      setState(() {
        _contactError = 'Contact number is required';
      });
      isValid = false;
    } else if (!_isValidPhoneNumber(_contactController.text.trim())) {
      setState(() {
        _contactError = 'Please enter a valid contact number';
      });
      isValid = false;
    }

    // Validate date of birth
    if (_selectedDate == null) {
      setState(() {
        _dateError = 'Date of birth is required';
      });
      isValid = false;
    } else {
      // Validate age (between 5 and 120)
      final age = _calculateAge(_selectedDate!);
      if (age < 5) {
        setState(() {
          _ageError = 'Age must be at least 5 years old';
        });
        isValid = false;
      } else if (age > 120) {
        setState(() {
          _ageError = 'Age cannot be more than 120 years old';
        });
        isValid = false;
      }
    }

    // Validate ratings - all four must be selected
    if (_moviesRating == null || _radioRating == null || _eatOutRating == null || _tvRating == null) {
      setState(() {
        _ratingsError = 'Please provide ratings for all four questions';
      });
      isValid = false;
    }

    return isValid;
  }

  void _submitSurvey() {
    // Validate form
    if (!_validateForm()) {
      // Scroll to top to show errors
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      // Show validation error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text('Please fix the errors above before submitting'),
              ),
            ],
          ),
          backgroundColor: Color(0xFFDC3545),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    // Collect favorite foods
    List<String> favoriteFood = [];
    if (_likePizza) favoriteFood.add('Pizza');
    if (_likePasta) favoriteFood.add('Pasta');
    if (_likePapAndWors) favoriteFood.add('Pap and Wors');
    if (_likeOther) favoriteFood.add('Other');

    // Ensure at least one food preference is selected (optional validation)
    if (favoriteFood.isEmpty) {
      favoriteFood.add('None specified');
    }

    // Create survey response
    final response = SurveyResponse(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      dateOfBirth: _selectedDate!,
      contactNumber: _contactController.text.trim(),
      favoriteFood: favoriteFood,
      ratings: {
        'movies': _moviesRating!,
        'radio': _radioRating!,
        'eatOut': _eatOutRating!,
        'tv': _tvRating!,
      },
      timestamp: DateTime.now(),
    );

    // Call the callback function
    widget.onSubmit(response);

    // Clear form
    _clearForm();
  }

  void _clearForm() {
    setState(() {
      _fullNameController.clear();
      _emailController.clear();
      _contactController.clear();
      _selectedDate = null;
      _likePizza = false;
      _likePasta = false;
      _likePapAndWors = false;
      _likeOther = false;
      _moviesRating = null;
      _radioRating = null;
      _eatOutRating = null;
      _tvRating = null;

      // Clear errors
      _fullNameError = null;
      _emailError = null;
      _contactError = null;
      _dateError = null;
      _ageError = null;
      _ratingsError = null;
    });
  }

  // Method to fill sample data for testing
  void fillSampleData() {
    setState(() {
      _fullNameController.text = 'John Doe';
      _emailController.text = 'john.doe@example.com';
      _selectedDate = DateTime(1990, 1, 15);
      _contactController.text = '+27123456789';
      _likePizza = true;
      _likePasta = true;
      _likePapAndWors = false;
      _likeOther = false;
      _moviesRating = 2;
      _radioRating = 3;
      _eatOutRating = 1;
      _tvRating = 2;

      // Clear any existing errors
      _fullNameError = null;
      _emailError = null;
      _contactError = null;
      _dateError = null;
      _ageError = null;
      _ratingsError = null;
    });
  }
}