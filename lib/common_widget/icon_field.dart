import 'package:flutter/material.dart';
import 'package:checklist_app/common_widget/radio_icon.dart';

class IconFormField extends StatefulWidget {
  IconFormField(
      {@required this.title,
      @required this.groupValue,
      @required this.radioHandler,
      this.error});

  /// `title` you want to ask
  final String title;

  /// `groupValue` is used to identify if the radio button is selected or not
  ///
  /// if (groupValue == value) then it means that radio button is selected
  int groupValue;

  /// `error` to be displayed below emojis row
  ///
  /// mostly used if no option is selected
  final String error;

  /// This function that will handle all radio button row values
  final Function radioHandler;

  /// Determines the number of radio buttons according to their taste
  ///
  /// 😠 😕 😐 ☺ 😍
  final List<int> _radioButtons = [1, 2, 3, 4, 5, 6];

  @override
  _IconFormFieldState createState() => _IconFormFieldState();
}

class _IconFormFieldState extends State<IconFormField> {
  @override
  void initState() {
    super.initState();
  }

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
                Text(widget.title,
                    style: TextStyle(fontSize: 13.0, color: Colors.black54)),
                // SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget._radioButtons.map((value) {
                    return RadioIcon(
                      value: value,
                      groupValue: widget.groupValue,
                      onChange: (int val) {
                        setState(() {
                          widget.groupValue = val;
                          widget.radioHandler(val);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     Text(
    //       '$id) $question',
    //       style: TextStyle(
    //         fontSize: 18.0,
    //         color: Colors.black87,
    //       ),
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: _radioButtons.map((value) {
    //         return RadioIcon(
    //           value: value,
    //           groupValue: groupValue,
    //           onChange: radioHandler,
    //         );
    //       }).toList(),
    //     ),
    //     SizedBox(
    //       height: 2.0,
    //     ),
    //     Visibility(
    //       visible: error != null,
    //       child: Text(
    //         '$error',
    //         style: TextStyle(
    //           color: Colors.red,
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 10.0,
    //     ),
    //   ],
    // );
  }
}
