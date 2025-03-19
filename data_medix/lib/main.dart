import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gradient_borders/gradient_borders.dart';

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
        body: Column(
          children: [
            Headtop(toggle: test),
            CardList(),

          ],
        ),
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
class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isweb = width > 700;
    List<String> data = ['Card 1', 'Card 2', 'Card 3', 'Card 4', 'Card 5', 'Card 6'];
    double witha = MediaQuery.of(context).size.width;
    return Expanded(
      child: Padding(
        padding:  EdgeInsets.all(width * 0.02),
        child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isweb? 5:3, // Number of columns
          crossAxisSpacing: 15.0, // Spacing between columns
          mainAxisSpacing: 5.0, 
          // Spacing between rows
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: isweb? EdgeInsets.fromLTRB(0,height*0.06 ,0,height*0.06 ):EdgeInsets.fromLTRB(0,height*0.001 ,0,height*0.001 ),
            child: Container(
            decoration: BoxDecoration(
              border: GradientBoxBorder(gradient: LinearGradient(transform: GradientRotation(-5),colors: [colorsList["praimrytext"]!, colorsList["dividerColor"]!]), width: 2,),
              borderRadius: BorderRadius.circular(15),
              
              color: colorsList["backgroundColor"],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB( 16,16,0,0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  Text(
                  data[index],
                  style: TextStyle(color: colorsList["praimrytext"], fontSize: height*0.025 , fontWeight: FontWeight.bold),
                  ),
                  Spacer(flex: 2,),
                  Text(
                  data[index],
                  style: TextStyle(color: colorsList["secondarytext"]),
                  ),
                  Text(
                  data[index],
                  style: TextStyle(color: colorsList["secondarytext"]),
                  ),
                  Spacer(flex: 2,),
                  Padding( 
                    padding:  EdgeInsets.only(left: witha*0.1),
                    child: TextButton(onPressed: (){}, child: Text(
                    "more...",
                    style: TextStyle(color: colorsList["powercolor"]),
                    ),),
                  )
                ],
              ),
            ),
            ),
          );
        },
        ),
      ),
    );
}}