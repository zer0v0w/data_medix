import 'package:data_medix/assets/authsW.dart';
import 'package:data_medix/assets/widget.dart';
import 'package:data_medix/providers/provider.dart';
import 'package:data_medix/screens/product_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shimmer/shimmer.dart';
import 'package:markdown/markdown.dart' as md;

//the topbar
class Headtop extends ConsumerStatefulWidget {
  const Headtop({super.key});
  @override
  ConsumerState<Headtop> createState() => _HeadtopState();
}

class _HeadtopState extends ConsumerState<Headtop>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation =
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut);
  late Map<String, Color> colorsList;
  late bool darkMode;
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
    colorsList = ref.read(colorF).colorsList;
    darkMode = ref.read(colorF).darkMode;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    colorsList = ref.watch(colorF).colorsList;
    darkMode = ref.watch(colorF).darkMode;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isWeb = width > 800;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isWeb ? width * 0.02 : width * 0.05,
          vertical: height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Logo(),
              SizedBox(width: isWeb ? width * 0.02 : width * 0.03),
              GestureDetector(
                onTapDown: (_) {
                  _scaleController.reverse();
                  HapticFeedback.selectionClick();
                },
                onTapUp: (_) {
                  _scaleController.forward();
                  ref.read(colorF).toggleDarkMode();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? width * 0.01 : width * 0.03,
                      vertical: height * 0.008),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorsList["backgroundColor"],
                      border: Border.all(
                          color: colorsList["praimrytext"]!.withOpacity(0.2))),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Row(
                      children: [
                        Icon(
                          darkMode ? Icons.light_mode : Icons.dark_mode,
                          color: colorsList["praimrytext"],
                          size: isWeb ? height * 0.02 : height * 0.018,
                        ),
                        SizedBox(width: isWeb ? width * 0.005 : width * 0.02),
                        if (isWeb)
                          Text(
                            darkMode ? "Light Mode" : "Dark Mode",
                            style: GoogleFonts.roboto(
                              color: colorsList["praimrytext"],
                              fontSize: height * 0.018,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          AccountWidget(),
        ],
      ),
    );
  }
}

//swtich the flitter's type
class Chosing extends ConsumerStatefulWidget {
  const Chosing({super.key});
  @override
  ConsumerState<Chosing> createState() => _ChosingState();
}

class _ChosingState extends ConsumerState<Chosing> {
  int selected = 0;
  Map<String, String> data = {"": ""};
  String country = "";

