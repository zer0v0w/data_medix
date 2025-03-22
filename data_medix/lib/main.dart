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

final supabase = Supabase.instance.client;

String filter = "";
List<String> arabicCountries = [
  "default",
  "Palestine",
];
String country = "default";
Future<List<Map<String, dynamic>>> getdata(String table, String select) async {
  if (country != "default") {
    final response = filter == ""
        ? await supabase.from("$country Drug Info").select()
        : await supabase.from("$country Drug Info").select().filter(
            (switch (data["table"]) {
              "Main Drug INFO" => 'Product class',
              "Main Brand INDEX" => 'Brand Name',
              String() => "",
              null => "",
            }),
            'ilike',
            '%$filter%');

    return List<Map<String, dynamic>>.from(response);
  } else {
    final response = filter == ""
        ? await supabase.from(table).select()
        : await supabase
            .from(table)
            .select()
            .filter(select, 'ilike', '%$filter%');
    return List<Map<String, dynamic>>.from(response);
  }
}

Map<String, String> data = {
  "table": "Main Drug INFO",
  "select": "Scientific Name"
};

int selected = 0;

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  void themeMode() {
    setState(() {
      toggleDarkMode();
    });
  }

  void change() {
    setState(() {
      switch (selected) {
        case 0:
          data = {"table": "Main Drug INFO", "select": "Scientific Name"};
          break;
        case 1:
          data = {"table": "Main Brand INDEX", "select": "Brand Name"};
          break;
        case 2:
          print(filter);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: colorsList["backgroundColor"],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Headtop(toggle: themeMode, change: change),
            SizedBox(height: 10),
            Text("Discover",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.045,
                  fontWeight: FontWeight.bold,
                  color: colorsList["praimrytext"],
                )),
            SizedBox(height: 10),
            Chosing(change: change),
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
            fontSize: isweb ? height * 0.03 : height * 0.025,
            fontWeight: FontWeight.w600,
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
  const SearchBar({super.key, required this.change});
  final void Function() change;

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
      width: isweb ? width * 0.25 : width * 0.2,
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
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: TextField(
                onChanged: (value) {
                  filter = value;
                  widget.change();
                },
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'Search in ${data["table"] == "Main Brand INDEX" ? "Brands" : "Drug Classes"}...',
                  hintStyle: TextStyle(
                    fontSize: height * 0.018,
                    fontWeight: FontWeight.w400,
                  ),
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
  const Headtop({super.key, required this.toggle, required this.change});
  final void Function() toggle;
  final void Function() change;
  @override
  State<Headtop> createState() => _HeadtopState();
}

class _HeadtopState extends State<Headtop> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isweb = width > 800;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
              style: TextStyle(
                color: colorsList["praimrytext"],
                fontSize: MediaQuery.of(context).size.height * 0.018,
                fontWeight: FontWeight.w500,
              ),
            )),
        Spacer(
          flex: isweb ? 9 : 1,
        ),
        SearchBar(change: widget.change),
        Spacer(
          flex: 15,
        ),
      ],
    );
  }
}

//chosing
class Chosing extends StatefulWidget {
  const Chosing({super.key, required this.change});
  final void Function() change;
  @override
  State<Chosing> createState() => _ChosingState();
}

