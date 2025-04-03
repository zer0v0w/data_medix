
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
  Widget build(BuildContext context , ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isweb = width > 800;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
              isweb ? width * 0.01 : width * 0.03, height * 0.012, 0, 0),
          width: isweb ? width * 0.034 : width * 0.08,
          height: height * 0.07,
          child: Image.asset('lib/assets/logo.jpg'),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(width*0.045,height*0.03,0,0),
          child: GradientText(
            'Data medix',
            style: GoogleFonts.roboto(
              fontSize: isweb ? height * 0.03 : height * 0.025,
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
    Map<String,String> data ={"":""};
    bool showprov = false;
  @override
  void initState() {
    super.initState();
    filter = ref.read(dataF).filter;
    data = ref.read(dataF).data;
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

  void updateSuggestions(String query) async {//
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
        showSuggestions = false;
      });
      return;
    }


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
            color: ref.watch(colorF).colorsList["dividerColor"],
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
                      ref.read(dataF).flitering(value);
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
                      filter = suggestions[index][data["select"]] ?? "";
                      suggestions = []; // Clear suggestions after selection
                      showSuggestions = false;
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
