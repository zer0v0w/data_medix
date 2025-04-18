import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/provider.dart';

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorList = ref.watch(colorF).colorsList;
    final data = ref.watch(dataF).drugData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorList["backgroundColor"],
        shadowColor: colorList["frontgroundColor"],
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          data != null ? data["Scientific Name"] ?? data["Brand Name"] : "",
          style:
              GoogleFonts.roboto(color: colorList["praimrytext"], fontSize: 26),
        )),
      ),
      backgroundColor: colorList["backgroundColor"],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Center(
            child: Icon(
          Icons.arrow_back_rounded,
          weight: 64,
          size: 32,
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: PhonePage(),
    );
  }
}

class PhonePage extends ConsumerStatefulWidget {
  const PhonePage({super.key});

  @override
  ConsumerState<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends ConsumerState<PhonePage> {
  String selectName = "Indications";
  @override
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = ref.read(dataF).drugData ?? {'': ''};
    final columnNames = ref.read(dataF).columnL;
    String _highlightMedicalTerms(String text) {
      final medicalTerms = [
        'aspirin',
        'ibuprofen',
        'paracetamol',
        'acetaminophen',
        'antibiotic',
        'antiviral',
        'antifungal',
        'analgesic',
        'anesthetic',
        'antihistamine',
        'antidepressant',
        'antipsychotic',
        'anticoagulant',
        'antiseptic',
        'beta-blocker',
        'calcium channel blocker',
        'diuretic',
        'steroid',
        'insulin',
        'vaccine',
        'chemotherapy',
        'radiotherapy',
        'inflammation',
        'infection',
        'fever',
        'pain',
        'migraine',
        'headache',
        'nausea',
        'vomiting',
        'diarrhea',
        'constipation',
        'allergy',
        'rash',
        'swelling',
        'fracture',
        'sprain',
        'strain',
        'arthritis',
        'osteoporosis',
        'diabetes',
        'hypertension',
        'hypotension',
        'anemia',
        'cancer',
        'tumor',
        'malignant',
        'benign',
        'cardiovascular',
        'neurological',
        'respiratory',
        'gastrointestinal',
        'dermatological',
        'psychiatric',
        'pediatric',
        'geriatric',
        'surgery',
        'therapy',
        'diagnosis',
        'prognosis',
        'treatment',
        'prescription',
        'over-the-counter',
        'side effects',
        'contraindications',
        'dosage',
        'symptoms',
        'chronic',
        'acute',
        'autoimmune',
        'viral',
        'bacterial',
        'fungal',
        'parasitic',
        'genetic',
        'hereditary',
        'metabolic',
        'hormonal',
        'endocrine',
        'cardiology',
        'neurology',
        'pulmonology',
        'dermatology',
        'oncology',
        'hematology',
        'immunology',
        'nephrology',
        'urology',
        'gynecology',
        'obstetrics',
        'orthopedics',
        'ophthalmology',
        'otolaryngology',
        'psychiatry',
        'psychology',
        'pharmacology',
        'pathology',
        'radiology',
        'anatomy',
        'physiology',
        'biochemistry',
        'microbiology',
        'epidemiology',
        'public health',
        'first aid',
        'emergency',
        'ICU',
        'CPR',
        'AED',
        'triage',
        'vital signs',
        'blood pressure',
        'heart rate',
        'respiratory rate',
        'oxygen saturation'
      ];
      for (var term in medicalTerms) {
        text = text.replaceAllMapped(
          RegExp(r'\b' + RegExp.escape(term) + r'\b', caseSensitive: false),
          (match) => '**${match.group(0)}**',
        );
      }
      return text;
    }

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
          padding: EdgeInsets.fromLTRB(16.0, 64, 16, 0),
          child: Markdown(
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
            data: _highlightMedicalTerms(selectName == "Scientific Name"
                ? "# ${data[selectName] ?? 'No data available'}"
                : selectName == "Brand Name"
                    ? "## Brand: ${data[selectName] ?? 'No data available'}"
                    : selectName == "Description"
                        ? "### Description\n\n${data[selectName] ?? 'No description provided'}"
                        : selectName == "Usage"
                            ? "### Usage\n\n${data[selectName] ?? 'No usage information available'}"
                            : selectName == "Side Effects"
                                ? "### Side Effects\n\n${data[selectName] ?? 'No side effects listed'}"
                                : "### $selectName\n\n${data[selectName] ?? 'No data available'}"),
          ),
        ),
      ],
    );
  }
}
