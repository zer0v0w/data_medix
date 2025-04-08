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

      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

        bool isweb = width > 800;

    return Scaffold(
        backgroundColor: colorsList["backgroundColor"],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height* 0.02,
            ),
            Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.replay_circle_filled_outlined,
                    size: isweb? height* 0.045:height* 0.035,
                  ),
                ),
               
                Text(
                  "${data[country != "default" ? "Brand Name" : "Scientific Name"]}",
                  style: GoogleFonts.roboto(
                      color: colorsList["praimrytext"],
                      fontSize: isweb? height* 0.045:height* 0.025,
                      fontWeight: FontWeight.w600),
                ),
              
            SizedBox(width: 30,)
              ],
              
            ),
              Divider(),
            Chosebar(),
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
    final data = ref.watch(dataF).data["table"]?? "Main Drug INFO";
    final selData = ref.watch(dataF).selectedData;
    ref.watch(dataF).getColumnNames(data);

    List columnL = ref.watch(dataF).columnL;
    String sele = ref.watch(dataF).sele;

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.03, width * 0.05, 0),
          child: Wrap(
      
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 8.0,
        runSpacing: 8.0,
        children: List.generate(columnL.length, (index) {
      return HoverCard(
        sele : ref.watch(dataF).sele,
        title: columnL[index],
        
        content: selData[columnL[index]]?? "No data available",
      
        isSelected: sele == columnL[index],
        onTap: () => ref.read(dataF).setSele(columnL[index]),
        onAnotherTap : () =>ref.read(dataF).setSele(""),
        colors: colorsList,
      );})),
        ),
      ));}}


  class HoverCard extends StatefulWidget {
    final String title;
    final String content;
    final bool isSelected;
    final VoidCallback onTap;
    final Map<String, Color> colors;
    final String sele;
    final VoidCallback onAnotherTap;

    const HoverCard({super.key,
    required this.sele,

    required this.title,
    required this.content,
    required this.isSelected,
    required this.onTap,
    required this.colors, required this.onAnotherTap,
    });

    @override
    State<HoverCard> createState() => _HoverCardState();
  }

  class _HoverCardState extends State<HoverCard> {
    bool isHovered = false;
      

    

    @override
    Widget build(BuildContext context) {
      
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
      width: widget.isSelected ? MediaQuery.of(context).size.width * 0.8 : 200,
      decoration: BoxDecoration(
        color: widget.colors["backgroundColor"],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.colors["frontgroundColor"]!,
          width: 2,
        ),
        boxShadow: widget.isSelected
        ? [BoxShadow(
            color: const Color.fromARGB(32, 0, 0, 0),
            blurRadius: 10,
            spreadRadius: 2,
          )]
        : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isSelected ? widget.onAnotherTap : widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
          widget.title,
          style: GoogleFonts.roboto(
            color: widget.colors["praimrytext"],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
            ),
            if (widget.isSelected) ...[
          Divider(),
          SizedBox(height: 15),
          MarkdownBody(
            selectable: true,
            data: widget.content,
            styleSheet: MarkdownStyleSheet(
              
              p: GoogleFonts.roboto(
            fontSize: 16.0,
            height: 1.5,
            color: widget.colors["praimrytext"],
              ),
              h1: GoogleFonts.roboto(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: widget.colors["praimrytext"],
            height: 1.6,
              ),
              h2: GoogleFonts.roboto(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: widget.colors["praimrytext"],
            height: 1.6,
              ),
              h3: GoogleFonts.roboto(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: widget.colors["praimrytext"],
            height: 1.5,
              ),
              blockquote: GoogleFonts.roboto(
            fontSize: 16.0,
            fontStyle: FontStyle.italic,
            color: widget.colors["praimrytext"],
              ),
              listBullet: GoogleFonts.roboto(
            fontSize: 16.0,
            color: widget.colors["praimrytext"],
              ),
            ),
          ),
            ],
          ],
        ),
          ),
        ),
      ),
        );
    }
  }


//