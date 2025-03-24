import 'package:data_medix/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await Supabase.initialize(
      url: 'https://usyqcppobmfjbegbkalb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVzeXFjcHBvYm1mamJlZ2JrYWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE5NTY3MzAsImV4cCI6MjA1NzUzMjczMH0.hnU2P3S605znSKPBkb96TJvofkE-w06jNUg10j32A-Y');

  runApp(MainApp());
}

final supabase = Supabase.instance.client;
bool showprov = false;

int selected = 0;
String filter = "";
List<String> arabicCountries = [
  "default",
  "Palestine",
];

Map<String, String> data = {
  "table": "Main Drug INFO",
  "select": "Scientific Name"
};
bool ascending = true;
String country = "default";

bool isFetching = false;

Future<void> saveDataToCache(
    String key, List<Map<String, dynamic>> data) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonData = data.map((e) => e.toString()).toList();
  await prefs.setStringList(key, jsonData);
}

Future<List<Map<String, dynamic>>> getDataFromCache(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonData = prefs.getStringList(key);
  if (jsonData != null) {
    return jsonData
        .map((e) => Map<String, dynamic>.from(Uri.splitQueryString(e)))
        .toList();
  }
  return [];
}

List<Map<String, dynamic>> lastFetchedData = [];

Future<List<Map<String, dynamic>>> getdata(String table, String select) async {
  if (isFetching) {
    return lastFetchedData;
  }

  isFetching = true;

  try {
    List<Map<String, dynamic>> fetchedData;

    if (country != "default" && table != "Main Drug INFO") {
      final response = filter == ""
          ? await supabase.from("$country Drug Info").select().order(
              showprov ? 'dsiply distributor' : "Brand Name",
              ascending: ascending)
          : await supabase.from("$country Drug Info").select().filter(
              (switch (data["table"]) {
                "Main Brand INDEX" =>
                  showprov ? 'dsiply distributor' : "Brand Name",
                String() => "",
                null => "",
              }),
              'ilike',
              '%$filter%');

      fetchedData = List<Map<String, dynamic>>.from(response);
    } else {
      country = "default";

      final response = filter == ""
          ? await supabase
              .from(table)
              .select()
              .order(select, ascending: ascending)
          : await supabase
              .from(table)
              .select()
              .filter(select, 'ilike', '%$filter%')
              .order(select, ascending: ascending);

      fetchedData = List<Map<String, dynamic>>.from(response);
    }

    if (fetchedData.toString() != lastFetchedData.toString()) {
      lastFetchedData = fetchedData;
      await saveDataToCache(
          '$table-$select-$filter-$country', fetchedData); // Cache the new data
    }

    return lastFetchedData;
  } finally {
    isFetching = false;
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  void themeMode() async {
    setState(() {
      toggleDarkMode();
    });

    // Save the current mode to cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', darkMode);
  }

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    darkMode = prefs.getBool('darkMode') ?? false;
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
          data = {"table": "Main Drug INFO", "select": "Drug Class"};
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Use GoogleFonts for a modern, clean font style.
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
      ),
      home: Scaffold(
        backgroundColor: colorsList["backgroundColor"],
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Headtop(toggle: themeMode, change: change),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Discover    ",
                    style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.height * 0.06,
                      fontWeight: FontWeight.bold,
                      color: colorsList["praimrytext"],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Chosing(change: change),
                SizedBox(height: 10),
                Expanded(child: CardList()),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SearchBar(change: change),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Logo Widget remains mostly unchanged.
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
          child: Image.asset('lib/assets/logo.jpg'),
        ),
        GradientText(
          'Data medix',
          style: GoogleFonts.roboto(
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

// Updated SearchBar with subtle opacity change for visual feedback.
class SearchBar extends StatefulWidget {
  const SearchBar({super.key, required this.change});
  final void Function() change;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> suggestions = []; // List to hold suggestions
  bool showSuggestions = false; // Flag to toggle suggestions visibility

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
        showSuggestions = false;
      });
      return;
    }

    // Fetch data from the database based on the query
    List<Map<String, dynamic>> fetchedData =
        await getdata(data["table"]!, data["select"]!);
    setState(() {
      suggestions = fetchedData
          .where((item) =>
              (item[data["select"]]?.toString().toLowerCase() ?? "")
                  .contains(query.toLowerCase()))
          .toList();
      showSuggestions = suggestions.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isweb = width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: isweb ? width * 0.25 : width * 0.8,
          height: height * 0.05,
          decoration: BoxDecoration(
            color: colorsList["dividerColor"],
            borderRadius: BorderRadius.circular(35),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.search, color: Colors.black),
              ),
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, height * -0.001),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      filter = value;
                      widget.change();
                      updateSuggestions(value); // Update suggestions
                    },
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                      hintText:
                          'Search in ${data["table"] == "Main Brand INDEX" ? (showprov ? 'dsiply distributor' : "Brand Name") : data["table"] == "Main Drug INFO" ? "Scientific Names" : "Drug Classes"}...',
                      hintStyle: GoogleFonts.roboto(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    style: GoogleFonts.roboto(
                      fontSize: height * 0.02,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              if (filter.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      filter = "";
                      suggestions = []; // Clear suggestions
                      showSuggestions = false;
                      widget.change();
                    });
                  },
                ),
            ],
          ),
        ),
        if (showSuggestions)
          Container(
            constraints: BoxConstraints(
              maxHeight:
                  height * 0.3, // Limit the height of the suggestions list
            ),
            width: isweb ? width * 0.25 : width * 0.8,
            decoration: BoxDecoration(
              color: colorsList["secondarytext"],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    suggestions[index][data["select"]] ?? "",
                    style: GoogleFonts.roboto(
                      color: colorsList["backgroundColor"],
                      fontSize: height * 0.02,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _controller.text =
                          suggestions[index][data["select"]] ?? "";
                      filter = suggestions[index][data["select"]] ?? "";
                      suggestions = []; // Clear suggestions after selection
                      showSuggestions = false;
                      widget.change();
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

// Headtop updated to include haptic feedback and a scale animation when toggling theme.
class Headtop extends StatefulWidget {
  const Headtop({super.key, required this.toggle, required this.change});
  final void Function() toggle;
  final void Function() change;
  @override
  State<Headtop> createState() => _HeadtopState();
}

class _HeadtopState extends State<Headtop> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation =
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.0,
    );
    _scaleAnimation =
        CurvedAnimation(parent: _scaleController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isweb = width > 800;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Logo(),
        GestureDetector(
          onTapDown: (_) {
            _scaleController.reverse();
            HapticFeedback.selectionClick();
          },
          onTapUp: (_) {
            _scaleController.forward();
            widget.toggle();
          },
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Text(
              darkMode ? "light" : "dark",
              style: GoogleFonts.roboto(
                color: colorsList["praimrytext"],
                fontSize: MediaQuery.of(context).size.height * 0.018,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Spacer(flex: isweb ? 9 : 1),
        Spacer(flex: 15),
      ],
    );
  }
}

// Chosing widget remains similar, but you can also add similar scale or opacity effects if needed.
class Chosing extends StatefulWidget {
  const Chosing({super.key, required this.change});
  final void Function() change;
  @override
  State<Chosing> createState() => _ChosingState();
}

class _ChosingState extends State<Chosing> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isweb = width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selected = 1;
                  widget.change();
                });
              },
              child: Column(
                children: [
                  Text(
                    "Brand",
                    style: GoogleFonts.roboto(
                      color: selected == 1
                          ? colorsList["praimrytext"]
                          : colorsList["secondarytext"],
                      fontSize: kIsWeb
                          ? MediaQuery.of(context).size.height * 0.022
                          : MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 2,
                    width: selected == 1 ? 40 : 0,
                    color: colorsList["praimrytext"],
                  ),
                ],
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            GestureDetector(
              onTap: () {
                setState(() {
                  selected = 0;
                  widget.change();
                });
              },
              child: Column(
                children: [
                  Text(
                    "Scientific Names",
                    style: GoogleFonts.roboto(
                      color: selected == 0
                          ? colorsList["praimrytext"]
                          : colorsList["secondarytext"],
                      fontSize: kIsWeb
                          ? MediaQuery.of(context).size.height * 0.022
                          : MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 2,
                    width: selected == 0 ? 40 : 0,
                    color: colorsList["praimrytext"],
                  ),
                ],
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            GestureDetector(
              onTap: () {
                setState(() {
                  selected = 2;
                  widget.change();
                });
              },
              child: Column(
                children: [
                  Text(
                    "Class Drugs",
                    style: GoogleFonts.roboto(
                      color: selected == 2
                          ? colorsList["praimrytext"]
                          : colorsList["secondarytext"],
                      fontSize: kIsWeb
                          ? MediaQuery.of(context).size.height * 0.022
                          : MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 2,
                    width: selected == 2 ? 40 : 0,
                    color: colorsList["praimrytext"],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (data["table"] == "Main Brand INDEX")
          Padding(
            padding: EdgeInsets.only(
                left: (MediaQuery.of(context).size.longestSide / 50)),
            child: DropdownButtonHideUnderline(
              child: Row(
                children: [
                  Container(
                    height: height * 0.05,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: colorsList["frontgroundColor"],
                    ),
                    child: DropdownButton<String>(
                      style: GoogleFonts.roboto(
                        color: colorsList["praimrytext"],
                        fontSize: kIsWeb
                            ? MediaQuery.of(context).size.height * 0.022
                            : MediaQuery.of(context).size.height * 0.02,
                        fontWeight: FontWeight.w500,
                      ),
                      value: null,
                      hint: Text(
                        country == "default" ? "Countries" : country,
                        style: GoogleFonts.roboto(
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
                            style: GoogleFonts.roboto(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        country = value!;
                        if (value == "default") {
                          showprov = false;
                        }
                        widget.change();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isweb ? width * 0.005 : width * 0.01),
                    child: Container(
                      width: isweb ? width * 0.0005 : width * 0.001,
                      height: height * 0.03,
                      color: Colors.black,
                    ),
                  ),
                  if (country != "default")
                    Divider(color: colorsList["frontgroundColor"]),
                  if (country != "default")
                    Container(
                      height: height * 0.05,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: showprov
                            ? colorsList["praimryColor"]
                            : colorsList["secondarytext"],
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            showprov = !showprov;
                            HapticFeedback.mediumImpact();
                            widget.change();
                          });
                        },
                        child: Text(
                          "Display Distributor",
                          style: GoogleFonts.roboto(
                            color: colorsList["backgroundColor"],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (country != "default")
                    Icon(
                      showprov
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: height * 0.04,
                      color: showprov
                          ? colorsList["praimryColor"]
                          : colorsList["secondarytext"],
                    ),
                ],
              ),
            ),
          )
      ],
    );
  }
}

// CardList with enhanced transition animations remains similar but you can further tweak the
// AnimatedSwitcher and FadeTransition durations/curves to suit iOS feel.
class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    // Animation controller for fade in effect.
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              padding: EdgeInsets.all(width * 0.02),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width > 1200 ? 5 : 2,
                  mainAxisExtent: height * 0.25,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemCount: 15, // Placeholder items
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.01),
                    child: Shimmer.fromColors(
                      baseColor: colorsList["dividerColor"]!.withAlpha(50),
                      highlightColor: colorsList["praimrytext"]!.withAlpha(50),
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
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width > 1200 ? 5 : 2,
                  mainAxisExtent: height * 0.25,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.01,
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
                        child: Text(
                          "No Data",
                          style: GoogleFonts.roboto(
                            color: colorsList["secondarytext"],
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        List<Map<String, dynamic>> dataList = snapshot.data!;

        return Expanded(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isweb ? 5 : 2,
                  mainAxisExtent: height * 0.25,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 600),
                    child: Padding(
                      key: ValueKey(dataList[index]),
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
                              ],
                            ),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: colorsList["backgroundColor"],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadingText(
                                country == "default"
                                    ? switch (data["table"]) {
                                        "Main Drug INFO" => dataList[index]
                                                ['Scientific Name'] ??
                                            "",
                                        "Main Brand INDEX" =>
                                          dataList[index]['Brand Name'] ?? "",
                                        _ => "",
                                      }
                                    : switch (data["table"]) {
                                        "Main Drug INFO" => dataList[index]
                                                ['Product class'] ??
                                            "",
                                        "Main Brand INDEX" =>
                                          dataList[index]["Brand Name"] ?? "",
                                        _ => "",
                                      },
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      isweb ? height * 0.024 : height * 0.022,
                                  color: colorsList["praimrytext"],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(flex: 1),
                              FadingText(
                                country == "default"
                                    ? switch (data["table"]) {
                                        "Main Drug INFO" => md.Document()
                                            .parseLines(dataList[index]
                                                    ['Drug Class']
                                                .split('\n'))
                                            .map((e) => e.textContent)
                                            .join('\n'),
                                        "Main Brand INDEX" => dataList[index]
                                                ['Scientific Name'] ??
                                            "",
                                        _ => "",
                                      }
                                    : switch (data["table"]) {
                                        "Main Brand INDEX" => dataList[index][
                                                showprov
                                                    ? 'dsiply distributor'
                                                    : 'Product class'] ??
                                            "",
                                        _ => "",
                                      },
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      isweb ? height * 0.022 : height * 0.02,
                                  color: colorsList["secondarytext"],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(flex: 10),
                              Row(
                                children: [
                                  Text(
                                    dataList[index]['Rx/OTC'] ?? "",
                                    style: GoogleFonts.roboto(
                                      fontSize: isweb
                                          ? height * 0.022
                                          : height * 0.02,
                                      color: colorsList["secondarytext"],
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      // Example of Cupertino page transition
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) => DetailScreen(
                                              data: dataList[index]),
                                        ),
                                      );
                                      HapticFeedback.selectionClick();
                                    },
                                    child: Text(
                                      "More",
                                      style: GoogleFonts.roboto(
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
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// Example detail screen to demonstrate Cupertino-style transition.
class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Detail"),
      ),
      child: Center(
        child: Text(
            "Detail view for ${data['Scientific Name'] ?? data['Brand Name'] ?? 'Item'}"),
      ),
    );
  }
}
