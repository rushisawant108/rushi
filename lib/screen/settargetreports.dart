import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../widgets/custom_sidebar.dart';

class SetTargetReportScreen extends StatefulWidget {
  const SetTargetReportScreen({super.key});

  @override
  State<SetTargetReportScreen> createState() => _SetTargetReportScreenState();
}

class _SetTargetReportScreenState extends State<SetTargetReportScreen> {
  String? selectedAcademicYear;
  final List<String> academicYears = ['2022-2023', '2023-2024', '2024-2025'];
  final String todayDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  final List<String> availablePOs = ['PO1', 'PO2', 'PO3', 'PO4', 'PO5'];
  final Set<String> selectedPOs = {'PO1', 'PO2', 'PO3'};

  final List<Map<String, String>> dummyData = [
    {'Course': 'Math', 'PO1': '80', 'PO2': '85', 'PO3': '90', 'PO4': '88', 'PO5': '82'},
    {'Course': 'Science', 'PO1': '75', 'PO2': '88', 'PO3': '82', 'PO4': '85', 'PO5': '79'},
    {'Course': 'English', 'PO1': '78', 'PO2': '81', 'PO3': '89', 'PO4': '86', 'PO5': '84'},
  ];

  void exportToPdf() async {
    if (selectedAcademicYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an academic year before exporting.')),
      );
      return;
    }

    final pdf = pw.Document();
    final headers = ['Course', ...selectedPOs];

    final data = dummyData.map((row) {
      return [
        row['Course'] ?? '',
        ...selectedPOs.map((po) => row[po] ?? '-'),
      ];
    }).toList();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Set/Target Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Academic Year: $selectedAcademicYear'),
            pw.Text('Generated on: $todayDate'),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: headers,
              data: data,
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
              ),
              cellStyle: const pw.TextStyle(fontSize: 12),
              cellAlignment: pw.Alignment.center,
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomSidebar(),
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C1A6C),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Set Target Report",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            tooltip: 'Export as PDF',
            onPressed: exportToPdf,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                todayDate,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "📈 Set/Target Reports",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "View program-level course-PO matrix for set and target values",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                labelText: 'Academic Year',
                labelStyle: GoogleFonts.poppins(),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              value: selectedAcademicYear,
              items: academicYears.map((year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year, style: GoogleFonts.poppins()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAcademicYear = value;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: availablePOs.map((po) {
                return FilterChip(
                  label: Text(po, style: GoogleFonts.poppins()),
                  selected: selectedPOs.contains(po),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedPOs.add(po);
                      } else {
                        selectedPOs.remove(po);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: selectedAcademicYear == null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        "Please select an academic year",
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Select an academic year to view set/target reports.",
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      )
                    ],
                  ),
                )
                    : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => const Color(0xFFEDE7F6),
                    ),
                    columns: [
                      DataColumn(
                          label: Text('Course',
                              style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold))),
                      ...selectedPOs.map((po) => DataColumn(
                          label: Text(po,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold))))
                    ],
                    rows: dummyData.map((row) {
                      return DataRow(cells: [
                        DataCell(Text(row['Course']!, style: GoogleFonts.poppins())),
                        ...selectedPOs.map((po) => DataCell(
                            Text(row[po] ?? '-', style: GoogleFonts.poppins())))
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
