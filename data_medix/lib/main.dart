import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://aaxnfbigquknldsmhhrb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFheG5mYmlncXVrbmxkc21oaHJiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE0NjUxMDcsImV4cCI6MjA1NzA0MTEwN30.4-yUtxpz8CztBB5_Hg_nwdCzC9RUSNMvMNSuLY-qI9U',
  );

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  void test(){
    setState(() {
      toggleDarkMode();
    });
  }
  @override
  

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: colorsList["backgroundColor"],
        body: Headtop(toggle :test),
      ),
    );
  }
}

//logo
class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isweb = width > 800;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.fromLTRB(
                isweb ? width * 0.01 : width * 0.03, height * 0.012, 0, 0),
            width: isweb ? width * 0.034 : width * 0.08,
            height: height * 0.07,
            child: Image.asset('lib/assets/logo.jpg')),
        GradientText(
          'Data medix',
          style: TextStyle(
            fontSize: isweb ? height * 0.025 : height * 0.02,
          ),
          colors: [
            colorsList['praimryColor']!,
            colorsList['secondaryColor']!,
          ],
        ),
      ],
    );
  }
}

//search bar
class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isweb = width > 800;

    return Container(
      width: width * 0.25,
      height: height * 0.04,
      decoration: BoxDecoration(
          color: colorsList["dividerColor"],
          borderRadius: BorderRadius.circular(35)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: height * 0.01),
              child: TextField(
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

//headtop
class Headtop extends StatefulWidget {
  const Headtop({super.key,  required this.toggle});
  final void Function() toggle;
  @override
  State<Headtop> createState() => _HeadtopState();
}

class _HeadtopState extends State<Headtop> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Logo(),
        TextButton(
            onPressed: () {
              setState(() {
               widget.toggle();
              });
            },
            child: Text(
              darkMode ? "light" : "dark",
              style: TextStyle(color: colorsList["praimrytext"]),
            )),
        Spacer(
          flex: 1,
        ),
        SearchBar(),
        Spacer(
          flex: 2,
        ),
      ],
    );
  }
}


//card