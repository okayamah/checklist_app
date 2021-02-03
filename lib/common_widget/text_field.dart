import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({this.title, this.value, this.onChanged});

  /// Title to show
  final String title;

  /// TextField to show
  final String value;

  /// Callback that fires when the user taps on this widget
  final void Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: TextStyle(fontSize: 13.0, color: Colors.black54)),
                // SizedBox(height: 4.0),
                TextFormField(
                    initialValue: value,
                    style: TextStyle(fontSize: 20.0),
                    maxLines: 1,
                    onChanged: onChanged),
                Divider(height: 1.0, color: Colors.black87),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
