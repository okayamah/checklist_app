import 'package:checklist_app/configs/const_text.dart';
import 'package:checklist_app/models/todo_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checklist_app/repositories/todo_bloc.dart';
import 'package:checklist_app/repositories/task_bloc.dart';

import 'calendar.dart';
import 'item_list_view.dart';
import 'todo_list_view.dart';

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(providers: [
//       Provider<ChecklistBloc>(
//         create: (context) => new ChecklistBloc(),
//         dispose: (context, bloc) => bloc.dispose(),
//       ),
//       Provider<TaskBloc>(
//         create: (context) => new TaskBloc(),
//         dispose: (context, bloc) => bloc.dispose(),
//       )
//     ], child: TodoListView());
//     // return Provider<ChecklistBloc>(
//     //     create: (context) => new ChecklistBloc(),
//     //     dispose: (context, bloc) => bloc.dispose(),
//     //     child: TodoListView());
//   }
// }

class ChecklistApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// SingleTickerProviderStateMixinを使用。後述
class _MyHomePageState extends State<ChecklistApp>
    with SingleTickerProviderStateMixin {
  // ページ切り替え用のコントローラを定義
  PageController _pageController;

  // ページインデックス保存用
  int _screen = 0;

  // ヘッダータイトル
  String _header = ConstText.todoListView;

  // アイテム一覧画面の表示モード
  bool _selectingmode = false; // 選択モード

  // ページ下部に並べるナビゲーションメニューの一覧
  List<BottomNavigationBarItem> myBottomNavBarItems() {
    return [
      new BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      new BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('Search'),
      ),
      new BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today), title: Text('Calendar')),
    ];
  }

  @override
  void initState() {
    super.initState();
    // コントローラ作成
    _pageController = PageController(
      initialPage: _screen, // 初期ページの指定。上記で_screenを１とすれば２番目のページが初期表示される。
    );

    // プリセットアイテムの登録
    TaskBloc taskBloc = new TaskBloc();
    // taskBloc.selectAll().then((value) {
    //   if (value.length == 0) {
    TodoEditViewModel viewModel = TodoEditViewModel.map(Preset.items);
    taskBloc.insertTasks(viewModel.taskList);
    //   }
    // });
  }

  @override
  void dispose() {
    // コントローラ破棄
    _pageController.dispose();
    super.dispose();
  }

  String getHeader() {
    switch (_screen) {
      case 0:
        _header = ConstText.todoListView;
        break;
      case 1:
        _header = "アイテム一覧";
        break;
      case 2:
        _header = "カレンダー";
        break;
      default:
        _header = ConstText.todoListView;
        break;
    }
    return _header;
  }

  void changeItemList(bool selectingmode) {
    setState(() {
      // ページインデックスを更新
      _selectingmode = selectingmode;

      // 表示しているページがアイテム一覧でなければ遷移
      if (_screen != 1) {
        _screen = 1;

        // ページ遷移を定義。
        // curveで指定できるのは以下
        // https://api.flutter.dev/flutter/animation/Curves-class.html
        _pageController.animateToPage(1,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          getHeader(),
          style: TextStyle(
            fontFamily: 'puikko',
            fontSize: 24,
            color: const Color(0xfff4f4ef),
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: AppColors.DEFAULT_COLOR,
      ),
      // ),
      // ページビュー
      body: PageView(
          controller: _pageController,
          // ページ切り替え時に実行する処理
          // PageViewのonPageChangedはページインデックスを受け取る
          // 以下ではページインデックスをindexとする
          onPageChanged: (index) {
            setState(() {
              // ページインデックスを更新
              _screen = index;

              // アイテム一覧以外への遷移であれば選択モードフラグを初期化.
              if (index != 1) {
                _selectingmode = false;
              }
            });
          },
          // ページ下部のナビゲーションメニューに相当する各ページビュー。後述
          children: [
            // ホーム画面
            MultiProvider(providers: [
              Provider<ChecklistBloc>(
                create: (context) => new ChecklistBloc(),
                dispose: (context, bloc) => bloc.dispose(),
              ),
              Provider<TaskBloc>(
                create: (context) => new TaskBloc(),
                dispose: (context, bloc) => bloc.dispose(),
              )
            ], child: TodoListView(moveItemListFunc: changeItemList)),
            // アイテムリスト画面
            MultiProvider(providers: [
              Provider<ChecklistBloc>(
                create: (context) => new ChecklistBloc(),
                dispose: (context, bloc) => bloc.dispose(),
              ),
              Provider<TaskBloc>(
                create: (context) => new TaskBloc(),
                dispose: (context, bloc) => bloc.dispose(),
              )
            ], child: ItemListView(selectingmode: _selectingmode)),
            // カレンダー画面
            MultiProvider(providers: [
              Provider<ChecklistBloc>(
                create: (context) => new ChecklistBloc(),
                dispose: (context, bloc) => bloc.dispose(),
              ),
              Provider<TaskBloc>(
                create: (context) => new TaskBloc(),
                dispose: (context, bloc) => bloc.dispose(),
              )
            ], child: CalendarScreen()),
          ]),
      // ページ下部のナビゲーションメニュー
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: AppColors.DEFAULT_COLOR,
        // 現在のページインデックス
        currentIndex: _screen,
        // onTapでナビゲーションメニューがタップされた時の処理を定義
        onTap: (index) {
          setState(() {
            // ページインデックスを更新
            _screen = index;

            // ページ遷移を定義。
            // curveで指定できるのは以下
            // https://api.flutter.dev/flutter/animation/Curves-class.html
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.easeOut);
          });
        },
        // 定義済のナビゲーションメニューのアイテムリスト
        items: myBottomNavBarItems(),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'ドロワー',
                style: TextStyle(
                  fontFamily: 'puikko',
                  fontSize: 20,
                  color: const Color(0xfff4f4ef),
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.DEFAULT_COLOR,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
