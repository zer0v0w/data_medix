import 'package:data_medix/providers/provider.dart';
import 'package:data_medix/screens/main-products.dart';
import 'package:data_medix/assets/widget.dart' as widg;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  await Supabase.initialize(
      url: 'https://usyqcppobmfjbegbkalb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVzeXFjcHBvYm1mamJlZ2JrYWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE5NTY3MzAsImV4cCI6MjA1NzUzMjczMH0.hnU2P3S605znSKPBkb96TJvofkE-w06jNUg10j32A-Y');
  runApp(const ProviderScope(child: MainApp()));
}


// main app viwer
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context ,ref) {
    return MaterialApp(
      theme: ThemeData(
        // Use GoogleFonts for a modern, clean font style.
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      home: SizedBox.expand(
        child: Scaffold(
          backgroundColor: ref.watch(colorF).colorsList["backgroundColor"],
          body: Stack(children: [
            Container(
              color: const Color.fromARGB(16, 0, 0, 0), // Add semi-transparent black overlay
              width: double.infinity,
              height: double.infinity,
            ),
            MAINPAGE(colorsList: ref.watch(colorF).colorsList,)
          ]),
        ),
      ),
    );
  }
}


//page viwer
class MAINPAGE extends StatelessWidget {
     final Map <String,Color> colorsList;

  const MAINPAGE({super.key, required this.colorsList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Headtop(),
          const SizedBox(height: 10),
          Text(
                    "Discover",
                    style: GoogleFonts.roboto(
          fontSize: MediaQuery.of(context).size.height * 0.06,
          fontWeight: FontWeight.bold,
          color: colorsList["praimrytext"],
                    ),
          ),
          Chosing(),
          Divider(),
          Expanded(child: CardList()),
        ],
          ),
          Positioned(
        left: MediaQuery.of(context).size.width * 0.39,
        right: 0,
        top: MediaQuery.of(context).size.height * 0.02,
        child: widg.SearchBar(),
          ),
      ],
    ),
    );
    
    
  }
}