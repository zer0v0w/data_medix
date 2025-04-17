import 'package:data_medix/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

//fading text
class FadingText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const FadingText(this.text, {super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black,

            const Color.fromARGB(0, 0, 0, 0), // Fades out
          ],
          stops: [0.8, 1.0], // Adjust for fade length
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.clip, // Ensures text stays within bounds
          style: style,
        ),
      ),
    );
  }
}

//logo

class Logo extends ConsumerWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context, ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isweb = width > 800;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
              isweb ? width * 0.01 : 0, height * 0.01, 0, 0),
          width: isweb ? width * 0.035 : width * 0.06,
          height: height * 0.06,
          child: Image.asset('lib/assets/logo.jpg'),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              isweb ? width * 0.045 : width * 0.06, height * 0.03, 0, 0),
          child: GradientText(
            'Data medix',
            style: GoogleFonts.roboto(
              fontSize: isweb ? height * 0.025 : height * 0.02,
              fontWeight: FontWeight.w600,
            ),
            colors: [
              ref.watch(colorF).colorsList['praimryColor']!,
              ref.watch(colorF).colorsList['secondaryColor']!,
            ],
          ),
        ),
      ],
    );
  }
}

//@NOTE: the search bar
class SearchBar extends ConsumerStatefulWidget {
  const SearchBar({super.key});

  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  String filter = "";
  Map<String, String> data = {"": ""};
  bool showprov = false;
  @override
  void initState() {
    super.initState();
    filter = ref.read(dataF).filter;
    data = ref.read(dataF).tables;
    showprov = ref.read(dataF).showprov;
  }

  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> suggestions = [];
  bool showSuggestions = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateSuggestions(String query) async {
    //
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
        showSuggestions = false;
      });
    } else {
      showSuggestions = true;
      List<Map<String, dynamic>> filteredData = await ref
          .read(dataF)
          .getsrearch(ref.watch(dataF).tables["table"]!,
              ref.watch(dataF).tables["select"]!);

              
      filteredData = filteredData
          .where((item) =>
              item[ref.watch(dataF).tables["select"]]
                  ?.toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ??
              false)
          .toList();

      setState(() {
        //MAKE A WAY TO GET JUST WHAT U WANT FROM THE MAP
        suggestions = filteredData.take(5).toList();
        // Limit to 5 suggestions
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isweb = width > 800;
    filter = ref.watch(dataF).filter;
    showprov = ref.watch(dataF).showprov;

    return Padding(
      padding:  EdgeInsets.fromLTRB(isweb? width/10 :16 ,isweb? 0:width*0.045,0,0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        SizedBox(
          width: isweb ? width * 0.25 : width * 0.6,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
            icon: Icon(Icons.search,
              color: ref.watch(colorF).colorsList["frontgroundColor"]),
            onPressed: () {
              setState(() {
              showSuggestions = !showSuggestions;
              if (!showSuggestions) {
                _controller.clear();
                ref.read(dataF).flitering("");
                suggestions = [];
              }
              });
            },
            ),
            if (showSuggestions)
            Expanded(
              child: TextField(
              controller: _controller,
              onChanged: (value) {
                ref.read(dataF).flitering(value);
                updateSuggestions(value);
              },
              decoration: InputDecoration(
                alignLabelWithHint: true,
                border: InputBorder.none,
                hintText:
                  'Search in ${ref.read(dataF).tables["table"] == "Main Brand INDEX" ? (ref.read(dataF).showprov ? 'dsiply distributor' : "Brand Name ${ref.read(dataF).country != "default" ? ref.read(dataF).country : ""}") : ref.read(dataF).tables["select"]}...',
                hintStyle: GoogleFonts.roboto(
                fontSize: height * 0.02,
                fontWeight: FontWeight.w500,
                color: ref.watch(colorF).colorsList["secondarytext"],
                ),
              ),
              style: GoogleFonts.roboto(
                fontSize: isweb ? height * 0.02 : height * 0.015,
                fontWeight: FontWeight.w500,
                color: ref.watch(colorF).colorsList["praimrytext"],
              ),
              ),
            ),
            if (showSuggestions && ref.watch(dataF).filter.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear,
                color: ref.watch(colorF).colorsList["secondaryColor"]),
              onPressed: () {
              setState(() {
                _controller.clear();
                ref.read(dataF).flitering("");
                suggestions = [];
                showSuggestions = false;
              });
              },
            ),
      ],
          ),
        ),
        if (showSuggestions && suggestions.isNotEmpty)
          Stack(
            alignment: Alignment.topCenter,
            children: [
            
            Container(
            constraints: BoxConstraints(
              maxHeight: height * 0.3,
            ),
            width: isweb ? width * 0.25 : width * 0.8,
            decoration: BoxDecoration(
              color: ref.watch(colorF).colorsList["secondarytext"],
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
                data = ref.watch(dataF).tables;
              return ListTile(
                title: Text(
                suggestions[index][data["select"]] ?? "",
                style: GoogleFonts.roboto(
                  color: ref.watch(colorF).colorsList["backgroundColor"],
                  fontSize: height * 0.02,
                ),
                ),
                onTap: () {
                setState(() {
                  _controller.text =
                    suggestions[index][data["select"]] ?? "";
                  ref
                    .read(dataF)
                    .flitering(suggestions[index][data["select"]] ?? "");
                  suggestions = [];
                  showSuggestions = false;
                });
                },
              );
              },
            ),
            ),
            ]),
        ],
      ),
    );
  }
}
