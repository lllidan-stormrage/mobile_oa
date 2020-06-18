import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
* 首页分块widget
*
* */
class HomeTitleZoneView extends StatelessWidget {
  final String mTitle; //标题

  const HomeTitleZoneView(this.mTitle, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
      child: Row(
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            mTitle,
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
