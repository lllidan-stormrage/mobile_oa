class DateUtils {

  static String getYYMMDD() {
    var date = DateTime.now();
    return "${date.year.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.day.toString().padLeft(2, "0")}";
  }
}
