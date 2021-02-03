import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:checklist_app/components/todo_edit_view.dart';
import 'package:checklist_app/configs/const_text.dart';
import 'package:checklist_app/models/checklist.dart';
import 'package:checklist_app/repositories/todo_bloc.dart';
import 'package:group_list_view/group_list_view.dart';

class TodoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<ChecklistBloc>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      appBar: AppBar(
        title: Text(
          ConstText.todoListView,
          style: TextStyle(
            fontFamily: 'Retro Stereo',
            fontSize: 20,
            color: const Color(0xfff4f4ef),
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Color(0xcc0eb4c2),
      ),
      body: StreamBuilder<List<Checklist>>(
        stream: _bloc.todoStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<Checklist>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              snapshot.data.sort((a, b) => b.dueDate.compareTo(a.dueDate));
              var dates = snapshot.data
                  .map((e) => new DateFormat('yyyy/MM/dd').format(e.dueDate))
                  .toSet()
                  .toList();
              return GroupListView(
                sectionsCount: dates.length,
                countOfItemInSection: (int section) {
                  return snapshot.data
                      .where((e) =>
                          new DateFormat('yyyy/MM/dd').format(e.dueDate) ==
                          dates[section])
                      .length;
                },
                itemBuilder: (BuildContext context, IndexPath index) {
                  Checklist todo = snapshot.data
                      .where((e) =>
                          new DateFormat('yyyy/MM/dd').format(e.dueDate) ==
                          dates[index.section])
                      .toList()[index.index];
                  return Dismissible(
                    key: Key(todo.id),
                    background: _backgroundOfDismissible(),
                    secondaryBackground: _secondaryBackgroundOfDismissible(),
                    onDismissed: (direction) {
                      _bloc.delete(todo.id);
                    },
                    child: Card(
                        child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10.0),
                      leading: CircleAvatar(
                        child: Text(
                          _getInitials(todo.title),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        backgroundColor: _getAvatarColor(todo.title),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // _moveToEditView(context, _bloc, todo);
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return TodoEditView(todoBloc: _bloc, todo: todo);
                            });
                      },
                    )),
                  );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _moveToCreateView(context, _bloc);
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return TodoEditView(todoBloc: _bloc, todo: Checklist.newTodo());
              }
          );
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
        backgroundColor: Color(0xccA01D26),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xcc0eb4c2),
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text('Calendar'))
        ],
      ),
    );
  }

  String _getInitials(String user) {
    var buffer = StringBuffer();
    var split = user.split(" ");
    for (var s in split) buffer.write(s[0]);

    return buffer.toString().substring(0, split.length);
  }

  Color _getAvatarColor(String user) {
    return AppColors
        .avatarColors[(user?.hashCode ?? 1) % AppColors.avatarColors.length];
  }

  _moveToEditView(BuildContext context, ChecklistBloc bloc, Checklist todo) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TodoEditView(todoBloc: bloc, todo: todo)));

  _moveToCreateView(BuildContext context, ChecklistBloc bloc) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              TodoEditView(todoBloc: bloc, todo: Checklist.newTodo())));

  _backgroundOfDismissible() => Container(
      alignment: Alignment.centerLeft,
      color: Colors.green,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Icon(Icons.done, color: Colors.white),
      ));

  _secondaryBackgroundOfDismissible() => Container(
      alignment: Alignment.centerRight,
      color: Colors.green,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Icon(Icons.done, color: Colors.white),
      ));
}
