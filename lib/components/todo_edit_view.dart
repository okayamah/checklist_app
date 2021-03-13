import 'dart:ui';

import 'package:checklist_app/models/todo_edit_view_model.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:checklist_app/configs/const_text.dart';
import 'package:checklist_app/entity/checklist.dart';
import 'package:checklist_app/entity/task.dart';
import 'package:checklist_app/repositories/todo_bloc.dart';
import 'package:checklist_app/repositories/task_bloc.dart';
import 'package:checklist_app/common_widget/text_field.dart';
import 'package:checklist_app/common_widget/icon_field.dart';

class TodoEditView extends StatefulWidget {
  final DateFormat _format = DateFormat("yyyy-MM-dd HH:mm");

  final ChecklistBloc todoBloc;
  final TaskBloc taskBloc;
  final Checklist todo;
  final List<Task> taskList;
  final Checklist _newTodo = Checklist.newTodo();
  final bool isNew;

  TodoEditView(
      {Key key,
      @required this.todoBloc,
      @required this.todo,
      @required this.isNew,
      this.taskBloc,
      this.taskList}) {
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
  _TodoEditViewState createState() => _TodoEditViewState();
}

class _TodoEditViewState extends State<TodoEditView> {
  var textFieldList = List<TextField>();

  var cards = <Card>[];
  Card addCard;
  TodoEditViewModel viewModel = new TodoEditViewModel();
  bool _enabled = true; // 閲覧：true, 編集：false

