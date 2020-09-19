import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileoa/db/dao/user_dao.dart';
import 'package:mobileoa/model/user.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/data_helper.dart';
import 'package:mobileoa/widget/mine_info_widget.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePage();
}

class _MinePage extends State<MinePage> {
  UserEntity mUser =new UserEntity();
  File imagePath = null;

  Future getImage() async{
    final pickFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      imagePath = File(pickFile.path);
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() async {
    int userId = await AppUtils.getLoginUserId();
   var user = await UserDao.getInstance().getUserEntityById(userId);
    setState(() {
      mUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        //包装事件
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.transparent,
                  backgroundImage: imagePath == null ? AssetImage("images/ic_img_avatar.png"):imagePath,
                ),
              ),
              onTap: () {
                getImage();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                '${mUser.name}',
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
            Column(
              children: <Widget>[
                MineInfoView(CommonDataHelper.userTitle[0], mUser.company),
                MineInfoView(CommonDataHelper.userTitle[1], mUser.phone),
                MineInfoView(
                    CommonDataHelper.userTitle[2], mUser.age.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }


}
