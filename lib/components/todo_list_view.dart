import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:checklist_app/models/todo_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:checklist_app/common_widget/popup_menu.dart';
import 'package:checklist_app/components/todo_edit_view.dart';
import 'package:checklist_app/configs/const_text.dart';
import 'package:checklist_app/entity/checklist.dart';
import 'package:checklist_app/repositories/todo_bloc.dart';
import 'package:checklist_app/repositories/task_bloc.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TodoListView extends StatelessWidget {
  // final ChecklistBloc bloc;
  // final TaskBloc taskBloc;
  final Function moveItemListFunc;
  TodoListView({this.moveItemListFunc //, this.bloc, this.taskBloc
      });

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<ChecklistBloc>(context, listen: false);
    final _taskBloc = Provider.of<TaskBloc>(context, listen: false);

    // // アイテムのプリセット
    // _taskBloc.selectAll().then((ret) {
    //   print(ret.toString());
    // });

    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: StreamBuilder<TodoListViewModel>(
        stream: _bloc.todoStream,
        //   FutureBuilder(
        // future: _bloc.selectAllWithStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<TodoListViewModel> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.checklist.length > 0) {
              snapshot.data.checklist
                  .sort((a, b) => b.check.dueDate.compareTo(a.check.dueDate));
              var dates = snapshot.data.checklist
                  .map((e) =>
                      new DateFormat('yyyy/MM/dd').format(e.check.dueDate))
                  .toSet()
                  .toList();
              return GroupListView(
                sectionsCount: dates.length,
                countOfItemInSection: (int section) {
                  return snapshot.data.checklist
                      .where((e) =>
                          new DateFormat('yyyy/MM/dd')
                              .format(e.check.dueDate) ==
                          dates[section])
                      .length;
                },
                itemBuilder: (BuildContext context, IndexPath index) {
                  ChecklistInfo todo = snapshot.data.checklist
                      .where((e) =>
                          new DateFormat('yyyy/MM/dd')
                              .format(e.check.dueDate) ==
                          dates[index.section])
                      .toList()[index.index];
                  return Card(
                      margin: EdgeInsets.only(
                          left: 4.0, top: 0.0, right: 4.0, bottom: 0.0),
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
                                    color: _getAvatarColor(
                                        todo.check.icon.isEmpty != true
                                            ? todo.check.icon
                                            : "1")),
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
                              color:
                                  !todo.status ? Colors.black : Colors.black45,
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
                        // Icon(Icons.arrow_forward_ios),
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
                groupHeaderBuilder: (BuildContext context, int section) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Text(
                      dates[section],
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10),
                sectionSeparatorBuilder: (context, section) =>
                    SizedBox(height: 10),
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
      floatingActionButton: buildSpeedDial(_bloc, _taskBloc, context),
    );
  }

  SpeedDial buildSpeedDial(
      ChecklistBloc _bloc, TaskBloc _taskBloc, BuildContext context) {
    return SpeedDial(
      /// both default to 16
      marginEnd: 18,
      marginBottom: 20,
      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      /// This is ignored if animatedIcon is non null
      icon: Icons.menu,
      activeIcon: Icons.remove,
      // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),

      /// The label of the main button.
      // label: Text("Open Speed Dial"),
      /// The active label of the main button, Defaults to label if not specified.
      // activeLabel: Text("Close Speed Dial"),
      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
      buttonSize: 56.0,
      visible: true,

      /// If true user is forced to close dial manually
      /// by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Color(0xccA01D26),
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      children: [
        SpeedDialChild(
          child: Icon(Icons.touch_app),
          backgroundColor: Color(0xccA01D26),
          foregroundColor: Colors.white,
          label: 'アイテムからリストを作成',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            moveItemListFunc(true, false);
            // var itemView = ItemListView(
            //   taskBloc: _taskBloc,
            // );
            // // 編集画面へ
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return itemView;
            //     },
            //   ),
            // );
          },
          onLongPress: () => print('SECOND CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Color(0xccA01D26),
          foregroundColor: Colors.white,
          label: '一からリストを作成',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            var editView = TodoEditView(
              todoBloc: _bloc,
              todo: Checklist.newTodo(),
              isNew: true,
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
          onLongPress: () => print('THIRD CHILD LONG PRESS'),
        ),
      ],
    );
  }

  Color _getAvatarColor(String colorIndex) {
    return AppColors.avatarColors[int.parse(colorIndex) - 1];
  }
}
