import 'package:data_medix/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:markdown/markdown.dart' as md;

Future<void> main() async {
  await Supabase.initialize(
      url: 'https://usyqcppobmfjbegbkalb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVzeXFjcHBvYm1mamJlZ2JrYWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE5NTY3MzAsImV4cCI6MjA1NzUzMjczMH0.hnU2P3S605znSKPBkb96TJvofkE-w06jNUg10j32A-Y');

  runApp(MainApp());
}

Future<List<Map<String, dynamic>>> getdata(String table, String select) async {
  final response = await supabase.from(table).select();

  return List<Map<String, dynamic>>.from(response);
}

final supabase = Supabase.instance.client;

int selected = 0;//TODO make the filttring work you can do this be make the number represent the column name be makeing if selected=num then change filter to list<cloumn name,row name> and then use the filter in the getdata function,

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  void test() {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Headtop(toggle: test),
            SizedBox(height: 10),
            Text("Discover",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                  color: colorsList["praimrytext"],
                )),
            SizedBox(height: 10),

            Chosing(),
            SizedBox(height: 10),

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
class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
  const Headtop({super.key, required this.toggle});
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


class Chosing extends StatefulWidget {
  const Chosing({super.key});

  @override
  State<Chosing> createState() => _ChosingState();
}

class _ChosingState extends State<Chosing> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {setState(() {
              selected = 0;
            });},
            child: Text(
              "scientific name",
              style: TextStyle(
                  color: selected == 0
                      ? colorsList["praimrytext"]
                      : colorsList["secondarytext"],
                  decoration: selected == 0 ? TextDecoration.underline : null,
                  decorationColor: colorsList["praimrytext"],
                  fontSize: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.02
                      : MediaQuery.of(context).size.height * 0.018),
            )),
        TextButton(
            onPressed: () {setState(() {
              selected = 1;
            });},
            child: Text(
              "Drug class",
              style: TextStyle(
                  color: selected == 1
                      ? colorsList["praimrytext"]
                      : colorsList["secondarytext"],
                  decoration: selected == 1 ? TextDecoration.underline : null,
                  fontSize: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.02
                      : MediaQuery.of(context).size.height * 0.018),
            )),
        TextButton(
            onPressed: () {setState(() {
              selected = 2;
            });},
            child: Text(
              "Rx/OTC",
              style: TextStyle(
                  color: selected == 2
                      ? colorsList["praimrytext"]
                      : colorsList["secondarytext"],
                  decoration: selected == 2 ? TextDecoration.underline : null,
                  fontSize: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.02
                      : MediaQuery.of(context).size.height * 0.018),
            )),
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
    bool isweb = width > 1200;

    return FutureBuilder<List<Map<String, dynamic>>>(
        future: getdata("Main Drug INFO", '''Scientific Name'''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: colorsList["accentColor"],
            ); // Loading
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}"); // Handle error
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text("No data available"); // Handle empty data
          }

          List<Map<String, dynamic>> dataList = snapshot.data!;
//card build
          return Expanded(
              child: Padding(
                  padding: EdgeInsets.all(width * 0.02),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isweb ? 5 : 2, // Number of columns
                      crossAxisSpacing: 5.0, // Spacing between columns
                      mainAxisSpacing: 5.0,
                      // Spacing between rows
                    ),
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: isweb
                            ? EdgeInsets.fromLTRB(
                                0, height * 0.06, 0, height * 0.06)
                            : EdgeInsets.fromLTRB(
                                0, height * 0.001, 0, height * 0.001),
                        child: Container(
                          decoration: BoxDecoration(
                            border: GradientBoxBorder(
                              gradient: LinearGradient(
                                  transform: GradientRotation(-5),
                                  colors: [
                                    colorsList["praimrytext"]!,
                                    colorsList["dividerColor"]!
                                  ]),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: colorsList["backgroundColor"],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FadingText(dataList[index]['Scientific Name'],
                                    style: TextStyle(
                                      fontSize: isweb
                                          ? height * 0.022
                                          : height * 0.02,
                                      color: colorsList["praimrytext"],
                                      fontWeight: FontWeight.bold,
                                    )),
                                Spacer(
                                  flex: 1,
                                ),
                                FadingText(
                                    md.Document()
                                        .parseLines(dataList[index]
                                                ['Drug Class']
                                            .split('\n'))
                                        .map((e) => e.textContent)
                                        .join('\n'),
                                    style: TextStyle(
                                      fontSize: isweb
                                          ? height * 0.02
                                          : height * 0.018,
                                      color: colorsList["secondarytext"],
                                      fontWeight: FontWeight.w500,
                                    )),
                                Spacer(
                                  flex: 10,
                                ),
                                Row(
                                  children: [
                                    Text(dataList[index]['Rx/OTC'] ?? "",
                                        style: TextStyle(
                                          fontSize: isweb
                                              ? height * 0.02
                                              : height * 0.018,
                                          color: colorsList["secondarytext"],
                                          fontWeight: FontWeight.w400,
                                        )),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text("More"),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )));
        });
  }
}
