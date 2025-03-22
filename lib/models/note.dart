class Note implements Comparable<Note> {
  int? id;
  String title;
  String content;
  String? imagePath;
  bool isPinned;
  bool isFavorite;
  bool isDeleted;
  String createdAt;
  int colortheme;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.imagePath,
    this.isPinned = false,
    this.isFavorite = false,
    this.isDeleted = false,
    required this.createdAt,
    this.colortheme = 0xFFFFFFFF, // Default white
  });

  // Convert to Map for Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'isPinned': isPinned ? 1 : 0,
      'isFavorite': isFavorite ? 1 : 0,
      'isDeleted': isDeleted ? 1 : 0,
      'createdAt': createdAt,
      'colortheme': colortheme,
    };
  }

  // Convert Map to Note Object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imagePath: map['imagePath'],
      isPinned: map['isPinned'] == 1,
      isFavorite: map['isFavorite'] == 1,
      isDeleted: map['isDeleted'] == 1,
      createdAt: map['createdAt'],
      colortheme: map['colortheme'] ?? 0xFFFFFFFF,
    );
  }

  // Fix: Implement compareTo method
 @override
int compareTo(Note other) {
  int pinnedA = isPinned ? 1 : 0; // Convert bool → int
  int pinnedB = other.isPinned ? 1 : 0;

  if (pinnedA != pinnedB) {
    return pinnedB - pinnedA; // Sort pinned notes first
  }

  return other.createdAt.compareTo(createdAt); // Sort newest notes first
}


  // Fix: Implement copyWith to update Notes
  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? imagePath,
    bool? isPinned,
    bool? isFavorite,
    bool? isDeleted,
    String? createdAt,
    int? colortheme,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      colortheme: colortheme ?? this.colortheme,
    );
  }
}