  List<String> arabicCountries = [""];
  bool showprov = false;
  late Map<String, Color> colorsList;
  late bool darkMode;
  @override
  void initState() {
    super.initState();
    selected = ref.read(dataF).selected;
    data = ref.read(dataF).tables;
    country = ref.read(dataF).country;
    arabicCountries = ref.read(dataF).arabicCountries;
    showprov = ref.read(dataF).showprov;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isweb = width > 800;
    colorsList = ref.watch(colorF).colorsList;
    darkMode = ref.watch(colorF).darkMode;
    showprov = ref.watch(dataF).showprov;
    country = ref.watch(dataF).country;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: isweb
                    ? MediaQuery.of(context).size.width * 0.025
                    : MediaQuery.of(context).size.width * 0.035),
            GestureDetector(
              onTap: () {
                setState(() {
                  selected = 1;
                  ref.read(dataF).change(selected);
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
                });
                ref.read(dataF).change(selected);
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
                  ref.read(dataF).change(selected);
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        if (ref.watch(dataF).tables["table"] == "Main Brand INDEX")
          Padding(
            padding: EdgeInsets.only(
                left: (MediaQuery.of(context).size.longestSide / 50)),
            child: DropdownButtonHideUnderline(
              child: Row(
                children: [
                  Container(
                    height: isweb ? height * 0.05 : height * 0.04,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: colorsList["frontgroundColor"],
                    ),
                    child: DropdownButton<String>(
                      style: GoogleFonts.roboto(
                        color: colorsList["praimrytext"],
                        fontSize: height * 0.015,
                        fontWeight: FontWeight.w500,
                      ),
                      value: null,
                      hint: Text(
                        country == "default" ? "Countries" : country,
                        style: GoogleFonts.roboto(
                          color: colorsList["backgroundColor"],
                          fontSize: height * 0.015,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      icon: Icon(
                        Icons.filter_list,
                        color: colorsList["backgroundColor"],
                        size: isweb ? height * 0.03 : height * 0.025,
                      ),
                      items: arabicCountries.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: GoogleFonts.roboto(
                                color: const Color.fromARGB(255, 91, 87, 87)),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        ref.read(dataF).countryChange(value!);
                        if (value == "default") {
                          ref.read(dataF).toggleProv(true);
                        }
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
                    GestureDetector(
                      onTap: () {
                        ref.read(dataF).toggleProv(false);
                        print(ref.watch(dataF).showprov);
                        HapticFeedback.mediumImpact();
                      },
                      child: Container(
                        height: isweb ? height * 0.05 : height * 0.04,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: showprov
                              ? colorsList["praimryColor"]
                              : colorsList["secondarytext"],
                        ),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Search by Distributors",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    isweb ? height * 0.015 : height * 0.015,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (country != "default")
                    Icon(
                      showprov
                          ? Icons.check_box
                          : Icons.check_box_outline_blank_rounded,
                      size: isweb ? height * 0.04 : height * 0.03,
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

//drugs list
class CardList extends ConsumerStatefulWidget {
  const CardList({super.key});

  @override
  ConsumerState<CardList> createState() => _CardListState();
}

class _CardListState extends ConsumerState<CardList> {

  int selected = 0;
  Map<String, String> data = {"": ""};
  String country = "";

  dynamic arabicCountries = [""];
  bool showprov = false;
  late Map<String, Color> colorsList;
  late bool darkMode;
  List<Map<String, dynamic>> dataPrices = [];
  
  @override
  void initState() {
    super.initState();
    selected = ref.read(dataF).selected;
    country = ref.read(dataF).country;
    arabicCountries = ref.read(dataF).arabicCountries;
    showprov = ref.read(dataF).showprov;
    dataPrices = ref.read(dataF).priceData;

  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(dataF).selected == 1) {
      ref.read(dataF).getPrices().then( (value) {
        dataPrices = value;
      });
      
    }
    else{

    }
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    data = ref.watch(dataF).tables;
    colorsList = ref.watch(colorF).colorsList;
    darkMode = ref.watch(colorF).darkMode;
    showprov = ref.watch(dataF).showprov;
    country = ref.watch(dataF).country;
        dataPrices = ref.watch(dataF).priceData;

    

    return Column(
      children: [
        Divider(),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: ref.watch(dataF).getdata(data["table"]!, data["select"]!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LodingCards(
                colorsList: colorsList,
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: width > 1200 ? 5 : 2,
                            mainAxisExtent: height * 0.25,
                            crossAxisSpacing: 15.0,
                            mainAxisSpacing: 15.0,
                          ),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return NodataCard(
                                colorsList: colorsList, darkMode: darkMode);
                          })));
            }

            List<Map<String, dynamic>> dataList = snapshot.data!;
            return Card(
              colorsList: colorsList,
              showprov: showprov,
              data: data,
              selected: selected,
              country: country,
              dataList: dataList,
              darkMode: darkMode,
              priceData: dataPrices ,
            );
          },
        ),
      ],
    );
  }
}

//card loding widget
class LodingCards extends StatelessWidget {
  final Map<String, Color> colorsList;
  const LodingCards({super.key, required this.colorsList});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
    ));
  }
}

class Card extends ConsumerStatefulWidget {
  const Card( 
      {super.key,
      required this.showprov,
      required this.data,
      required this.selected,
      required this.country,
      required this.dataList,
      required this.colorsList,
      required this.darkMode,
      required this.priceData});
  final List<Map<String, dynamic>> dataList;
  final int selected;
  final Map<String, String> data;
  final String country;
  final Map<String, Color> colorsList;
  final bool darkMode;
  final List<Map<String, dynamic>> priceData;

  final bool showprov;
  @override
  ConsumerState<Card> createState() => _CardState();
}

class _CardState extends ConsumerState<Card>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
   

    // Animation controller for fade in effect.
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceIn),
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
    List dataPrice = ref.watch(dataF).priceData;

