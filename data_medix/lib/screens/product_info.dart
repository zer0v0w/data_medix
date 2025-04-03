import 'package:data_medix/assets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/provider.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    dynamic data = ref.watch(dataF).selectedData;
    Map<String, Color> colorsList = ref.watch(colorF).colorsList;
    String country = ref.watch(dataF).country;

    return Scaffold(
        backgroundColor: colorsList["backgroundColor"],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.replay_circle_filled_outlined,
                    size: MediaQuery.of(context).size.height * 0.045,
                  ),
                ),
                Logo(),
                Spacer(
                  flex: 2,
                ),
                Text(
                  "${data[country != "default" ? "Brand Name" : "Scientific Name"]}",
                  style: GoogleFonts.roboto(
                      color: colorsList["praimrytext"],
                      fontSize: MediaQuery.of(context).size.height * 0.045,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(
                  flex: 3,
                ),
              ],
            ),
            Chosebar(),
            Info(),
          ],
        ));
  }
}

class Chosebar extends ConsumerStatefulWidget {
  const Chosebar({super.key});

  @override
  ConsumerState<Chosebar> createState() => _ChosebarState();
}

class _ChosebarState extends ConsumerState<Chosebar> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Map<String, Color> colorsList = ref.watch(colorF).colorsList;

    double height = MediaQuery.of(context).size.height;

    ref.watch(dataF).getColumnNames(ref.watch(dataF).data["table"]!);
    List columnL = ref.watch(dataF).columnL;
    String sele = ref.watch(dataF).sele;

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.white, Colors.transparent],
          stops: [0.95, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: Container(
          margin:
              EdgeInsets.fromLTRB(width * 0.05, height * 0.03, width * 0.05, 0),
          width: width * 0.9,
          height: height * 0.06,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: columnL.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: TextButton(
                    onPressed: () {
                      ref.read(dataF).setSele(columnL[index]);
                    },
                    child: FittedBox(
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: (sele == columnL[index]
                                  ? colorsList["praimryColor"]
                                  : colorsList["backgroundColor"]),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: colorsList["frontgroundColor"]!,
                                  width: 2)),
                          child: Text("${columnL[index]}",
                              style: GoogleFonts.roboto(
                                  color: (sele == columnL[index]
                                  ? colorsList["backgroundColor"]
                                  : colorsList["praimrytext"]),))),
                    ),
                  ),
                );
              })),
    );
  }
}

class Info extends ConsumerStatefulWidget {
  const Info({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfoState();
}

class _InfoState extends ConsumerState<Info> {
  @override
  Widget build(BuildContext context) {
    dynamic data = ref.watch(dataF).selectedData;
    String sele = ref.watch(dataF).sele;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.7,
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: Markdown(
          physics: ScrollPhysics(),
          selectable: true,
          data: data[sele] ?? '',
          styleSheet: MarkdownStyleSheet(
            p: GoogleFonts.roboto(fontSize: 16.0),
            h1: GoogleFonts.roboto(fontSize: 24.0, fontWeight: FontWeight.bold),
            h2: GoogleFonts.roboto(fontSize: 20.0, fontWeight: FontWeight.bold),
            h3: GoogleFonts.roboto(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
