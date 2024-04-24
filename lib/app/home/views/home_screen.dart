import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_notebook/route_config.dart';
import 'package:flutter_notebook/data/database/sort_order.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_notebook/app/notes/views/widgets/notes_list.dart';
import 'package:flutter_notebook/widgets/delete_confirmation_dialog.dart';
import 'package:flutter_notebook/app/category/views/widgets/category_dropdown.dart';
import 'package:flutter_notebook/app/notes/controllers/notes_controller.dart';
import 'package:flutter_notebook/app/home/controllers/home_filter_controller.dart';
import 'package:flutter_notebook/app/home/controllers/home_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentCategory = ref.watch(activeCategory);
    final currentSortOrder = ref.watch(activeSortOrder);
    final currentNotes = ref.watch(homeControllerProvider(
        currentCategory?.categoryId, currentSortOrder ?? SortOrder.az));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Notebook'), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Note',
            onPressed: () async {
              context.push(RouteDefs.editNote);
            },
          ),
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Manage Categories',
            onPressed: () async {
              context.push(RouteDefs.manageCategories);
            },
          ),
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Filter"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: CategoryDropdown(
                            categoryId: ref
                                .watch(activeCategory.notifier)
                                .state
                                ?.categoryId,
                            onChanged: (category) {
                              ref.read(activeCategory.notifier).state =
                                  category;
                            },
                            noneNodeText: 'All',
                          ),
                        ),
                        Container(width: 20),
                        Flexible(
                          child: buildSortOrderDropdown(),
                        )
                      ],
                    ),
                  ],
                )),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: currentNotes.when(
                      data: (notes) {
                        return NotesList(
                          noteList: notes,
                          onEditNote: (noteId) {
                            context.go(RouteDefs.editNote,
                                extra: notes
                                    .where((n) => n.note.noteId == noteId)
                                    .first
                                    .note);
                          },
                          onDeleteNote: (noteId) {
                            showAdaptiveDialog(
                                context: context,
                                builder: (_) => DeleteConfirmationDialog(
                                    title: 'Remove this Note',
                                    content:
                                        'Are you sure you want to remove this note?',
                                    onConfirmDelete: () async {
                                      ref
                                          .read(
                                              notesControllerProvider.notifier)
                                          .deleteNote(noteId: noteId);
                                    }));
                          },
                        );
                      },
                      error: (e, s) {
                        debugPrintStack(label: e.toString(), stackTrace: s);
                        return const Text('An error has occured');
                      },
                      loading: () => const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    ))),
          ],
        ),
      ),
    );
  }

  DropdownButtonFormField<SortOrder> buildSortOrderDropdown() {
    return DropdownButtonFormField<SortOrder>(
        decoration: const InputDecoration(labelText: "Sort Order"),
        value: ref.watch(activeSortOrder.notifier).state,
        items: SortOrder.values
            .map((e) => DropdownMenuItem<SortOrder>(
                  key: Key(e.name),
                  value: e,
                  child: Text(e.niceName),
                ))
            .toList(),
        onChanged: (sortOrder) {
          ref.read(activeSortOrder.notifier).state = sortOrder;
        });
  }
}
