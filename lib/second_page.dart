import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<String>? books = [];

  late int noOfBooksCurrentlyVisible ;
  late int totalNoOfBooks ;
  int booksOnOnePage = 4;
  bool zeroBooksForAuthor = false;

  TextEditingController? _searchController;
  late ScrollController scrollController;

  @override
  void initState() {
    totalNoOfBooks = 0;
    noOfBooksCurrentlyVisible = 0;
    _searchController = TextEditingController();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    _searchController?.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    scrollController.addListener(() {

      var nextPageTrigger = 0.8 * scrollController.position.maxScrollExtent;

      if (scrollController.position.pixels > nextPageTrigger) {
        fetchBooks();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Books"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _searchController,
                validator: textValidator,
                decoration: InputDecoration(suffix: SizedBox(
                  width: 30,
                  child: InkWell(onTap: () {

                      listOfBooks(_searchController!.text.toUpperCase());

                  },child: const Icon(Icons.search,size: 20,),),
                )),
              ),
              Expanded(
                  child: zeroBooksForAuthor ? const Center(child: Text("No Books in name of this author")) :ListView.builder(
                      controller: scrollController,
                      itemCount: noOfBooksCurrentlyVisible,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 7,

                          shadowColor: Colors.blue,
                          child: SizedBox(
                            height: 200,
                            child: Center(child: Text(books![index],style: const TextStyle(fontSize: 20),))
                          ),
                        );
                      }))

            ],
          ),
        ),
      ),
    );
  }

  void listOfBooks(String str) async{
    setState((){
      books = [];
    });
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList(str);
    if(list!= null) {
      setState(() {
        zeroBooksForAuthor = false;
        books = list;
        totalNoOfBooks = books?.length ?? 0;
        fetchBooks();
      });
    }
    else{
      setState((){
        zeroBooksForAuthor = true;
      });
    }
  }

  String? textValidator(String? str) {

    if(str == null || str.isEmpty) {
      return "Please enter name ";
    }
    return null;
  }

  void fetchBooks() {
    setState((){

    noOfBooksCurrentlyVisible = noOfBooksCurrentlyVisible + booksOnOnePage < totalNoOfBooks ? noOfBooksCurrentlyVisible + booksOnOnePage :totalNoOfBooks;

    });


  }
}
