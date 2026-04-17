class Note {
  String id;
  String content;
  DateTime createdAt;
  bool isFavorite;  

  Note({
    required this.id,
    required this.content,
    required this.createdAt,
    this.isFavorite = false,  
  });
  
  Note copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    bool? isFavorite,  
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,  
    );
  }
  
  
  Note toggleFavorite() {
    return Note(
      id: id,
      content: content,
      createdAt: createdAt,
      isFavorite: !isFavorite,
    );
  }
}