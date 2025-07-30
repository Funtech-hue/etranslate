import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation History'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final history = snapshot.data!.getStringList('translation_history') ?? [];
          if (history.isEmpty) {
            return Center(child: Text('No history yet'));
          }
          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = jsonDecode(history[index]);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text('${item['input']}'),
                  subtitle: Text(
                      '${item['output']} (${item['source']} → ${item['target']})'),
                  trailing: Text(
                    DateTime.parse(item['timestamp']).toLocal().toString().split('.')[0],
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}