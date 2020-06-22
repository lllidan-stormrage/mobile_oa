import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/util/data_helper.dart';
import 'package:mobileoa/widget/mine_info_widget.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePage();
}

class _MinePage extends State<MinePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        //包装事件
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("images/ic_img_avatar.png"),
                ),
              ),
              onTap: () {
                _showSelectPhoto(context);
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                'admin',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(height: 20, color: Color(0xffe6e6e6)),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "我的信息",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            ListView.builder(itemBuilder: (context,i){

              return MineInfoView(CommonDataHelper.userTitle[i],"测试");
            },
            itemCount: CommonDataHelper.userTitle.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),)
          ],
        ),
      ),
    );
  }

  _showSelectPhoto(BuildContext context) {
    //todo
  }
}
