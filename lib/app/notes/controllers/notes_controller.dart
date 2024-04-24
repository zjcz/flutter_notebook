import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_notebook/data/database/database_service.dart';
import 'package:flutter_notebook/app/notes/models/note_model.dart';
import 'package:flutter_notebook/data/mapper/note_mapper.dart';

part 'notes_controller.g.dart';

@riverpod
class NotesController extends _$NotesController {
  late final DatabaseService _databaseService =
      ref.read(DatabaseService.provider);

  @override
  Stream<List<NoteModel>> build() {
    return _databaseService
        .listAllNotes()
        .map((noteWithCategory) => NoteMapper.mapToModelList(noteWithCategory));
  }

  Future<int> saveNote({
    required int? noteId,
    required String title,
    required String description,
    required int? categoryId,
  }) async {
    return _databaseService.saveNote(
      id: noteId,
      title: title,
      description: description,
      categoryId: categoryId,
    );
  }

  Future<int> deleteNote({required int noteId}) async {
    return _databaseService.deleteNote(noteId);
  }
}
