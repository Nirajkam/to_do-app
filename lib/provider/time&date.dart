import 'package:flutter/material.dart';

class date with ChangeNotifier {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  DateTime? get combinedDateTime {
    if (_selectedDate == null || _selectedTime == null) return null;

    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedDate!.hour,
      _selectedDate!.minute,
    );
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void clear() {
    _selectedDate = null;
    _selectedTime = null;
    notifyListeners();
  }
}
