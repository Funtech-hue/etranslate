import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
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
                      '${item['output']} (${item['source']} → ${item['target']})'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}