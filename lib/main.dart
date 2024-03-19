import 'package:bit_of_drift/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const String driftingTitle = 'Drift DB test';
final database = AppDatabase();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: driftingTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends HookWidget {
  const HomePage({super.key});

  Future<void> insertRecord({
    required String title,
    required String content,
  }) async {
    await database.into(database.todoItems).insert(
          TodoItemsCompanion.insert(
            title: title,
            content: content,
          ),
        );
  }

  Future<List<TodoItem>> selectRecords() async {
    List<TodoItem> allItems = await database.select(database.todoItems).get();
    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    List<TodoItem> dbRecords = [];

    final titleController = useTextEditingController(text: 'title');
    final contentController = useTextEditingController(text: 'content');

    return Scaffold(
        appBar: AppBar(
          title: const Text(driftingTitle),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Title: '),
                  TextField(
                    controller: titleController,
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Content: '),
                  TextField(
                    controller: contentController,
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => insertRecord(
                      title: titleController.text,
                      content: contentController.text,
                    ),
                    child: const Text('Insert record'),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      useState((_) async {
                        dbRecords = await selectRecords();
                      });
                    },
                    child: const Text('Select rows'),
                  ),
                ],
              ),
              Text(
                dbRecords.toString(),
              ),
            ],
          ),
        ));
  }
}
