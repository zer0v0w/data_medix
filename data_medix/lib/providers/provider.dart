import 'package:data_medix/providers/models/Fetching.dart';
import 'package:data_medix/providers/models/authM.dart';
import 'package:data_medix/providers/models/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




final dataF = ChangeNotifierProvider<DataMode>((ref) {
  return DataMode(showprov: false , filter: "", tables: {"table": "Main Drug INFO","select":"Scientific Name"}, selected: 0, arabicCountries: ["default","Palestine"], country: "default") ;
});



final colorF = ChangeNotifierProvider<ColorD>((ref) {

  return ColorD() ;
});


final fetchF = ChangeNotifierProvider<AuthF>((ref) {
  return AuthF() ;
});