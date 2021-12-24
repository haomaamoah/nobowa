import 'package:flutter/material.dart';
import 'package:nobowa/model/models.dart';

class Introduction extends StatefulWidget {
  final bool newUser;
  const Introduction(this.newUser, {Key? key}) : super(key: key);

  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(widget.newUser?Utils.introNewUserBg:Utils.introOldUserBg ),
        Column(),
      ],
    );
  }
}
