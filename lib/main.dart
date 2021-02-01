import 'package:flutter/material.dart';
import 'package:checklist_app/components/login.dart';
import 'package:checklist_app/configs/const_text.dart';

void main() {
  runApp(new MaterialApp(
    title: ConstText.appTitle,
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    // ダークモード対応
    darkTheme: ThemeData(brightness: Brightness.dark),
    routes: <String, WidgetBuilder>{
      '/': (_) => new Splash(),
      '/login': (_) => new Login(),
    },
  ));
}

// ---------
// スプラッシュ
// ---------
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 3))
        .then((value) => handleTimeout());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        // TODO: スプラッシュアニメーション
        child: const CircularProgressIndicator(),
      ),
    );
  }

  void handleTimeout() {
    // ログイン画面へ
    Navigator.of(context).pushReplacementNamed("/login");
  }
}
