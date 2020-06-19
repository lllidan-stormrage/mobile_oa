import 'package:flutter/cupertino.dart';

/*
* 个人信息item
* */
class MineInfoView extends StatelessWidget {
  final String mHead;
  final String mValue;

  const MineInfoView(this.mHead, this.mValue, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                mHead,
                textAlign: TextAlign.start,
              ),
              Text(
                mHead,
                textAlign: TextAlign.end,
              )
            ],
          ),
        ));
  }
}
