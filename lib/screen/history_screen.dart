import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../services/TranslationProvider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Translation History'),
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
              final history =
                  snapshot.data!.getStringList('translation_history') ?? [];
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
                        '${item['output']} (${item['source']} → ${item['target']})',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateTime.parse(item['timestamp']).toLocal().toString().split('.')[0],
                            style: TextStyle(fontSize: 12),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Delete',
                            onPressed: () => provider.deleteHistoryEntry(context, index),
                          ),
                        ],
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
  // Confirm clear all history
  void _confirmClear(BuildContext context, TranslationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear History'),
        content: Text('Are you sure you want to clear all history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearHistory(context);
              Navigator.pop(context);
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
}
}