class _ChosingState extends State<Chosing> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(
          flex: 1,
        ),
        Container(
          decoration: BoxDecoration(
              color: colorsList["frontgroundColor"],
              borderRadius: BorderRadius.circular(35)),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              style: TextStyle(
                color: colorsList["praimrytext"],
                fontSize: kIsWeb
                    ? MediaQuery.of(context).size.height * 0.022
                    : MediaQuery.of(context).size.height * 0.02,
                fontWeight: FontWeight.w500,
              ),
              value: null,
              hint: Text(
                "Countries",
                style: TextStyle(
                  color: colorsList["backgroundColor"],
                  fontSize: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.022
                      : MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: Icon(
                Icons.filter_list,
                color: colorsList["backgroundColor"],
              ),
              items: arabicCountries.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: TextStyle(color: colorsList["backgroundColor"]),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                // Handle selection
                country = value!;
                widget.change();
              },
            ),
          ),
        ),
        Spacer(
          flex: 4,
        ),
        TextButton(
            onPressed: () {
              setState(() {
                selected = 0;
                widget.change();
              });
            },
            child: Text(
              "scientific names",
              style: TextStyle(
                  color: selected == 0
                      ? colorsList["praimrytext"]
                      : colorsList["secondarytext"],
                  decoration: selected == 0 ? TextDecoration.underline : null,
                  decorationColor: colorsList["praimrytext"],
                  fontSize: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.022
                      : MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.w600),
            )),
        Spacer(flex: 2),
        TextButton(
            onPressed: () {
              setState(() {
                selected = 1;
                widget.change();
              });
            },
            child: Text(
              "Brands",
              style: TextStyle(
                  color: selected == 1
                      ? colorsList["praimrytext"]
                      : colorsList["secondarytext"],
                  decoration: selected == 1 ? TextDecoration.underline : null,
                  fontSize: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.022
                      : MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.w600),
            )),
        Spacer(flex: 2),
        TextButton(
            onPressed: () {
              setState(() {
                selected = 2;
                widget.change();
              });
            },
            child: Text(
              "Rx/OTC",
              style: TextStyle(
                  color: selected == 2
                      ? colorsList["praimrytext"]
                      : colorsList["secondarytext"],
                  decoration: selected == 2 ? TextDecoration.underline : null,
                  fontSize: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.022
                      : MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.w600),
            )),
        Spacer(flex: 7),
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
        future: getdata(data["table"]!, data["select"]!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 1200 ? 5 : 2,
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.25,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemCount: 10, // Number of placeholder cards
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: [
                                colorsList["praimrytext"]!,
                                colorsList["dividerColor"]!,
                              ],
                            ),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: colorsList["backgroundColor"],
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorsList["praimrytext"],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                      mainAxisExtent: height * 0.25,
                      crossAxisSpacing: 15.0, // Spacing between columns
                      mainAxisSpacing: 15.0,
                      // Spacing between rows
                    ),
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: isweb
                            ? EdgeInsets.fromLTRB(
                                0, height * 0.03, 0, height * 0.01)
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
                                FadingText(
                                    //main text
                                    country == "default"
                                        ? switch (data["table"]) {
                                            "Main Drug INFO" => dataList[index]
                                                    ['Scientific Name'] ??
                                                "",
                                            "Main Brand INDEX" =>
                                              dataList[index]['Brand Name'] ??
                                                  "s",
                                            String() => "a",
                                            null => "nothing",
                                          }
                                        : switch (data["table"]) {
                                            "Main Drug INFO" => dataList[index]
                                                    ['Product class'] ??
                                                "",
                                            "Main Brand INDEX" =>
                                              dataList[index]['Brand Name'] ??
                                                  "",
                                            String() => "",
                                            null => "nothing",
                                          },
                                    style: TextStyle(
                                      fontSize: isweb
                                          ? height * 0.024
                                          : height * 0.022,
                                      color: colorsList["praimrytext"],
                                      fontWeight: FontWeight.bold,
                                    )),
                                Spacer(
                                  flex: 1,
                                ),
                                FadingText(
                                    //sub text
                                    country == "default"
                                        ? switch (data["table"]) {
                                            "Main Drug INFO" => md.Document()
                                                .parseLines(dataList[index]
                                                        ['Drug Class']
                                                    .split('\n'))
                                                .map((e) => e.textContent)
                                                .join('\n'),
                                            "Main Brand INDEX" =>
                                              dataList[index]
                                                      ['Scientific Name'] ??
                                                  "",
                                            String() => "",
                                            null => throw "nothing",
                                          }
                                        : switch (data["table"]) {
                                            "Main Drug INFO" =>
                                              dataList[index]['API'] ?? "",
                                            "Main Brand INDEX" =>
                                              dataList[index]['API'] ??
                                                  "",
                                            String() => "",
                                            null => "nothing",
                                          },
                                    style: TextStyle(
                                      fontSize: isweb
                                          ? height * 0.022
                                          : height * 0.02,
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
                                              ? height * 0.022
                                              : height * 0.02,
                                          color: colorsList["secondarytext"],
                                          fontWeight: FontWeight.w400,
                                        )),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "More",
                                        style: TextStyle(
                                          fontSize: height * 0.019,
                                          fontWeight: FontWeight.w600,
                                          color: colorsList["praimryColor"],
                                        ),
                                      ),
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
