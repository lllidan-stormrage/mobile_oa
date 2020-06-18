import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeFunCardView extends StatelessWidget {
  final String mTitle;

  const HomeFunCardView(this.mTitle, {Key key}):super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(15, 0, 0, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        width: 140,
        child: Stack(
          alignment: Alignment(-1, 1),
          children: <Widget>[
            Positioned(
              top: 90,
              left: 10,
              child: Text(
                mTitle,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.lightBlue),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 40,
              child: Icon(
                Icons.assignment,
                size: 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
