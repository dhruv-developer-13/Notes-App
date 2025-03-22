import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _deletedNotes = [];
  List<Note> _favorites = [];
  bool _isLoading = true; // Track loading state
  List<Note> get notes => _notes;
  List<Note> get deletedNotes => _deletedNotes;
  List<Note> get favorites => _favorites;
  bool get isLoading => _isLoading;

  // Load notes immediately when the provider is created
  NoteProvider() {
    _loadNotes();
  }

  // Fetch Notes (Runs Only Once at Startup)
  Future<void> _loadNotes() async {
    _notes = await DatabaseHelper().getNotes();
    _deletedNotes = await DatabaseHelper().getDeletedNotes();
    _favorites = await DatabaseHelper().getFavoriteNotes(); // Fetch favorites properly

    _sortNotes();  // Sort notes after loading
    _sortFavorites(); // Sort favorites after loading
    _isLoading = false;
    notifyListeners();
  }

  // Sort notes ensuring newly pinned notes are at the top
  void _sortNotes() {
    // Sort by pinning status first, followed by the rest of the note attributes
    _notes.sort((a, b) {
      if (a.isPinned == b.isPinned) {
        return 0;  // If both notes are either pinned or unpinned, no change
      }
      return a.isPinned ? -1 : 1;  // Pinned notes come first
    });
  }

  // Sort favorites ensuring pinned favorites are at the top
  void _sortFavorites() {
    // Sort favorites based on pinning status
    _favorites.sort((a, b) {
      if (a.isPinned == b.isPinned) {
        return 0;
      }
      return a.isPinned ? -1 : 1;  // Pinned favorites come first
    });
  }

  // Add a new note without reloading everything
  Future<void> addNote(Note note) async {
    int id = await DatabaseHelper().insertNote(note);
    _notes.add(note.copyWith(id: id)); // Add new note with the generated ID
    _favorites = await DatabaseHelper().getFavoriteNotes(); // Refresh favorites

    _sortNotes();  // Sort notes after adding
    _sortFavorites(); // Sort favorites after adding
    notifyListeners();
  }

  // Update an existing note
  Future<void> updateNote(Note updatedNote) async {
    await DatabaseHelper().updateNote(updatedNote);
    int index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      _favorites = await DatabaseHelper().getFavoriteNotes(); // Ensure favorites stay updated

      _sortNotes();  // Sort notes after update
      _sortFavorites(); // Sort favorites after update
      notifyListeners();
    }
  }

  // Toggle pinning of the note
  Future<void> togglePin(Note note) async {
    // Toggle pin status in the database
    await DatabaseHelper().togglePin(note.id!, !note.isPinned);

    // Update the pin status in memory (UI)
    note.isPinned = !note.isPinned;

    // Re-sort the notes and favorites based on pin status
    _sortNotes();  // Re-sort after pin/unpin in notes
    _sortFavorites(); // Re-sort after pin/unpin in favorites
    notifyListeners(); // Notify listeners to refresh the UI
  }

  // Toggle favorite status of the note
  Future<void> toggleFavorite(Note note) async {
    // Toggle favorite status in the database
    await DatabaseHelper().toggleFavorite(note.id!, !note.isFavorite);

    // Update the favorite status in memory (UI)
    note.isFavorite = !note.isFavorite;

    // Update the favorites list in memory
    _favorites = _notes.where((note) => note.isFavorite).toList();

    _sortFavorites(); // Sort favorites after toggling favorite status
    notifyListeners(); // Notify listeners to refresh the UI
  }

  // Move Note to Trash
  Future<void> moveToTrash(int noteId) async {
    await DatabaseHelper().moveToTrash(noteId);

    // Find the note and move it from _notes to _deletedNotes
    int index = _notes.indexWhere((note) => note.id == noteId);
    if (index != -1) {
      Note movedNote = _notes.removeAt(index).copyWith(isDeleted: true);
      _deletedNotes.add(movedNote);
      notifyListeners();
    }
  }

  // Restore Note Without Reloading Everything
  Future<void> restoreNoteFromTrash(int noteId) async {
    await DatabaseHelper().restoreNote(noteId);

    // Move the note back from _deletedNotes to _notes
    int index = _deletedNotes.indexWhere((note) => note.id == noteId);
    if (index != -1) {
      Note restoredNote = _deletedNotes.removeAt(index).copyWith(isDeleted: false);
      _notes.add(restoredNote);

      _sortNotes();  // Sort notes after restoration
      _sortFavorites(); // Sort favorites after restoration
      notifyListeners();
    }
  }

  // Permanently Delete Note
  Future<void> deleteNotePermanently(int noteId) async {
    await DatabaseHelper().deleteNotePermanently(noteId);
    _deletedNotes.removeWhere((note) => note.id == noteId); // Remove from memory
    notifyListeners();
  }
}




