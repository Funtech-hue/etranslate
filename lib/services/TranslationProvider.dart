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
  bool _isLoading = false;

  String get inputText => _inputText;
  String get translatedText => _translatedText;
  bool get isOutputVisible => _isOutputVisible;
  String get sourceLang => _sourceLang;
  String get targetLang => _targetLang;
  bool get isLoading => _isLoading;

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

    _isLoading = true;
    notifyListeners();

    const maxRetries = 3;
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final response = await http.post(
          Uri.parse('https://api-gl.lingvanex.com/language/translate/v2'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_apiKey',
          },
          body: jsonEncode({
            'q': _inputText.trim(),
            'source': _sourceLang,
            'target': _targetLang,
            'format': 'text',
          }),
        );

        _isLoading = false;
        notifyListeners();

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _translatedText = data['data']['translations'][0]['translatedText'] ?? 'Translation error';
          _isOutputVisible = true;
          notifyListeners();
          await _saveToHistory(_inputText, _translatedText, _sourceLang, _targetLang);
          return;
        } else {
          print('API Error: ${response.statusCode} - ${response.body}');
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Translation failed: ${response.statusCode} - ${errorData['error']?['message'] ?? 'Unknown error'}',
              ),
            ),
          );
          return;
        }
      } catch (e) {
        print('Attempt ${attempt + 1} failed: $e');
        if (attempt == maxRetries - 1) {
          _isLoading = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
        await Future.delayed(Duration(seconds: 1)); // Wait before retry
      }
    }
  }

  // Save to history
  Future<void> _saveToHistory(
      String input, String output, String source, String target) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('translation_history') ?? [];
    history.insert(0, jsonEncode({
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
    favorites.insert(0, jsonEncode({
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

  // Clear all history
  Future<void> clearHistory(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('translation_history');
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('History cleared')),
    );
  }

  // Clear all favorites
  Future<void> clearFavorites(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Favorites cleared')),
    );
  }

  // Delete individual history entry
  Future<void> deleteHistoryEntry(BuildContext context, int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('translation_history') ?? [];
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await prefs.setStringList('translation_history', history);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('History entry deleted')),
      );
    }
  }

  // Delete individual favorite entry
  Future<void> deleteFavoriteEntry(BuildContext context, int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    if (index >= 0 && index < favorites.length) {
      favorites.removeAt(index);
      await prefs.setStringList('favorites', favorites);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Favorite deleted')),
      );
    }
  }

}