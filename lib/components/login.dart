import 'package:flutter/material.dart';
import 'package:checklist_app/components/app.dart';
import 'package:checklist_app/configs/const_text.dart';

class Login extends StatefulWidget {
  final VoidCallback startBtn;
  final String text;
  final Color color;

  Login({
    Key key,
    this.startBtn,
    this.text = 'Check list',
    this.color = const Color(0xfff4f4ef),
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0eb4c2),
      body: ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        child: Align(
          alignment: Alignment.center, // 赤いコンテナを右上に配置する
          child: Column(
            // 中央寄せ
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/titleLogo.png',
              ),
              RaisedButton(
                elevation: 16,
                child: Text(
                  ConstText.start,
                  style: TextStyle(
                    fontFamily: 'puikko',
                    fontSize: 20,
                    color: const Color(0xcc0eb4c2),
                  ),
                  textAlign: TextAlign.left,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ChecklistApp()));
                },
                color: const Color(0xfff4f4ef),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
