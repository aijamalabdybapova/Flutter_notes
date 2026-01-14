import 'package:flutter/material.dart';
import 'note_model.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мои заметки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NotesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // Контроллер для текстового поля
  final TextEditingController _textController = TextEditingController();
  
  // Список заметок
  final List<Note> _notes = [];
  
  // Переменная для отслеживания редактирования
  Note? _editingNote;
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  // Метод для сохранения заметки
  void _saveNote() {
    final text = _textController.text.trim();
    
    if (text.isEmpty) return;
    
    setState(() {
      if (_editingNote != null) {
        // Редактируем существующую заметку
        final index = _notes.indexWhere((note) => note.id == _editingNote!.id);
        if (index != -1) {
          _notes[index] = _notes[index].copyWith(content: text);
        }
        _editingNote = null;
      } else {
        // Создаем новую заметку
        final newNote = Note(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: text,
          createdAt: DateTime.now(),
        );
        _notes.insert(0, newNote);
      }
      _textController.clear();
    });
  }
  
  // Метод для удаления заметки
  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });
  }
  
  // Метод для редактирования заметки
  void _editNote(Note note) {
    setState(() {
      _editingNote = note;
      _textController.text = note.content;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: note.content.length),
      );
    });
  }
  
  // Форматирование даты
  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editingNote != null ? 'Редактировать заметку' : 'Мои заметки',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле для ввода текста
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Введите текст заметки...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(8.0),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _textController.clear(),
                        ),
                      ),
                      onSubmitted: (_) => _saveNote(),
                    ),
                    const SizedBox(height: 8),
                    // Кнопка сохранения
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveNote,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _editingNote != null ? 'Обновить заметку' : 'Сохранить заметку',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Заголовок списка заметок
            Row(
              children: [
                const Text(
                  'Список заметок',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: Text('${_notes.length}'),
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // Список заметок
            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_add,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Нет заметок',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Добавьте первую заметку выше',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        return _buildNoteItem(note);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Виджет для элемента списка заметок
  Widget _buildNoteItem(Note note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          note.content,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            _formatDate(note.createdAt),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ),
        // Кнопки для редактирования и удаления
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Кнопка редактирования
            IconButton(
              onPressed: () => _editNote(note),
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Редактировать',
            ),
            // Кнопка удаления
            IconButton(
              onPressed: () => _showDeleteDialog(note.id),
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Удалить',
            ),
          ],
        ),
      ),
    );
  }
  
  // Диалоговое окно подтверждения удаления
  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить заметку?'),
        content: const Text('Вы уверены, что хотите удалить эту заметку?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              _deleteNote(id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}