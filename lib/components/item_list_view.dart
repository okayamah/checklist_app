import 'package:checklist_app/common_widget/colord_tab_bar.dart';
import 'package:checklist_app/common_widget/selfmade_icon.dart';
import 'package:checklist_app/entity/task.dart';
import 'package:checklist_app/models/item_list_view_model.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:expandable_group/expandable_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checklist_app/common_widget/popup_menu.dart';
import 'package:checklist_app/components/todo_edit_view.dart';
import 'package:checklist_app/configs/const_text.dart';
import 'package:checklist_app/entity/checklist.dart';
import 'package:checklist_app/repositories/todo_bloc.dart';
import 'package:checklist_app/repositories/task_bloc.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ItemListView extends StatefulWidget {
  bool selectingmode = false; // 選択モード

  // コンストラクタ
  ItemListView({this.selectingmode});

  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  ItemListViewModel viewModel = new ItemListViewModel.init(); // ビューモデル

  var selectedColor = Colors.lightBlue;
  var mycolor = Colors.white;
  ChecklistBloc _bloc;
  TaskBloc _taskBloc;

  Widget _header(String name) => Text(name,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ));

  List<ListTile> _buildItems(BuildContext context, List<TaskInfo> items,
          ChecklistBloc _bloc, TaskBloc _taskBloc) =>
      items
          .map((task) => ListTile(
                onLongPress: () {
                  setState(() {
                    widget.selectingmode = true;
                    task.isSelected = true;
                  });
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 0.0),
                title: Text(
                  task.task.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                tileColor: task.isSelected
                    ? AppColors.DEFAULT_COLOR_LIGHT
                    : Colors.white,
                trailing: (widget.selectingmode)
                    ? CircularCheckBox(
                        activeColor: AppColors.DEFAULT_COLOR,
                        value: task.isSelected,
                        onChanged: (bool value) {
                          setState(() {
                            task.isSelected = value;
                          });
                        })
                    : PopUpMenu(
                        onCreate: () {},
                        onEdit: () {},
                        onDelete: () {},
                      ),
                onTap: () {
                  if (widget.selectingmode) {
                    setState(() {
                      task.isSelected = !task.isSelected;
                    });
                  }
                },
              ))
          .toList();

  TabBar get _tabBar => TabBar(
        indicator: ShapeDecoration(
          shape: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.DEFAULT_COLOR_SELECTED,
                  width: 3.0,
                  style: BorderStyle.solid)),
        ),
        labelColor: Color(0xfff4f4ef),
        unselectedLabelColor: Color(0x99f4f4ef),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        labelPadding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        tabs: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(WDLogo.material),
            SizedBox(width: 5),
            Text("アイテム")
          ]), //Tab(text: "material", icon: Icon(WDLogo.material)),
          // Tab(text: "menu", icon: Icon(WDLogo.menu)),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(WDLogo.menu), SizedBox(width: 5), Text("メニュー")]),
        ],
      );

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = Provider.of<ChecklistBloc>(context, listen: false);
    }
    if (_taskBloc == null) {
      _taskBloc = Provider.of<TaskBloc>(context, listen: false);
    }
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: ColoredTabBar(
            color: AppColors.DEFAULT_COLOR,
            tabBar: _tabBar,
          ),
          backgroundColor: Colors.white,
          body: new TabBarView(
            children: <Widget>[
              StreamBuilder<List<Task>>(
                stream: _taskBloc.taskStream,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      snapshot.data
                          .sort((a, b) => b.category?.compareTo(a.category));

                      // 既にロード済みかどうか
                      if (viewModel.taskInfoList.length == 0) {
                        snapshot.data.forEach((e) {
                          viewModel.taskInfoList
                              .add(new TaskInfo(task: e, isSelected: false));
                        });
                      }
                      var dates = viewModel.taskInfoList
                          .map((e) => e.task.category)
                          .toSet()
                          .toList();
                      // return Column(children: [
                      // Text('top text'),
                      return SingleChildScrollView(
                          child: Column(children: [
                        Text('top text'),
                        ListView(
                          shrinkWrap: true, //追加
                          physics: const NeverScrollableScrollPhysics(), //追加
                          children: <Widget>[
                            Column(
                              children: dates.map((group) {
                                int index = dates.indexOf(group);
                                return ExpandableGroup(
                                      // isExpanded: index == 0,
                                      header: _header(group),
                                      items: _buildItems(
                                          context,
                                          viewModel.taskInfoList
                                              .where((e) =>
                                                  e.task.category ==
                                                  dates[index])
                                              .toList(),
                                          _bloc,
                                          _taskBloc),
                                      headerEdgeInsets: EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                    );
                              }).toList(),
                            ),
                          ],
                        ),
                      ]));
                      // return GroupListView(
                      //   sectionsCount: dates.length,
                      //   countOfItemInSection: (int section) {
                      //     return viewModel.taskInfoList
                      //         .where((e) => e.task.category == dates[section])
                      //         .length;
                      //   },
                      //   itemBuilder: (BuildContext context, IndexPath index) {
                      //     TaskInfo task = viewModel.taskInfoList
                      //         .where((e) => e.task.category == dates[index.section])
                      //         .toList()[index.index];
                      //     // var editView =
                      //     //     TodoEditView(todoBloc: _bloc, todo: todo, isNew: false, taskBloc: _taskBloc,);
                      //     return
                      //         // Dismissible(
                      //         //   key: Key(todo.id),
                      //         //   background: _backgroundOfDismissible(),
                      //         //   secondaryBackground: _secondaryBackgroundOfDismissible(),
                      //         //   onDismissed: (direction) {
                      //         //     _bloc.delete(todo.id);
                      //         //   },
                      //         //   child:
                      //         Card(
                      //             margin: EdgeInsets.only(
                      //                 left: 4.0, top: 0.0, right: 4.0, bottom: 1.0),
                      //             color: task.isSelected
                      //                 ? AppColors.DEFAULT_COLOR_LIGHT
                      //                 : Colors.white,
                      //             child: ListTile(
                      //               onLongPress: () {
                      //                 setState(() {
                      //                   widget.selectingmode = true;
                      //                 });
                      //               },
                      //               contentPadding: const EdgeInsets.symmetric(
                      //                   horizontal: 18, vertical: 0.0),
                      //               // leading: ClipOval(
                      //               //   child: GestureDetector(
                      //               //     child: Container(
                      //               //       margin: EdgeInsets.symmetric(
                      //               //           horizontal: 0.0, vertical: 0.0),
                      //               //       width: 40,
                      //               //       height: 40,
                      //               //       decoration: BoxDecoration(
                      //               //         shape: BoxShape.circle,
                      //               //         border: Border.all(
                      //               //             style: BorderStyle.solid,
                      //               //             width: 1.0,
                      //               //             color: _getAvatarColor(task.icon.isEmpty != true
                      //               //                 ? task.icon
                      //               //                 : "1")),
                      //               //       ),
                      //               //       child: InkWell(
                      //               //         child: SizedBox(
                      //               //           child: Image.asset(AppColors.icons[
                      //               //               task.icon.isEmpty != true
                      //               //                   ? int.parse(task.icon) - 1
                      //               //                   : 0]),
                      //               //         ),
                      //               //       ),
                      //               //     ),
                      //               //   ),
                      //               // ),
                      //               title: Text(
                      //                 task.task.title,
                      //                 style: TextStyle(
                      //                     fontSize: 16, fontWeight: FontWeight.w400),
                      //               ),
                      //               trailing: (widget.selectingmode)
                      //                   ? // ( isSelected
                      //                   // ? Icon(Icons.check_box)
                      //                   // : Icon(Icons.check_box_outline_blank))
                      //                   CircularCheckBox(
                      //                       activeColor: AppColors.DEFAULT_COLOR,
                      //                       value: task.isSelected,
                      //                       onChanged: (bool value) {
                      //                         setState(() {
                      //                           task.isSelected = value;
                      //                         });
                      //                       })
                      //                   : PopUpMenu(
                      //                       onCreate: () {
                      //                         // 複製して新規作成画面へ
                      //                         var editView = TodoEditView(
                      //                           todoBloc: _bloc,
                      //                           todo: Checklist.newTodo(),
                      //                           isNew: true,
                      //                           taskBloc: _taskBloc,
                      //                         );
                      //                         Navigator.of(context).push(
                      //                           MaterialPageRoute(
                      //                             builder: (context) {
                      //                               return editView;
                      //                             },
                      //                           ),
                      //                         );
                      //                       },
                      //                       onEdit: () {
                      //                         // var editView = TodoEditView(
                      //                         //   todoBloc: _bloc,
                      //                         //   todo: todo,
                      //                         //   isNew: false,
                      //                         //   taskBloc: _taskBloc,
                      //                         // );
                      //                         // // 編集画面へ
                      //                         // showModalBottomSheet<void>(
                      //                         //     isScrollControlled: true,
                      //                         //     context: context,
                      //                         //     shape: RoundedRectangleBorder(
                      //                         //       borderRadius: BorderRadius.vertical(
                      //                         //           top: Radius.circular(16)),
                      //                         //     ),
                      //                         //     builder: (BuildContext context) {
                      //                         //       return editView;
                      //                         //     });
                      //                       },
                      //                       onDelete: () {
                      //                         // // カードを削除
                      //                         // _bloc.delete(todo.id);
                      //                       },
                      //                     ),
                      //               // Icon(Icons.arrow_forward_ios),
                      //               onTap: () {
                      //                 // var editView = TodoEditView(
                      //                 //   todoBloc: _bloc,
                      //                 //   todo: todo,
                      //                 //   isNew: false,
                      //                 //   taskBloc: _taskBloc,
                      //                 // );
                      //                 // // _moveToEditView(context, _bloc, todo);
                      //                 // showModalBottomSheet<void>(
                      //                 //     isScrollControlled: true,
                      //                 //     context: context,
                      //                 //     shape: RoundedRectangleBorder(
                      //                 //       borderRadius:
                      //                 //           BorderRadius.vertical(top: Radius.circular(16)),
                      //                 //     ),
                      //                 //     builder: (BuildContext context) {
                      //                 //       return editView;
                      //                 //     });
                      //               },
                      //             ));
                      //     // );
                      //   },
                      //   groupHeaderBuilder: (BuildContext context, int section) {
                      //     return Padding(
                      //       padding:
                      //           const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      //       child: Text(
                      //         dates[section],
                      //         style:
                      //             TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      //       ),
                      //     );
                      //   },
                      //   separatorBuilder: (context, index) => SizedBox(height: 0),
                      //   sectionSeparatorBuilder: (context, section) =>
                      //       SizedBox(height: 10),
                      // );
                    } else {
                      return Center(
                        child: Text(
                          ConstText.noTask,
                          style: TextStyle(
                            fontFamily: 'puikko',
                            fontSize: 30,
                            color: const Color(0xcc0eb4c2),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      );
                    }
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
              new Container(
                color: Colors.blueGrey,
                child: new Center(
                  child: new Text(
                    "Second",
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xccA01D26),
            foregroundColor: Colors.white,
            child: const Icon(
              Icons.check,
            ),
            onPressed: () {
              // 複製して新規作成画面へ
              var selectedItems =
                  viewModel.taskInfoList.where((e) => e.isSelected == true);
              List<Task> tasks = new List<Task>();
              selectedItems.forEach((e) {
                tasks.add(e.task);
              });
              var editView = TodoEditView(
                todoBloc: _bloc,
                todo: Checklist(
                    title: "", dueDate: DateTime.now(), note: "", icon: ""),
                isNew: true,
                taskBloc: _taskBloc,
                taskList: tasks,
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return editView;
                  },
                ),
              );
            },
          ),
          // floatingActionButton: buildSpeedDial(_bloc, _taskBloc, context),
        ));
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
          backgroundColor: Colors.blue,
          label: 'アイテムからリストを作成',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('SECOND CHILD'),
          onLongPress: () => print('SECOND CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          label: '一からリストを作成',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () {
            var editView = TodoEditView(
              todoBloc: _bloc,
              todo: Checklist.newTodo(),
              isNew: true,
              taskBloc: _taskBloc,
            );
            // _moveToCreateView(context, _bloc);
            showModalBottomSheet<void>(
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                  // <= 追加
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (BuildContext context) {
                  return editView;
                });
          },
          onLongPress: () => print('THIRD CHILD LONG PRESS'),
        ),
      ],
    );
  }
}
