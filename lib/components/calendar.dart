import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:checklist_app/components/todo_edit_view.dart';
import 'package:checklist_app/common_widget/popup_menu.dart';
import 'package:checklist_app/configs/const_text.dart';
import 'package:checklist_app/entity/checklist.dart';
import 'package:checklist_app/models/todo_list_view_model.dart';
import 'package:checklist_app/repositories/task_bloc.dart';
import 'package:checklist_app/repositories/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  // // Bloc
  // final ChecklistBloc bloc;
  // final TaskBloc taskBloc;

  // コンストラクタ
  CalendarScreen();

  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
    });
  }

  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    if (_selectedDay == null) {
      _selectedDay = DateTime.now();
    }
  }

  @override
  dispose() {
    // widget.bloc.dispose();
    // widget.taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<ChecklistBloc>(context, listen: false);
    final _taskBloc = Provider.of<TaskBloc>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: FutureBuilder(
                  future: _bloc.selectGroupByDate(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<DateTime, List<dynamic>>> snapshot) {
                    if (snapshot.hasData) {
                      return Calendar(
                        hideArrows: false,
                        startOnMonday: true,
                        weekDays: [
                          "Mon",
                          "Tue",
                          "Wed",
                          "Thu",
                          "Fri",
                          "Sat",
                          "Sun"
                        ],
                        events: snapshot.data,
                        onRangeSelected: (range) =>
                            print("Range is ${range.from}, ${range.to}"),
                        onDateSelected: (date) => _handleNewDate(date),
                        isExpandable: true,
                        eventDoneColor: Colors.black54,
                        selectedColor: AppColors.DEFAULT_COLOR,
                        todayColor: AppColors.DEFAULT_COLOR,
                        eventColor: Colors.white70,
                        dayOfWeekStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 11),
                      );
                    } else {
                      return Text("処理中...");
                    }
                  }),
            ),
            _buildEventList(_bloc, _taskBloc)
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(ChecklistBloc _bloc, TaskBloc _taskBloc) {
    return Expanded(
      child: StreamBuilder<TodoListViewModel>(
        stream: _bloc.todoStream,
        builder:
            (BuildContext context, AsyncSnapshot<TodoListViewModel> snapshot) {
          if (snapshot.hasData) {
            var dataNum = snapshot.data.checklist
                .where((e) =>
                    _selectedDay != null &&
                    new DateFormat('yyyy/MM/dd').format(e.check.dueDate) ==
                        new DateFormat('yyyy/MM/dd').format(_selectedDay))
                .length;
            if (dataNum > 0) {
              snapshot.data.checklist
                  .sort((a, b) => b.check.dueDate.compareTo(a.check.dueDate));
              return ListView.builder(
                itemCount: dataNum,
                itemBuilder: (BuildContext context, int index) {
                  ChecklistInfo todo = snapshot.data.checklist
                      .where((e) =>
                          new DateFormat('yyyy/MM/dd')
                              .format(e.check.dueDate) ==
                          new DateFormat('yyyy/MM/dd').format(_selectedDay))
                      .toList()[index];
                  return Card(
                      child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10.0),
                    leading: ClipOval(
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                style: BorderStyle.solid,
                                width: 1.0,
                                color: AppColors.avatarColors[int.parse(
                                        todo.check.icon.isEmpty != true
                                            ? todo.check.icon
                                            : "1") -
                                    1]),
                          ),
                          child: InkWell(
                            child: SizedBox(
                              child: Image.asset(AppColors.icons[
                                  todo.check.icon.isEmpty != true
                                      ? int.parse(todo.check.icon) - 1
                                      : 0]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      todo.check.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: !todo.status ? Colors.black : Colors.black45,
                          decoration: !todo.status
                              ? TextDecoration.none
                              : TextDecoration.lineThrough),
                    ),
                    trailing: PopUpMenu(
                      onCreate: () {
                        // 複製して新規作成画面へ
                        var editView = TodoEditView(
                          todoBloc: _bloc,
                          todo: Checklist(
                              title: todo.check.title,
                              dueDate: DateTime.now(),
                              note: todo.check.note,
                              icon: todo.check.icon),
                          isNew: true,
                          taskBloc: _taskBloc,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return editView;
                            },
                          ),
                        );
                      },
                      onEdit: () {
                        var editView = TodoEditView(
                          todoBloc: _bloc,
                          todo: todo.check,
                          isNew: false,
                          taskBloc: _taskBloc,
                        );
                        // 編集画面へ
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return editView;
                            },
                          ),
                        );
                      },
                      onDelete: () {
                        AwesomeDialog(
                          context: context,
                          keyboardAware: true,
                          dismissOnBackKeyPress: true,
                          dialogType: DialogType.WARNING,
                          animType: AnimType.SCALE,
                          btnCancelText: "Cancel",
                          btnOkText: "OK",
                          title: '削除確認',
                          padding: const EdgeInsets.all(16.0),
                          desc: 'この買い物リストを削除しますか？',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            // カードを削除
                            _bloc.delete(todo.check.id);
                          },
                        ).show();
                      },
                    ),
                    onTap: () {
                      var editView = TodoEditView(
                        todoBloc: _bloc,
                        todo: todo.check,
                        isNew: false,
                        taskBloc: _taskBloc,
                      );
                      // 編集画面へ
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return editView;
                          },
                        ),
                      );
                    },
                  ));
                },
              );
            } else {
              return Center(
                child: Text(
                  ConstText.noTask,
                  style: TextStyle(
                    fontFamily: 'puikko',
                    fontSize: 30,
                    color: AppColors.DEFAULT_COLOR,
                  ),
                  textAlign: TextAlign.left,
                ),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
