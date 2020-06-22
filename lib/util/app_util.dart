import 'package:mobileoa/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {
  //登陆id
  static Future<int> getLoginUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(Constant.spLoginUserId);
  }

  static saveLoginUserId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(Constant.spLoginUserId, id);
  }
}
