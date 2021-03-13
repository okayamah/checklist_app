import 'package:checklist_app/configs/const_text.dart';
import 'package:flutter/material.dart';

class RadioIcon extends StatefulWidget {
  RadioIcon({
    @required this.value,
    @required this.groupValue,
    @required this.onChange,
  }) : assert(value >= 1 && value <= 6, 'RadioEmoji value out of bound.');

  /// Rating value between 1 and 5
  final int value;

  /// `groupValue` used to identify the radio button group
  int groupValue;

  /// everytime the value of radio changes this function will trigger
  final Function onChange;

  // /// Emojis describing feedback status
  // static final List<String> emojiIndex = ['😠', '😕', '😐', '☺', '😍', "a"];

  @override
  _RadioIconState createState() => _RadioIconState();
}

class _RadioIconState extends State<RadioIcon>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  String emoji;
  // bool isSelected;

  // This function will trigger each time the radio emoji button is tapped
  void _handleTap() {
    widget.onChange(widget.value);
    widget.groupValue = widget.value;
    _initializeAnimation();
  }

  void _initializeAnimation() {
    controller.forward();
  }

  void _deinitializeAnimation() {
    controller.value = 0.0;
  }

  bool get isSelected => widget.value == widget.groupValue;

  @override
  void initState() {
    super.initState();

    // emoji = RadioIcon.emojiIndex[widget.value - 1];

    controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    );

    controller.addListener(() => setState(() {}));

    // isSelected = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // isSelected = widget.value == widget.groupValue;

    if (isSelected == false) _deinitializeAnimation();

    var backgroundColor = _getAvatarColor(
        widget.value.toString() != null ? widget.value.toString() : "1");

    return ClipOval(
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          width: MediaQuery.of(context).size.width * 0.8/6 - 10.0,
          height: MediaQuery.of(context).size.width * 0.8/6 - 10.0,
          decoration: BoxDecoration(
            color: isSelected ? backgroundColor : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
                style: BorderStyle.solid, width: 1.0, color: backgroundColor),
          ),
          child: InkWell(
            child: SizedBox(
              child: Image.asset(isSelected
                  ? AppColors.iconsSelected[widget.value.toString() != null
                      ? int.parse(widget.value.toString()) - 1
                      : 0]
                  : AppColors.icons[widget.value.toString() != null
                      ? int.parse(widget.value.toString()) - 1
                      : 0]
              ),
            ),
          ),
        ),
        onTap: _handleTap,
      ),
    );
    // GestureDetector(
    //   child: Container(
    //     decoration: BoxDecoration(
    //       border: Border.all(style: BorderStyle.none, width: 1.0, color: backgroundColor),
    //       shape: BoxShape.circle,
    //       // color: backgroundColor
    //     ),
    //     padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 10.0),
    //     child:
    //         // CircleAvatar(
    //         //   child: Image.asset(AppColors.icons[widget.value.toString() != null
    //         //       ? int.parse(widget.value.toString()) - 1
    //         //       : 0]),
    //         //   backgroundColor: _getAvatarColor(
    //         //       widget.value.toString() != null ? widget.value.toString() : "1"),
    //         // ),
    //         Image.asset(AppColors.icons[widget.value.toString() != null
    //             ? int.parse(widget.value.toString()) - 1
    //             : 0]),
    //   ),
    //   onTap: _handleTap,
    // );
  }

  String _getInitials(String user) {
    var buffer = StringBuffer();
    var split = user.split(" ");
    for (var s in split) buffer.write(s[0]);

    return buffer.toString().substring(0, split.length);
  }

  Color _getAvatarColor(String colorIndex) {
    return AppColors.avatarColors[int.parse(colorIndex) - 1];
  }
}
