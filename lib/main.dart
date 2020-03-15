import 'package:flutter/material.dart';
import 'package:task_management/screens/note_list.dart';
import 'data/moor_database.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      // The single instance of AppDatabase
      builder: (_) => AppDatabase(),
      child: MaterialApp(
        title: 'Task Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: NoteList(),
      ),
    );
  }
}