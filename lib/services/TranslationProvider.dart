import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationProvider with ChangeNotifier {
  String _inputText = '';
  String _translatedText = '';
  bool _isOutputVisible = false;
  String _sourceLang = 'en';
  String _targetLang = 'yo';

  String get inputText => _inputText;

  String get translatedText => _translatedText;

  bool get isOutputVisible => _isOutputVisible;

  String get sourceLang => _sourceLang;

  String get targetLang => _targetLang;

  //update the input text
  void updateInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  //Switch language between English and Yoruba
  void switchLanguage() {
    final temp = _sourceLang;
    _sourceLang = _targetLang;
    _targetLang = temp;
    _inputText = '';
    _translatedText = '';
    _isOutputVisible = false;
    notifyListeners();
  }

  //Translate text using LibreTranslate API
  Future<void> translateText(BuildContext context) async {
    if (_inputText.trim().isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('https://libretranslate.com/translate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': _inputText.trim(),
          'source': _sourceLang,
          'target': _targetLang,
          'format': 'text',
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _translatedText = data['translatedText'];
        _isOutputVisible = true;
        notifyListeners();

        _saveToHistory(
          _inputText.trim(),
          _translatedText,
          _sourceLang,
          _targetLang,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Translation failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Translation failed: $e')));
    }
  }

  //Save translation to history
  Future<void> _saveToHistory(
    String input,
    String output,
    String source,
    String target,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> history = prefs.getStringList('history') ?? [];
    history.add(jsonEncode({
      'input': input,
      'output': output,
      'source': source,
      'target': target,
      'timestamp': DateTime.now().toIso8601String(),
    }));
    await prefs.setStringList('translation_history', history);
  }

  //Clear translation history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('translation_history');
    _translatedText = '';
    notifyListeners();
  }

  //Save to favourite
  Future<void> saveToFavourites(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> favourites = prefs.getStringList('favourites') ?? [];
    favourites.add(jsonEncode({
      'input': _inputText.trim(),
      'output': _translatedText,
      'source': _sourceLang,
      'target': _targetLang,}));
    await prefs.setStringList('favourites', favourites);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to favourites')));
  }

  //Copy to clipboard
  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _translatedText));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
  }

  //Share text
  void shareText(BuildContext context) {
    Share.share(_translatedText, subject: 'Translated Text');
  }
}
