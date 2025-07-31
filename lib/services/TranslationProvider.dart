import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class TranslationProvider with ChangeNotifier {
  String _inputText = '';
  String _translatedText = '';
  bool _isOutputVisible = false;
  String _sourceLang = 'en'; // English
  String _targetLang = 'yo'; // Yoruba
  final String _apiKey = 'a_J14hZJajufQRvXpjsr0kKSbAO1shzOeE2kPtEqWjmSY6jgj3eqIM39tMMRHnro60QQgHJJqWlkcbih1A'; // Your Lingvanex API key

  String get inputText => _inputText;
  String get translatedText => _translatedText;
  bool get isOutputVisible => _isOutputVisible;
  String get sourceLang => _sourceLang;
  String get targetLang => _targetLang;

  // Update input text
  void updateInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  // Switch languages
  void switchLanguages() {
    final temp = _sourceLang;
    _sourceLang = _targetLang;
    _targetLang = temp;
    _inputText = '';
    _translatedText = '';
    _isOutputVisible = false;
    notifyListeners();
  }

  // Translate text using Lingvanex API
  Future<void> translateText(BuildContext context) async {
    if (_inputText.trim().isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('https://api-gl.lingvanex.com/language/translate/v2'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'from': _sourceLang,
          'to': _targetLang,
          'data': _inputText.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _translatedText = data['result'];
        _isOutputVisible = true;
        notifyListeners();
        // Save to history
        _saveToHistory(_inputText, _translatedText, _sourceLang, _targetLang);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Translation failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Save to history
  Future<void> _saveToHistory(
      String input, String output, String source, String target) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('translation_history') ?? [];
    history.add(jsonEncode({
      'input': input,
      'output': output,
      'source': source,
      'target': target,
      'timestamp': DateTime.now().toIso8601String(),
    }));
    await prefs.setStringList('translation_history', history);
  }

  // Save to favorites
  Future<void> saveToFavorites(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(jsonEncode({
      'input': _inputText,
      'output': _translatedText,
      'source': _sourceLang,
      'target': _targetLang,
    }));
    await prefs.setStringList('favorites', favorites);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to favorites')),
    );
  }

  // Copy to clipboard
  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _translatedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard')),
    );
  }

  // Share text
  void shareText() {
    Share.share(_translatedText, subject: 'Translated Text');
  }
}