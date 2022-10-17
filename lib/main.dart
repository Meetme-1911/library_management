import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_management_practical/second_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController? bookController;

  TextEditingController? authorController;

  @override
  void initState() {
    bookController = TextEditingController();
    authorController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    bookController?.dispose();
    authorController?.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(label:  Text("Book name")),
                validator: (str) => textValidator(str),
                controller: bookController,
                // initialValue: 'Enter Book Name',
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Author name")),
                validator: (str) => textValidator(str),

                controller: authorController,
                // initialValue: 'Enter Author Name',
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveBook();
                  }

                },
                child: const Text("Save Book"),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SecondPage()));
                  },
                  child: const Text("View Books"))
            ],
          ),
        ),
      ),
    );
  }

  void saveBook() async {

    final pref = await SharedPreferences.getInstance();


    final noOfBooks = pref.getStringList(authorController!.text.toUpperCase());

    if (noOfBooks != null) {
      List<String> tempValues = noOfBooks;

      if (!tempValues.contains(bookController!.text)) {
        tempValues.add(bookController!.text);
      }

      pref.remove(authorController!.text.toUpperCase());

      await pref.setStringList(
          authorController!.text.toUpperCase(), tempValues);
    } else {
      await pref.setStringList(
          authorController!.text.toUpperCase(), [bookController!.text]);
    }
  }

  String? textValidator(String? str) {
    if (str == null || str.isEmpty) {
      return "Please enter name ";
    }
    return null;
  }
}
