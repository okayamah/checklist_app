import 'dart:ui';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:checklist_app/configs/const_text.dart';
import 'package:checklist_app/models/checklist.dart';
import 'package:checklist_app/repositories/todo_bloc.dart';
import 'package:checklist_app/common_widget/text_field.dart';
import 'package:checklist_app/common_widget/icon_field.dart';

class TodoEditView extends StatelessWidget {
  final DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");

  final ChecklistBloc todoBloc;
  final Checklist todo;
  final Checklist _newTodo = Checklist.newTodo();
  final bool isNew;

  TodoEditView(
      {Key key,
      @required this.todoBloc,
      @required this.todo,
      @required this.isNew}) {
    // Dartでは参照渡しが行われるため、todoをそのまま編集してしまうと、
    // 更新せずにリスト画面に戻ったときも値が更新されてしまうため、
    // 新しいインスタンスを作る
    _newTodo.id = todo.id;
    _newTodo.title = todo.title;
    _newTodo.dueDate = todo.dueDate;
    _newTodo.note = todo.note;
    _newTodo.icon = todo.icon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          _titleTextFormField(),
          _iconFormField(
              _newTodo.icon.isNotEmpty ? int.parse(_newTodo.icon) : 0),
          _dueDateTimeFormField(),
          _noteTextFormField(),
          Expanded(child: SizedBox()),
          _confirmButton(context)
        ],
      ),
    );
  }

  Widget _titleTextFormField() => TextFieldWidget(
        title: ConstText.cardTitle,
        value: _newTodo.title,
        onChanged: _setTitle,
      );

  Widget _iconFormField(int icon) => IconFormField(
        title: ConstText.cardIcon,
        groupValue: icon,
        radioHandler: _selectIcon,
        error: null,
      );

  void _setTitle(String title) {
    _newTodo.title = title;
  }

  void _selectIcon(int icon) {
    _newTodo.icon = icon.toString();
  }

  // ↓ https://pub.dev/packages/datetime_picker_formfield のサンプルから引用
  Widget _dueDateTimeFormField() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(ConstText.cardDate,
                      style: TextStyle(fontSize: 13.0, color: Colors.black54)),
                  // SizedBox(height: 4.0),
                  DateTimeField(
                      style: TextStyle(fontSize: 20.0),
                      format: _format,
                      initialValue: _newTodo.dueDate ?? DateTime.now(),
                      onChanged: _setDueDate,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      }),
                  Divider(height: 1.0, color: Colors.black87),
                ],
              ),
            ),
          ],
        ),
      );

  void _setDueDate(DateTime dt) {
    _newTodo.dueDate = dt;
  }

  Widget _noteTextFormField() => TextFieldWidget(
        title: ConstText.cardTask,
        value: _newTodo.note,
        onChanged: _setNote,
      );

  void _setNote(String note) {
    _newTodo.note = note;
  }

  Widget _confirmButton(BuildContext context) => ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        child: isNew
            ? RaisedButton(
                child: Text(ConstText.cardAdd, style: TextStyle(fontSize: 20)),
                onPressed: () {
                  _newTodo.title =
                      _newTodo.title == "" ? "test" : _newTodo.title;
                  if (_newTodo.id == null) {
                    todoBloc.create(_newTodo);
                  } else {
                    todoBloc.update(_newTodo);
                  }

                  Navigator.of(context).pop();
                },
                shape: StadiumBorder(),
                color: Color(0xcc0eb4c2),
                textColor: Colors.white,
              )
            : Row(
                children: [
                  RaisedButton(
                    child:
                        Text(ConstText.cardOK, style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      _newTodo.title =
                          _newTodo.title == "" ? "test" : _newTodo.title;
                      if (_newTodo.id == null) {
                        todoBloc.create(_newTodo);
                      } else {
                        todoBloc.update(_newTodo);
                      }

                      Navigator.of(context).pop();
                    },
                    shape: StadiumBorder(),
                    color: Color(0xcc0eb4c2),
                    textColor: Colors.white,
                  ),
                ],
              ),
      );
}
