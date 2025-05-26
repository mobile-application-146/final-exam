import 'package:flutter/material.dart';
import '../db/notes_database.dart';
import '../models/note.dart';
import 'note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    final data = await NotesDatabase.instance.readAllNotes();
    setState(() => notes = data);
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        notes.where((note) {
          return note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase());
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyNotes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) => setState(() => query = val),
              decoration: InputDecoration(
                hintText: 'Search...',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final note = filtered[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(
              '${note.content.split('\n').take(2).join('\n')}\n${note.timestamp}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            isThreeLine: true,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteScreen(note: note)),
              );
              refreshNotes();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteScreen()),
          );
          refreshNotes();
        },
      ),
    );
  }
}
