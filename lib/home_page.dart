import 'package:book_manager/add_book_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final CollectionReference books = FirebaseFirestore.instance.collection(
      'books',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user?.displayName ?? 'User'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: books.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return const Text('Error loading books');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookList = snapshot.data!.docs;

          if (bookList.isEmpty) {
            return const Center(
              child: Text(
                'No books available. Add one using the button below.',
              ),
            );
          }

          return ListView.builder(
            itemCount: bookList.length,
            itemBuilder: (context, index) {
              var book = bookList[index];
              return ListTile(
                title: Text(book['name']),
                subtitle: Text("By: ${book['author']}"),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                AddBookPage(bookId: book.id, bookData: book),
                      ),
                    ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBookPage()),
            ),
      ),
    );
  }
}
