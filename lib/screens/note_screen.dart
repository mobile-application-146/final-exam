import 'package:flutter/material.dart';
import '../models/note.dart';
import '../db/notes_database.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    final timestamp = DateTime.now().toString();
    final newNote = Note(
      id: widget.note?.id,
      title: title,
      content: content,
      timestamp: timestamp,
    );

    if (widget.note == null) {
      await NotesDatabase.instance.create(newNote);
    } else {
      await NotesDatabase.instance.update(newNote);
    }

    Navigator.pop(context);
  }

  Future deleteNote() async {
    if (widget.note != null) {
      await NotesDatabase.instance.delete(widget.note!.id!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          if (widget.note != null)
            IconButton(icon: const Icon(Icons.delete), onPressed: deleteNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(hintText: 'Content'),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: saveNote,
            ),
          ],
        ),
      ),
    );
  }
}
