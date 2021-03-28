import 'package:badges/badges.dart';
import 'package:checklist_app/configs/const_text.dart';
import 'package:checklist_app/models/item_list_view_model.dart';
import 'package:checklist_app/models/todo_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checklist_app/components/item_list_view.dart';
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
  ChecklistAppState createState() => ChecklistAppState();
}

// SingleTickerProviderStateMixinを使用。後述
class ChecklistAppState extends State<ChecklistApp>
    with SingleTickerProviderStateMixin {
  // widgetアクセス用キー
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  GlobalKey<ItemListViewState> itemListViewGlobalKey =
      GlobalKey<ItemListViewState>();

  // ページ切り替え用のコントローラを定義
  PageController _pageController;

  // ページインデックス保存用
  int _screen = 0;
  int _beforeScreen = 0; // 前画面

  // ヘッダータイトル
  String _header = ConstText.todoListView;

  // アイテム一覧画面の表示モード
  bool _selectingmode = false; // true:選択モード

  // 買い物カートに表示するカウンター
  List<ItemInfo> cart = List<ItemInfo>();

  // Bloc
  final ChecklistBloc checklistBloc = new ChecklistBloc();
  final TaskBloc taskBloc = new TaskBloc();
  final ChecklistBloc checklistBloc2 = new ChecklistBloc();
  final TaskBloc taskBloc2 = new TaskBloc();
  final ChecklistBloc checklistBloc3 = new ChecklistBloc();
  final TaskBloc taskBloc3 = new TaskBloc();

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

  // String getHeader() {
  //   switch (_screen) {
  //     case 0:
  //       _header = ConstText.todoListView;
  //       break;
  //     case 1:
  //       _header = "アイテム一覧";
  //       break;
  //     case 2:
  //       _header = "カレンダー";
  //       break;
  //     default:
  //       _header = ConstText.todoListView;
  //       break;
  //   }
  //   return _header;
  // }

  // インデックスに従って遷移
  void changePage(int index) {
    setState(() {
      // // ページインデックスを更新
      // _beforeScreen = _screen;
      // _screen = index;

      // 選択中フラグはfalseにする
      _selectingmode = false;
      cart.clear();

      // アイテム一覧画面への遷移であれば、ヘッダータイトルを更新する
      if (index == 1) {
        _header = "アイテム一覧";

        // 各アイテムの選択状態を初期化
        itemListViewGlobalKey.currentState.viewModel.taskInfoList.forEach((e) {
          e.isSelected = false;
        });
      }

      // ページ遷移を定義。
      // curveで指定できるのは以下
      // https://api.flutter.dev/flutter/animation/Curves-class.html
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  // アイテム選択画面へ遷移
  void changeItemList(bool selectingmode, bool isFromItemList) {
    setState(() {
      // ページインデックスを更新
      _selectingmode = selectingmode;
      _header = "アイテム選択中";

      // アイテム一覧画面からの遷移であれば、前画面インデックスを更新
      if (isFromItemList) {
        _beforeScreen = 1; // アイテム一覧画面
      }

      // 表示しているページがアイテム一覧でなければ遷移
      if (_screen != 1) {
        // _beforeScreen = _screen;
        // _screen = 1;

        // ページ遷移を定義。
        // curveで指定できるのは以下
        // https://api.flutter.dev/flutter/animation/Curves-class.html
        _pageController.animateToPage(1,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  // 買い物カートウィジェット
  Widget _shoppingCartBadge() {
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Badge(
        // padding: const EdgeInsets.only(right: 0.0),
        position: BadgePosition.topEnd(top: 0, end: 3),
        animationDuration: Duration(milliseconds: 300),
        animationType: BadgeAnimationType.fade,
        badgeContent: Text(
          cart.length.toString(),
          style: TextStyle(color: Colors.white),
        ),
        child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      // Appbar
      appBar: AppBar(
        leading: !_selectingmode // アイテム選択中是非
            ? IconButton(
                // 通常はドロワーボタン
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _key.currentState.openDrawer();
                },
              )
            : IconButton(
                // アイテム選択画面ではキャンセルボタン
                icon: const Icon(Icons.close),
                onPressed: () {
                  changePage(_beforeScreen);
                },
              ),
        elevation: 0.0,
        title: Text(
          _header,
          style: TextStyle(
            fontFamily: 'puikko',
            fontSize: 24,
            color: const Color(0xfff4f4ef),
          ),
          textAlign: TextAlign.left,
        ),
        backgroundColor: AppColors.DEFAULT_COLOR,
        actions: <Widget>[
          if (_selectingmode) _shoppingCartBadge(),
        ],
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
              _beforeScreen = _screen;
              _screen = index;

              // アイテム一覧以外への遷移であれば選択モードフラグを初期化.
              if (index != 1) {
                _selectingmode = false;
              }

              // ヘッダー名の更新
              switch (_screen) {
                case 0:
                  _header = ConstText.todoListView;
                  break;
                case 1:
                  if (!_selectingmode) {
                    _header = "アイテム一覧";
                  } else {
                    _header = "アイテム選択中";
                  }
                  break;
                case 2:
                  _header = "カレンダー";
                  break;
                default:
                  _header = ConstText.todoListView;
                  break;
              }
            });
          },
          // ページ下部のナビゲーションメニューに相当する各ページビュー。後述
          children: [
            // ホーム画面
            MultiProvider(
              providers: [
                Provider<ChecklistBloc>(
                  create: (context) => new ChecklistBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                ),
                Provider<TaskBloc>(
                  create: (context) => new TaskBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                )
              ],
              child: TodoListView(
                moveItemListFunc: changeItemList,
                // bloc: checklistBloc,
                // taskBloc: taskBloc,
              ),
            ),
            // アイテムリスト画面
            MultiProvider(
              providers: [
                Provider<ChecklistBloc>(
                  create: (context) => new ChecklistBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                ),
                Provider<TaskBloc>(
                  create: (context) => new TaskBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                )
              ],
              child: ItemListView(
                key: itemListViewGlobalKey,
                selectingmode: _selectingmode,
                moveItemListFunc: changeItemList,
                // bloc: checklistBloc2,
                // taskBloc: taskBloc2,
              ),
            ),
            // カレンダー画面
            MultiProvider(
              providers: [
                Provider<ChecklistBloc>(
                  create: (context) => new ChecklistBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                ),
                Provider<TaskBloc>(
                  create: (context) => new TaskBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                )
              ],
              child: CalendarScreen(
                  // bloc: checklistBloc3,
                  // taskBloc: taskBloc3,
                  ),
            ),
          ]),
      // ページ下部のナビゲーションメニュー
      bottomNavigationBar: Visibility(
        visible: !_selectingmode,
        child: BottomNavigationBar(
          fixedColor: AppColors.DEFAULT_COLOR,
          // 現在のページインデックス
          currentIndex: _screen,
          // onTapでナビゲーションメニューがタップされた時の処理を定義
          onTap: (index) {
            setState(() {
              // ページインデックスを更新
              // _beforeScreen = _screen;
              // _screen = index;

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
