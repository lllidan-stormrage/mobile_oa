import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/db/dao/Memo_dao.dart';
import 'package:mobileoa/model/memo.dart';
import 'package:mobileoa/util/app_util.dart';
import 'package:mobileoa/util/common_toast.dart';

class AddMemoPage extends StatefulWidget {
  final bool showMark;
  final MemoEntity mData;

  const AddMemoPage({Key key, this.showMark, this.mData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemoAdd();
}

class _MemoAdd extends State<AddMemoPage> {
  var mTitleController = new TextEditingController();
  var mDescController = new TextEditingController();
  int mUserId;

  @override
  void initState() {
    super.initState();
    if (widget.mData != null) {
      mTitleController.text = widget.mData.title;
      mDescController.text = widget.mData.desc;
    }
    _getData();
  }

  void _getData() async {
    mUserId = await AppUtils.getLoginUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的备忘录",
            style: TextStyle(fontSize: 16, color: Colors.black87)),
        iconTheme: IconThemeData(
          color: Colors.black87, //修改颜色
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Color(0xffF5F5F5),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            _buildTitle(),
            SizedBox(
              height: 15,
            ),
            _buildDesc(),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                widget.showMark ? updateState() : _submit();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: widget.mData != null && widget.mData.isOver == 1 ? Colors.grey : Colors.blue,
                    borderRadius: BorderRadius.circular(6)),
                child: Center(
                  child: Text(
                    widget.showMark
                        ? widget.mData != null && widget.mData.isOver == 0 ? "完成" : "已保存"
                        : "提交",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
                text: widget.showMark ? "" : "*",
                style: TextStyle(color: Colors.red),
                children: [
                  TextSpan(
                      text: "备忘录标题",
                      style: TextStyle(fontSize: 16, color: Colors.black))
                ]),
          ),
          TextField(
            controller: mTitleController,
            keyboardType: TextInputType.text,
            maxLines: 1,
            minLines: 1,
            maxLength: 12,
            decoration:
                InputDecoration(hintText: "请输入", border: InputBorder.none),
          )
        ],
      ),
    );
  }

  Widget _buildDesc() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
                text: widget.showMark ? "" : "*",
                style: TextStyle(color: Colors.red),
                children: [
                  TextSpan(
                      text: "备忘录内容",
                      style: TextStyle(fontSize: 16, color: Colors.black))
                ]),
          ),
          TextField(
            controller: mDescController,
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

  void _submit() async {
    if (mTitleController.text.isEmpty) {
      ToastUtils.showError("请填写标题");
      return;
    }
    if (mDescController.text.isEmpty) {
      ToastUtils.showError("请填写备忘录内容");
      return;
    }

    var time = DateTime.now();
    MemoEntity data = new MemoEntity();
    data.year = time.year;
    data.month = time.month;
    data.userId = mUserId;
    data.title = mTitleController.text;
    data.desc = mDescController.text;
    data.isOver = 0;
    data.day = time.day;
    await MemoDao.getInstance().insert(data);
    Navigator.pop(context);
  }

  void updateState() async {
    if (widget.mData.isOver == 1) {
      ToastUtils.showError("已经完成不能修改了");
      return;
    }
    if (mTitleController.text.isEmpty) {
      ToastUtils.showError("请填写标题");
      return;
    }
    if (mDescController.text.isEmpty) {
      ToastUtils.showError("请填写备忘录内容");
      return;
    }
    widget.mData.title = mTitleController.text;
    widget.mData.desc = mDescController.text;
    widget.mData.isOver = 1;
    await MemoDao.getInstance().modify(widget.mData);
    Navigator.pop(context);
  }
}