     if (widget.country != "default"  && ref.watch(dataF).selected == 1) {
      ref.read(dataF).getPrices().then( (value) {
        dataPrice = value;
      });
      
    }
    else{

    }

  
    
    

    return Expanded(
      child: FadeTransition(
        opacity: _fadeInAnimation,
        child: Padding(
          padding: EdgeInsets.all(width * 0.02),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isweb ? 5 : 2,
              mainAxisExtent: isweb ? height / 4 : height / 6,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemCount: widget.dataList.length,
            itemBuilder: (context, index) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                child: Padding(
                  key: ValueKey(widget.dataList[index]),
                  padding: isweb
                      ? EdgeInsets.fromLTRB(0, height * 0.03, 0, height * 0.01)
                      : EdgeInsets.fromLTRB(
                          0, height * 0.001, 0, height * 0.001),
                  child: Container(
                    decoration: BoxDecoration(
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          transform: GradientRotation(5),
                          colors: [
                            widget.colorsList["praimrytext"]!,
                            widget.colorsList["powercolor"]!
                          ],
                        ),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: widget.colorsList["backgroundColor"],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //first
                          FadingText(
                            widget.country == "default"
                                ? widget.dataList[index]
                                            [(widget.data["select"])]
                                        .contains('#')
                                    ? md.Document()
                                        .parseLines(widget.dataList[index]
                                                [(widget.data["select"])]
                                            .split('\n'))
                                        .map((e) => e.textContent)
                                        .join('\n')
                                    : widget.dataList[index]
                                            [(widget.data["select"])]
                                        .toString()
                                : switch (widget.data["table"]) {
                                    "Main Drug INFO" => widget.dataList[index]
                                            ['Product class'] ??
                                        "w",
                                    "Main Brand INDEX" => widget.dataList[index]
                                            ["Brand Name"] ??
                                        "s",
                                    _ => "s",
                                  },
                            style: GoogleFonts.roboto(
                              fontSize: isweb ? height * 0.024 : height * 0.02,
                              color: widget.colorsList["praimrytext"],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(flex: 1),
                          //secoundow
                          FadingText(
                            widget.country == "default"
                                ? switch (widget.data["table"]) {
                                    "Main Drug INFO" => md.Document()
                                        .parseLines(widget.dataList[index]
                                                ['Drug Class']
                                            .split('\n'))
                                        .map((e) => e.textContent)
                                        .join('\n'),
                                    "Main Brand INDEX" => widget.dataList[index]
                                            ['Scientific Name'] ??
                                        "",
                                    _ => "",
                                  }
                                : switch (widget.data["table"]) {
                                    "Main Brand INDEX" => widget.dataList[index]
                                            [widget.showprov
                                                ? 'dsiply distributor'
                                                : 'Product class'] ??
                                        "",
                                    _ => "",
                                  },
                            style: GoogleFonts.roboto(
                              fontSize: isweb ? height * 0.022 : height * 0.02,
                              color: widget.colorsList["secondarytext"],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(flex: 10),
                          Text(
                            widget.country != "default"
                                    &&dataPrice.isNotEmpty? "${dataPrice[index]["Price"].toString()}\$":"",
                                
                            style: GoogleFonts.roboto(
                              fontSize: isweb ? height * 0.022 : height * 0.02,
                              color: widget.colorsList["secondarytext"],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.country != "default"
                                    ? dataPrice.isNotEmpty
                                        ? "${dataPrice[index]["Pack Size"]}"
                                        : "no price"
                                    : widget.dataList[index]['Rx/OTC'] ?? "",
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      isweb ? height * 0.020 : height * 0.018,
                                  color: widget.colorsList["secondarytext"],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  ref.read(dataF).drugCode =
                                      widget.dataList[index]['Code'];
                                       ref.read(dataF).getColumnNames();

                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                        builder: (context) => InfoPage()),
                                  );
                                  HapticFeedback.selectionClick();
                                },
                                child: Text(
                                  "More",
                                  style: GoogleFonts.roboto(
                                    fontSize: height * 0.019,
                                    fontWeight: FontWeight.w600,
                                    color: widget.colorsList["praimryColor"],
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
  }
}

class NodataCard extends StatelessWidget {
  const NodataCard(
      {super.key, required this.colorsList, required this.darkMode});
  final Map<String, Color> colorsList;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

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
  }
}
