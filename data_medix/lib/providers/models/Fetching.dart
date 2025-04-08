import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class DataMode extends ChangeNotifier {
  bool showprov;
  String filter;
  Map<String, String> data;
  int selected;
  String country;
  List<String> arabicCountries;
  dynamic selectedData = "";
  List columnL = [];
  String sele = "Drug Class";

  DataMode(
      {required this.showprov,
      required this.filter,
      required this.data,
      required this.selected,
      required this.arabicCountries,
      required this.country});

  Future<List<Map<String, dynamic>>> getdata(
      String table, String select) async {
    List<Map<String, dynamic>> data = await supabase
        .from(country == "default" || selected != 1
            ? table
            : "$country Drug Info")
        .select()
        .filter(select, "ilike", '%$filter%')
        .limit(20);
    return data;
  }
  Future<List<Map<String, dynamic>>> getsrearch(
      String table, String select) async {
    List<Map<String, dynamic>> data = await supabase
        .from(country == "default" || selected != 1
            ? table
            : "$country Drug Info")
        .select()
        .filter(select, "ilike", '%$filter%')
        .limit(20);
    return data;
  }

  void flitering(String s) {
    filter = s;
    notifyListeners();
  }

  void setSele(String newValue) {
    sele = newValue;
    notifyListeners();
  }

  void toggleProv(bool off) {
    if (off) {
      showprov = false;
    } else {
      showprov = !showprov;
    }
    notifyListeners();
  }

  void countryChange(String s) {
    country = s;
    notifyListeners();
  }

//change the selector type
  void change(int s) {
    selected = s;
    switch (selected) {
      case 0:
        data = {"table": "Main Drug INFO", "select": "Scientific Name"};
        break;
      case 1:
        data = {"table": "Main Brand INDEX", "select": "Brand Name"};
        break; //brand
      case 2:
        data = {"table": "Main Drug INFO", "select": "Drug Class"};
        break; //class drug
      default:
    }
    showprov = false;
    country = "default";
    notifyListeners();
  }

//
  Future<List> getColumnNames(String tableName) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from(country != "default" ? "$country Drug Info" : tableName)
          .select()
          .limit(1);

      if (response.isNotEmpty) {
        Map<String, dynamic> firstRow = response.first;
        List newColumnL = firstRow.keys.toList();
        newColumnL.remove("code");
        newColumnL.remove("Code");
        newColumnL.remove("PS CODE");
        newColumnL.remove("id");
        newColumnL.remove("Ps Code");
        newColumnL.remove("Rx/OTC");
        newColumnL.remove(country != "default" ? "Brand Name":"Drug Class");

        newColumnL.sort();
        newColumnL.insert(0, country != "default" ? "Brand Name":"Drug Class");

        // Only notify if the column list has changed
        if (!listEquals(columnL, newColumnL)) {
          columnL = newColumnL;
          notifyListeners();
        }

        return columnL;
      }
    } catch (error) {
      //
    }

    return [];
  }
}
