import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/model/announce_entity.dart';
import 'package:mobileoa/util/data_helper.dart';

class AnnounceMsgPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnnounceView();
}

class _AnnounceView extends State<AnnounceMsgPage> {
  var mData = new List();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    setState(() {
      mData = CommonDataHelper.getAnnounceEntity();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "公告",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: mData.length,
          itemBuilder: (context, i) {
            return _buildMsg(mData[i]);
          }),
    );
  }

  Widget _buildMsg(AnnounceEntity data) {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 10, right: 10),
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10, top: 8, bottom: 8),
            decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.near_me,
                      color: Colors.blue,
                    ),
                    Text('${data.sendName}')
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text('${data.sendTime}'),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              '${data.title}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              '${data.desc}',
              style: TextStyle(color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }
}
