import 'package:flutter/material.dart';
import 'main.dart';
import 'pagetwo.dart';

class PageFourState extends State<PageFour>{
  final _biggerFont = const TextStyle(fontSize: 18);
  String _value = " ";
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Course Code"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: myController,
              decoration: InputDecoration(
                hintText: "Enter course code",
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}

class PageFour extends StatefulWidget {
  const PageFour({Key? key, required this.title}) : super(key: key);
  final String title;


  @override
  State<PageFour> createState() => PageFourState();
}



/*
              // Get a location using getDatabasesPath
              var databasesPath = await getDatabasesPath();
              String path = databasesPath+ '/demo.db';

              // Delete the database
              await deleteDatabase(path);

              // open the database
              Database database = await openDatabase(path, version: 1,
                  onCreate: (Database db, int version) async {
                    // When creating the db, create the table
                    await db.execute(
                        'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
                  });

              // Insert some records in a transaction
              await database.transaction((txn) async {
                int id1 = await txn.rawInsert(
                    'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
                print('inserted1: $id1');
                int id2 = await txn.rawInsert(
                    'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
                    ['another name', 12345678, 3.1416]);
                print('inserted2: $id2');
              });

              // Update some record
              int? count = await database.rawUpdate(
                  'UPDATE Test SET name = ?, value = ? WHERE name = ?',
                  ['updated name', '9876', 'some name']);
              print('updated: $count');

              // Get the records
              List<Map> list = await database.rawQuery('SELECT * FROM Test');
              List<Map> expectedList = [
                {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
                {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
              ];
              print(list);
              print(expectedList);

              // Count the records
              count = Sqflite
                  .firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM Test'));
              assert(count == 2);

              // Delete a record
              count = await database
                  .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
              assert(count == 1);

              // Close the database
              await database.close();
            */