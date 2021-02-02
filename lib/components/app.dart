import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checklist_app/repositories/todo_bloc.dart';

import 'todo_list_view.dart';

class ChecklistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<ChecklistBloc>(
        create: (context) => new ChecklistBloc(),
        dispose: (context, bloc) => bloc.dispose(),
        child: TodoListView());
  }
}
