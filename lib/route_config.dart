import 'package:flutter_notebook/app/notes/views/edit_note_screen.dart';
import 'package:flutter_notebook/app/home/views/home_screen.dart';
import 'package:flutter_notebook/app/category/views/list_categories_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_notebook/app/notes/models/note_model.dart';

class RouteDefs {
  static const String home = '/';
  static const String editNote = '/edit_note';
  static const String manageCategories = '/list_categories';
}

GoRouter setupRouter({String? initialLocation, Object? initialExtra}) {
  return GoRouter(
    initialLocation: initialLocation ?? RouteDefs.home,
    initialExtra: initialExtra,
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const HomeScreen(),
        routes: [
          GoRoute(
              path: RouteDefs.editNote.substring(1),
              builder: (context, state) {
                NoteModel? n;
                if (state.extra != null) {
                  n = state.extra! as NoteModel;
                }

                return EditNoteScreen(note: n);
              }),
          GoRoute(
              path: RouteDefs.manageCategories.substring(1),
              builder: (context, state) => const ListCategoriesScreen()),
        ],
      ),
    ],
  );
}
