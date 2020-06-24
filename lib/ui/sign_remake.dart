import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobileoa/db/dao/remake_sign_dao.dart';
import 'package:mobileoa/model/remake_sign.dart';
import 'package:mobileoa/util/common_toast.dart';

class SignRemake extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RemakeView();
}

class _RemakeView extends State<SignRemake> {
  TextEditingController _mReasonController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "补卡申请",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Container(
        color: Color(0xffF5F5F5),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: <Widget>[
            SizedBox(
              height: 15,
            ),
            _buildTime(),
            SizedBox(
              height: 10,
            ),
            _buildReason(),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
                onTap: () {
                  _submit();
                },
                child: Container(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    margin: EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6)),
                    child: Center(
                      child: Text(
                        "提交",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  Widget _buildTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                    children: [
                      TextSpan(
                          text: "补卡时间",
                          style: TextStyle(fontSize: 16, color: Colors.black))
                    ]),
              ),
              RichText(
                text: TextSpan(
                    text: "请选择时间",
                    style: TextStyle(color: Colors.black38),
                    children: [
                      WidgetSpan(
                          child: Image(
                        image: AssetImage("images/ic_right_next.png"),
                      ))
                    ]),
              )
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 8, left: 10),
            child: Text(
              "本月已申请1次，还剩4次",
              textAlign: TextAlign.start,
            ))
      ],
    );
  }

  Widget _buildReason() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red),
                children: [
                  TextSpan(
                      text: "补卡理由",
                      style: TextStyle(fontSize: 16, color: Colors.black))
                ]),
          ),
          TextField(
            controller: _mReasonController,
            keyboardType: TextInputType.text,
            maxLines: 8,
            minLines: 4,
            decoration:
                InputDecoration(hintText: "请输入", border: InputBorder.none),
          )
        ],
      ),
    );
  }

  void _submit() async{
    if (_mReasonController.text.length < 5) {
      ToastUtils.showError("原因不能少于5个子");
      return;
    }
    var time = DateTime.now();
    ReMakeSign sign = new ReMakeSign(year: time.year,month:time.month,);
   int value = await RemakeSignDao.getInstance().insertOrUpdateSign(sign);
    //finish
    Navigator.pop(context);
  }
}
