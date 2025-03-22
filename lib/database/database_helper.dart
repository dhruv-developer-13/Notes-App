import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    return openDatabase(
      path,
      version: 3, // Ensure this matches your latest version
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            imagePath TEXT,
            isPinned INTEGER DEFAULT 0,
            isFavorite INTEGER DEFAULT 0,
            isDeleted INTEGER DEFAULT 0,
            createdAt TEXT,
            colortheme INTEGER DEFAULT 4294967295  -- Default White
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute("ALTER TABLE notes ADD COLUMN colortheme INTEGER DEFAULT 4294967295");
        }
      },
    );
  }

  // Insert a new note
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get non-deleted notes (Sorted at SQL Level)
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'isDeleted = ?',
      whereArgs: [0],
      orderBy: 'isPinned DESC, createdAt DESC' // Ensures pinned notes stay on top
    );

    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  // Get favorite notes
  Future<List<Note>> getFavoriteNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'isFavorite = ? AND isDeleted = ?',
      whereArgs: [1, 0],
      orderBy: 'isPinned DESC, createdAt DESC' // Ensures pinned notes stay on top
    );

    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  // Get deleted notes
  Future<List<Note>> getDeletedNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'isDeleted = ?',
      whereArgs: [1]
    );

    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  // Move note to trash
  Future<int> moveToTrash(int noteId) async {
    final db = await database;
    return await db.update('notes', {'isDeleted': 1}, where: 'id = ?', whereArgs: [noteId]);
  }

  // Restore note from trash
  Future<int> restoreNote(int noteId) async {
    final db = await database;
    return await db.update('notes', {'isDeleted': 0}, where: 'id = ?', whereArgs: [noteId]);
  }

  // Permanently delete note
  Future<int> deleteNotePermanently(int noteId) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [noteId]);
  }

  // Toggle pin status (Direct update)
  Future<int> togglePin(int noteId, bool isPinned) async {
    final db = await database;
    return await db.update(
      'notes',
      {'isPinned': isPinned ? 1 : 0},
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  // Toggle favorite status (Direct update)
  Future<int> toggleFavorite(int noteId, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'notes',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

   Future<int> updateNote(Note note) async {
  final db = await database;
  return await db.update(
    'notes',
    note.toMap(),
    where: 'id = ?',
    whereArgs: [note.id],
  );
}
}
