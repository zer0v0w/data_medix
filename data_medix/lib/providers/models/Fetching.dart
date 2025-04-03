import 'package:flutter/material.dart';
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
    String sele = "Scientific Name";

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

  void flitering(String s) {
    filter = s;
    notifyListeners();
  }

  void setSele(String newValue) {
    sele = newValue;
    notifyListeners();}

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
    print(data);
    showprov = false;
    country = "default";
    notifyListeners();
  }

//
  Future<List> getColumnNames(String tableName) async {
    final supabase = Supabase.instance.client;

    try {
      final response =
          await supabase.from(country != "default"? "$country Drug Info":"Main Drug INFO").select().limit(1); // Fetch 1 row

      if (response.isNotEmpty) {
        Map<String, dynamic> firstRow = response.first;
        columnL = firstRow.keys.toList();
        columnL.remove("code");
        columnL.remove("Code");
        columnL.remove("PS CODE");
        columnL.remove("id");
        columnL.remove("Ps Code");
                columnL.remove("Rx/OTC");

        print(tableName);
        columnL.sort();
        return columnL;
      }
    } catch (error) {
      print('Error fetching column names: $error');
    }
            return columnL;

  }
}
