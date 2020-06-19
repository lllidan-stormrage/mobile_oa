import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 个人信息item
* */
class MineInfoView extends StatelessWidget {
  final String mHead;
  final String mValue;

  const MineInfoView(this.mHead, this.mValue, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)),
        )),
        child: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 18),
                child:Text(
                  mHead,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(right: 18),
                  child: Row(
                    children: <Widget>[
                      Text(
                        mHead,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Color(0xff87898C)),
                      ),
                      Image(
                        image: AssetImage("images/ic_right_next.png"),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ));
  }
}
