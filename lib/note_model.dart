class Note {
  String id;
  String content;
  DateTime createdAt;
  
  Note({
    required this.id,
    required this.content,
    required this.createdAt,
  });
  
  Note copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}