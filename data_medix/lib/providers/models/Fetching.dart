import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class DataMode extends ChangeNotifier {
  bool showprov;
  String filter;
  Map<String, String> tables;
  int selected;
  String country;
  List<String> arabicCountries;
  //dynamic selectedData = ""; needs rework
  List columnL = [];
  String? drugCode;
  String sele = "Drug Class";
  Map<String, dynamic>? drugData;
  List<Map<String, dynamic>> priceData=[];

  DataMode(
      {required this.showprov,
      required this.filter,
      required this.tables,
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
        
         if(country != "default" && selected == 1){
          List<Map<String, dynamic>> data2 = await supabase
        .from(
            "$country Drug Prices")
        .select()
        .filter(select, "ilike", '%$filter%')
        .limit(20);

        data.addAll(data2);
        }
    return data;
  }

  Future<List<Map<String, dynamic>>> getsrearch(
      String table, String select) async {
    List<Map<String, dynamic>> data1 = await supabase
        .from(selected == 0
            ? "Main Drug INFO"
            : selected == 1
                ? (country == "default"
                    ? "Main Brand INDEX"
                    : "$country Drug Info")
                : selected == 2
                    ? "Main Drug INFO"
                    : "")
        .select()
        .filter(select, "ilike", '%$filter%')
        .limit(20);

        if(country != "default" && selected == 1){
          List<Map<String, dynamic>> data2 = await supabase
        .from(
            "$country Drug Prices")
        .select()
        .filter(select, "ilike", '%$filter%')
        .limit(20);

        data1.addAll(data2);
        }

    notifyListeners();

    return data1;
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
        tables = {"table": "Main Drug INFO", "select": "Scientific Name"};
        break;
      case 1:
        tables = {"table": "Main Brand INDEX", "select": "Brand Name"};
        break; //brand
      case 2:
        tables = {"table": "Main Drug INFO", "select": "Drug Class"};
        break; //class drug
      default:
    }
    showprov = false;
    country = "default";
    notifyListeners();
  }

//
  Future<void> getColumnNames() async {
    try {
      final response = await supabase
          .from(country != "default" ? "$country Drug Info" : "Main Drug INFO")
          .select()
          .filter(
              country != "default" ? "$country Code" : 'Code', "eq", drugCode)
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
        newColumnL.remove(country != "default" ? "Brand Name" : "Drug Class");

        newColumnL.sort();
        newColumnL.insert(
            0, country != "default" ? "Brand Name" : "Drug Class");

        // Only notify if the column list has changed
        if (!listEquals(columnL, newColumnL)) {
          columnL = newColumnL;
          notifyListeners();
        }
        drugData = response.first;
    
        notifyListeners();
      }
    } catch (error) {
      //
    }
            notifyListeners();


    
  }
  Future<List<Map<String, dynamic>>> getPrices() async {
      try {
          List<Map<String, dynamic>> response = await supabase
            .from(
                 "$country Drug Prices")
            .select()
          
            .limit(40);

            priceData = response;
            
            
            return response;
           

      } catch (error) {
        //
        return [];
      }
      
      

    }
}
