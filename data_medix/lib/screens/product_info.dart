import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/provider.dart';

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(dataF).getColumnNames();
    final colorList = ref.read(colorF).colorsList;
    final data = ref.read(dataF).drugData;
   
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor:colorList["backgroundColor"] ,
        shadowColor: colorList["frontgroundColor"],
        elevation: 1,
        automaticallyImplyLeading: false,
        
        title: Center(child: Text(data != null? data[ "Scientific Name"] ?? data[ "Brand Name"]: "" , style: GoogleFonts.roboto(color: colorList["praimrytext"] , fontSize: 26 ),)),
      ),
      backgroundColor: colorList["backgroundColor"] ,
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.pop(context);} , child: Center(child: Icon(  Icons.arrow_back_rounded,weight: 64 , size: 32,)),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: PhonePage() ,
    );
  }
}

class PhonePage extends ConsumerStatefulWidget {
  const PhonePage({super.key});

  @override
  ConsumerState<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends ConsumerState<PhonePage> {
  String selectName = "Scientific Name";

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ref.read(dataF).drugData ?? {'': ''};
    final columnNames = ref.read(dataF).columnL;

    return Stack(
      children: [
        
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu<String>(
                  initialSelection: selectName,
                  dropdownMenuEntries: columnNames
                      .map(
                        (item) => DropdownMenuEntry<String>(
                          value: item,
                          label: item,
                        ),
                      )
                      .toList(),
                  onSelected: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectName = newValue;
                      });
                      
                    }
                  },
                ),
          ],
        ),
      ),
        
        Padding(
          padding:  EdgeInsets.fromLTRB(16.0,64,16,0),
          child: Markdown(//TODO make the markdown more likeable and do a clean up for the app
            selectable: true,
            shrinkWrap: true,
            softLineBreak: true,
              styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              h2: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              p: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
              code: TextStyle(
                fontSize: 14,
                fontFamily: 'Consolas',
                backgroundColor: Colors.grey[200],
                color: Colors.blueAccent,
              ),
              blockquote: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
              listBullet: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              ),
          
            data: data[selectName] ?? "# No data",
          ),
        )
      ],
    );
  }
}