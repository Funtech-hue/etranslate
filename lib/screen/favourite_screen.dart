import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../services/TranslationProvider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Favorites'),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.delete_forever),
                tooltip: 'Clear All',
                onPressed: () => _confirmClear(context, provider),
              ),
            ],
          ),
          body: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Lottie.asset(
                    'assets/animations/eLoading.json',
                    repeat: true,
                    height: 100,
                    width: 100,
                  ),
                );
              }
              final favorites = snapshot.data!.getStringList('favorites') ?? [];
              if (favorites.isEmpty) {
                return Center(child: Text('No favorites yet'));
              }
              return ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = jsonDecode(favorites[index]);
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text('${item['input']}'),
                      subtitle: Text(
                        '${item['output']} (${item['source']} → ${item['target']})',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite_rounded, color: Colors.red),
                        tooltip: 'Delete',
                        onPressed: () => provider.deleteFavoriteEntry(context, index),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
  // Confirm clear all favorites
  void _confirmClear(BuildContext context, TranslationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Favorites'),
        content: Text('Are you sure you want to clear all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearFavorites(context);
              Navigator.pop(context);
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
