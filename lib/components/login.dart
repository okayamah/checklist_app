import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'app.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:checklist_app/configs/const_text.dart';

class Login extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0eb4c2),
      body: Stack(
        children: <Widget>[
          Pinned.fromSize(
            bounds: Rect.fromLTWH(376.5, 260.8, 1.0, 1.0),
            size: Size(414.0, 896.0),
            pinRight: true,
            fixedWidth: true,
            fixedHeight: true,
            child: SvgPicture.string(
              _svg_vstr4g,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(33.0, 308.1, 348.0, 279.7),
            size: Size(414.0, 896.0),
            pinLeft: true,
            pinRight: true,
            fixedHeight: true,
            child: Stack(
              children: <Widget>[
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(75.0, 219.7, 198.0, 60.0),
                  size: Size(348.0, 279.7),
                  pinBottom: true,
                  fixedWidth: true,
                  fixedHeight: true,
                  child: RaisedButton(
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
                          MaterialPageRoute(builder: (context) => TodoApp()));
                    },
                    color: const Color(0xfff4f4ef),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(0.0, 0.0, 348.0, 157.1),
                  size: Size(348.0, 279.7),
                  pinLeft: true,
                  pinRight: true,
                  pinTop: true,
                  fixedHeight: true,
                  child: Stack(
                    children: <Widget>[
                      Pinned.fromSize(
                        bounds: Rect.fromLTWH(0.0, 74.1, 348.0, 83.0),
                        size: Size(348.0, 157.1),
                        pinLeft: true,
                        pinRight: true,
                        pinBottom: true,
                        fixedHeight: true,
                        child: Text(
                          text,
                          style: TextStyle(
                            fontFamily: 'Retro Mono',
                            fontSize: 50,
                            color: color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Pinned.fromSize(
                        bounds: Rect.fromLTWH(0.0, 0.0, 76.9, 74.1),
                        size: Size(348.0, 157.1),
                        pinLeft: true,
                        pinTop: true,
                        fixedWidth: true,
                        fixedHeight: true,
                        child: SvgPicture.string(
                          _svg_cc110a,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_cc110a =
    '<svg viewBox="33.0 247.2 76.9 74.1" ><path transform="translate(32.47, -41.99)" d="M 11.5121603012085 289.19384765625 C 8.308794975280762 289.19384765625 5.429043769836426 290.0323486328125 3.408987998962402 292.05224609375 C 1.388941645622253 294.0724792480469 0.5291652679443359 296.9786376953125 0.5291652679443359 300.1821594238281 L 0.5291652679443359 341.3684692382813 C 0.5291652679443359 344.5716552734375 1.388931155204773 347.4781494140625 3.408987998962402 349.4983520507813 C 5.429043769836426 351.5185852050781 8.308794975280762 352.3567810058594 11.5121603012085 352.3567810058594 L 40.76077270507813 352.3567810058594 L 53.73332595825195 362.7337951660156 C 54.38042068481445 363.2542724609375 55.22847747802734 363.4541625976563 56.0400390625 363.2771911621094 C 56.85160064697266 363.1002502441406 57.5394287109375 362.5653381347656 57.91094589233398 361.8223876953125 L 62.63018417358398 352.357421875 L 66.42173767089844 352.357421875 C 69.62511444091797 352.357421875 72.53167724609375 351.5188903808594 74.55172729492188 349.4989929199219 C 76.57176971435547 347.4790649414063 77.41009521484375 344.572265625 77.41009521484375 341.3690795898438 L 77.41009521484375 300.1828002929688 C 77.41009521484375 296.9792785644531 76.57173919677734 294.0731201171875 74.55172729492188 292.0528869628906 C 72.53166961669922 290.0326538085938 69.62511444091797 289.1944580078125 66.42173767089844 289.1944580078125 L 11.5121603012085 289.19384765625 Z M 58.13084411621094 305.6522827148438 C 59.26091384887695 305.6167602539063 60.29718780517578 306.2773742675781 60.74172973632813 307.3170166015625 C 61.18626403808594 308.3563842773438 60.94818878173828 309.5625915527344 60.14189910888672 310.3549194335938 L 38.17058563232422 332.3265075683594 C 37.09949493408203 333.3912963867188 35.36973571777344 333.3912963867188 34.29868698120117 332.3265075683594 L 23.31030082702637 321.3435363769531 C 22.23457145690918 320.274658203125 22.2297191619873 318.535400390625 23.29916954040527 317.4602355957031 C 24.36861419677734 316.384765625 26.10735702514648 316.3800659179688 27.18269920349121 317.4495544433594 L 36.22389984130859 326.51318359375 L 56.24856567382813 306.4832153320313 C 56.74456405639648 305.9722290039063 57.41943740844727 305.6742553710938 58.13090133666992 305.6519775390625 Z" fill="#f4f4ef" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_vstr4g =
    '<svg viewBox="376.5 260.8 1.0 1.0" ><path transform="translate(36.5, 260.75)" d="M 340 0" fill="none" stroke="#f1dcc9" stroke-width="5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
