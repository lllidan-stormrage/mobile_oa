import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileoa/ui/meeting/announce_msg.dart';
import 'package:mobileoa/ui/meeting/meeting_home.dart';
import 'package:mobileoa/ui/meeting/meeting_record.dart';
import 'package:mobileoa/ui/memo/memo_page.dart';
import 'package:mobileoa/ui/sign/sign_page.dart';
import 'package:mobileoa/ui/sign/sign_record.dart';
import 'package:mobileoa/ui/sign/sign_remake.dart';

class HomeFunCardView extends StatelessWidget {
  final String mTitle;
  final int index;
  final int type;

  const HomeFunCardView(this.mTitle, this.index, this.type, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Card(
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
                      color: Colors.black87),
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
      ),
      onTap: () {
        if (type == 0) {
          if (index == 0) {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return SignPage();
            }));
          } else if (index == 1) {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return SignRecord();
            }));
          } else {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return SignRemake();
            }));
          }
        } else if (type == 1) {
          if (index == 0) {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return MeetingHome();
            }));
          } else if (index == 1) {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return MeetingRecord();
            }));
          } else {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return AnnounceMsgPage();
            }));
          }
        } else if (type == 2) {
//          if (index == 0) {
//            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
//              return BlueStylePage();
//            }));
//          } else if (index == 1) {
//            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
//              return MemoPage();
//            }));
//          }
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return MemoPage();
          }));
        }
      },
    );
  }
}