  Card createCard(TaskInfo taskInfo, int index) {
    if (taskInfo == null) {
      taskInfo = new TaskInfo();
      taskInfo.task = Task.init();
      taskInfo.status = false;
      taskInfo.isNew = true;
      viewModel.taskList.add(taskInfo);
    }
    TextEditingController jobController = TextEditingController();
    jobController.text = taskInfo.task.title;
    var textField = TextField(
      readOnly: _enabled,
      onChanged: (value) {
        taskInfo.task.title = value;
      },
      // enableInteractiveSelection: _enabled,
      onTap: () {
        if (_enabled) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            taskInfo.status = !taskInfo.status;
          });
        }
      },
      style: TextStyle(
          decoration: !taskInfo.status
              ? _enabled
                  ? TextDecoration.none
                  : TextDecoration.underline
              : TextDecoration.lineThrough),
      controller: jobController,
      decoration: InputDecoration(
        suffixIcon: _enabled
            ? CircularCheckBox(
                activeColor: AppColors.DEFAULT_COLOR,
                value: taskInfo.status,
                onChanged: (bool value) {
                  setState(() {
                    taskInfo.status = value;
                  });
                })
            : IconButton(
                icon: selectSuffixIcon(taskInfo.status),
                onPressed: () {
                  setState(() {
                    if (!_enabled) {
                      cards.removeAt(index);
                      if (viewModel != null) {
                        viewModel.taskList.remove(taskInfo);
                      }
                      if (taskInfo.task.id != null &&
                          taskInfo.task.id.isNotEmpty) {
                        widget.taskBloc
                            .delete(taskInfo.task.id, widget._newTodo.id);
                      }
                    } else {
                      taskInfo.status = !taskInfo.status;
                    }
                  });
                },
              ),
        border: InputBorder.none,
        hintText: 'タスクを入力',
        contentPadding:
            EdgeInsets.only(top: 10.0, right: 20.0, bottom: 10.0, left: 20.0),
      ),
    );
    textFieldList.add(textField);
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.black87)),
        child: textField
        //   ],
        // ),
        );
  }

  Icon selectSuffixIcon(bool status) {
    var icon = Icon(Icons.delete);

    if (_enabled) {
      switch (status) {
        case true:
          icon = Icon(Icons.check_box_outlined);
          break;
        case false:
          icon = Icon(Icons.check_box_outline_blank);
          break;
        default:
          icon = Icon(Icons.check_box_outline_blank);
          break;
      }
    }
    return icon;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isNew) {
      _enabled = false;
    }

    // カードリスト生成
    viewModel = TodoEditViewModel.init();
    cards.clear();

    if (widget.taskList != null) {
      var index = 0;
      widget.taskList.forEach((e) {
        TaskInfo taskInfo = new TaskInfo(task: e, status: false, isNew: true);
        Card card = createCard(taskInfo, index);
        cards.insert(index, card);

        viewModel.taskList.add(taskInfo);
        index++;
      });
    }
    addAddCard();
  }

  void addAddCard() {
    if (addCard == null) {
      addCard = Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.black87)),
          child: ListTile(
            leading: ClipOval(
              child: GestureDetector(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                  width: 40,
                  height: 40,
                  child: InkWell(
                    child: SizedBox(
                      child: Image.asset('assets/images/add.png'),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              ConstText.cardAddNewItem,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            onTap: () {
              setState(() {
                if (_enabled) {
                  _changeStatus();
                }
                cards.insert(
                    cards.length - 1, createCard(null, cards.length - 1));
              });
            },
          ));
    }
    cards.add(addCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        leading: IconButton(
          color: const Color(0xff000000),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        actions: [
          !_enabled
              ? FlatButton.icon(
                  onPressed: () {
                    print("tap!!! edit:${_enabled.toString()}");

                    // 新規作成の場合は編集中固定
                    if (!widget.isNew) {
                      _changeStatus();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(
                    Icons.clear,
                    color: const Color(0xff000000),
                  ),
                  label: Text('編集中'),
                )
              : IconButton(
                  color: const Color(0xff000000),
                  onPressed: () {
                    print("tap!!! edit:${_enabled.toString()}");
                    _changeStatus();
                  },
                  icon: Icon(Icons.edit),
                )
        ],
      ),
      // ページビュー
      body: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
        child: Column(
          children: <Widget>[
            _titleTextFormField(),
            _iconFormField(widget._newTodo.icon.isNotEmpty
                ? int.parse(widget._newTodo.icon)
                : 0),
            _dueDateTimeFormField(),
            _noteTextFormField(),
            // Expanded(child: SizedBox()),
            Expanded(
              child: widget._newTodo.id != null
                  ? FutureBuilder(
                      future:
                          widget.taskBloc.selectTasksByTodoId(widget._newTodo),
                      builder: (BuildContext context,
                          AsyncSnapshot<TodoEditViewModel> snapshot) {
                        if (snapshot.hasData) {
                          if (viewModel.checklist == null) {
                            viewModel.checklist = snapshot.data.checklist;
                            viewModel.taskList.addAll(snapshot.data.taskList);
                          } else {
                            // 追加ボタン以外を削除
                            var dbNum = viewModel.taskList
                                .where((e) => !e.isNew)
                                .length;
                            cards.removeRange(0, dbNum);
                          }

                          // cardオブジェクトを生成し、リストに詰める
                          // for (var item
                          //     in viewModel.taskList.where((e) => !e.isNew)) {
                          //   Card card = createCard(item, cards.length - 1);
                          //   cards.insert(cards.length - 1, card);
                          // }
                          viewModel.taskList
                              .where((e) => !e.isNew)
                              .toList()
                              .asMap()
                              .forEach((int index, TaskInfo item) {
                            Card card = createCard(item, index);
                            cards.insert(index, card);
                          });
                          return ListView.builder(
                            itemCount: cards.length,
                            itemBuilder: (lctx, index) {
                              // Card card = createCard(
                              //     viewModel.taskList[index],
                              //     cards.length - 1);
                              // cards.insert(cards.length - 1, card);
                              // return card;
                              return Visibility(
                                visible: true,
                                child: cards[index],
                              );
                            },
                          );
                        } else {
                          return Text("読み込み中");
                        }
                      },
                    )
                  : ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cards[index];
                      },
                    ),
            ),
            // Visibility(
            //   child:
            _confirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _titleTextFormField() => TextFieldWidget(
        title: ConstText.cardTitle,
        value: widget._newTodo.title,
        onChanged: _setTitle,
      );

  Widget _iconFormField(int icon) => IconFormField(
        title: ConstText.cardIcon,
        groupValue: icon,
        radioHandler: _selectIcon,
        error: null,
      );

  void _setTitle(String title) {
    widget._newTodo.title = title;
  }

  void _selectIcon(int icon) {
    widget._newTodo.icon = icon.toString();
  }

  void _changeStatus() {
    setState(() {
      _enabled = !_enabled;
      // for (var textField in textFieldList) {
      //   textField.enabled = _enabled;
      // }
    });
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
                      format: widget._format,
                      initialValue: widget._newTodo.dueDate ?? DateTime.now(),
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
    widget._newTodo.dueDate = dt;
  }

  Widget _noteTextFormField() => Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(ConstText.cardTask,
                      style: TextStyle(fontSize: 13.0, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _confirmButton(BuildContext context) => ButtonTheme(
        minWidth: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        child: RaisedButton(
          child: Text(widget.isNew ? ConstText.cardAdd : ConstText.cardOK,
              style: TextStyle(fontSize: 20)),
          onPressed: () async {
            widget._newTodo.title =
                widget._newTodo.title == "" ? "test" : widget._newTodo.title;
            if (widget._newTodo.id == null) {
              widget.todoBloc.insert(widget._newTodo).then((todoId) async {
                for (var taskInfo in viewModel.taskList) {
                  if (taskInfo.task.title != "") {
                    widget.taskBloc.insertTaskWithTodo(taskInfo, todoId);
                  }
                }
              });
            } else {
              for (var taskInfo in viewModel.taskList) {
                if ((taskInfo.task.id == null || taskInfo.task.id.isEmpty) &&
                    taskInfo.task.title != "") {
                  await widget.taskBloc
                      .insertTaskWithTodo(taskInfo, widget._newTodo.id);
                } else if (taskInfo.task.id.isNotEmpty &&
                    taskInfo.task.title != "") {
                  await widget.taskBloc.update(taskInfo, widget._newTodo.id);
                }
              }
              await widget.todoBloc.update(widget._newTodo);
            }
            Navigator.of(context).pop();
          },
          shape: StadiumBorder(),
          color: AppColors.DEFAULT_COLOR,
          textColor: Colors.white,
        ),
      );
}
