import 'package:bit_of_drift/database.dart';
import 'package:flutter/material.dart';

const String driftingTitle = 'Drift DB test';
final database = AppDatabase();
List<TodoItem> dbRecords = [];

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  final titleController = TextEditingController(text: 'title');
  final contentController = TextEditingController(text: 'content');

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(driftingTitle),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Title: '),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: titleController,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Content: '),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: contentController,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      titleController.text.length < 6
                          ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  'Please at least 6 letters in title'),
                              action: SnackBarAction(
                                onPressed: () {},
                                label: 'Close',
                              ),
                            ))
                          : insertRecord(
                              title: titleController.text,
                              content: contentController.text,
                            );
                    },
                    child: const Text('Insert record'),
                  ),
                  TextButton(
                    onPressed: () async {
                      dbRecords = await selectRecords();
                      setState(() {});
                    },
                    child: const Text('Select rows'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dbRecords.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          dbRecords[index].toString(),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
