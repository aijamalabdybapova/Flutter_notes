class Note {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.content,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  Note copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  Note updateContent(String newContent) {
    return Note(
      id: id,
      content: newContent,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
  
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);
    
    if (diff.inDays == 0) {
      return 'Сегодня в ${updatedAt.hour}:${updatedAt.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Вчера';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} дня(ей) назад';
    } else {
      return '${updatedAt.day}.${updatedAt.month}.${updatedAt.year}';
    }
  }
}