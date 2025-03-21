import 'package:book_manager/api_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookPage extends StatefulWidget {
  final String? bookId;
  final DocumentSnapshot? bookData;

  AddBookPage({this.bookId, this.bookData});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.bookData != null) {
      nameController.text = widget.bookData!['name'];
      authorController.text = widget.bookData!['author'];
      publisherController.text = widget.bookData!['publisher'];
      yearController.text = widget.bookData!['year'].toString();
    }
  }

  void saveBook() {
    if (widget.bookId == null) {
      FirebaseFirestore.instance.collection('books').add({
        'name': nameController.text,
        'author': authorController.text,
        'publisher': publisherController.text,
        'year': int.parse(yearController.text),
      });
    } else {
      FirebaseFirestore.instance.collection('books').doc(widget.bookId).update({
        'name': nameController.text,
        'author': authorController.text,
        'publisher': publisherController.text,
        'year': int.parse(yearController.text),
      });
    }
    Navigator.pop(context);
  }

  void deleteBook() {
    FirebaseFirestore.instance.collection('books').doc(widget.bookId).delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookId == null ? "Add Book" : "Edit Book"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Book Name"),
            ),
            TextField(
              controller: authorController,
              decoration: InputDecoration(labelText: "Author Name"),
            ),
            TextField(
              controller: publisherController,
              decoration: InputDecoration(labelText: "Publisher"),
            ),
            TextField(
              controller: yearController,
              decoration: InputDecoration(labelText: "Year"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveBook, child: Text("Save")),
            if (widget.bookId != null) ...[
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: deleteBook,
                child: Text("Delete"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Add a book
void addBook() async {
  try {
    var response = await ApiService.createBook(
      "Flutter Guide",
      "John Doe",
      "2025-03-20",
      200,
      "English",
      "Tech Press",
    );
    print(response);
  } catch (e) {
    print(e);
  }
}

// Updating a book
void updateBook() async {
  try {
    var response = await ApiService.updateBook(
      1,
      "Updated Flutter Guide",
      "Jane Doe",
      "2025-04-01",
      250,
      "English",
      "Updated Press",
    );
    print(response);
  } catch (e) {
    print(e);
  }
}

// Deleting a book
void deleteBook() async {
  try {
    var response = await ApiService.deleteBook(1);
    print(response);
  } catch (e) {
    print(e);
  }
}
