import 'package:flutter/material.dart';

class DropdownProvider with ChangeNotifier {
  int? _selectedValue;
  final Map<String, int> _options = {'Top priority': 1, 'Medium': 2, 'Low': 3};

  int? get selectedValue => _selectedValue;
  Map<String, int> get options => _options;

  void setItem(int value) {
    _selectedValue = value;
    notifyListeners();
  }

  void clear() {
    _selectedValue = null;
    notifyListeners();
  }
}
