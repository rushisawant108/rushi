import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CourseWiseReportsScreen extends StatefulWidget {
  const CourseWiseReportsScreen({super.key});

  @override
  State<CourseWiseReportsScreen> createState() => _CourseWiseReportsScreenState();
}

class _CourseWiseReportsScreenState extends State<CourseWiseReportsScreen> {
  String? selectedYear;
  final List<String> academicYears = ['2021-22', '2022-23', '2023-24', '2024-25'];

  final Map<String, List<Map<String, dynamic>>> courseOutcomeDataByYear = {
    '2021-22': [
      {"course": "CS201", "outcome": "CO1", "achieved": "80%", "target": "75%"},
      {"course": "CS202", "outcome": "CO2", "achieved": "70%", "target": "72%"},
    ],
    '2022-23': [
      {"course": "CS301", "outcome": "CO3", "achieved": "88%", "target": "85%"},
    ],
    '2023-24': [
      {"course": "CS302", "outcome": "CO4", "achieved": "92%", "target": "90%"},
      {"course": "CS303", "outcome": "CO5", "achieved": "89%", "target": "87%"},
    ],
    '2024-25': [
      {"course": "CS304", "outcome": "CO6", "achieved": "95%", "target": "90%"},
      {"course": "CS305", "outcome": "CO7", "achieved": "85%", "target": "80%"},
    ],
  };

  void _exportToPDF() async {
    if (selectedYear == null) return;

    final pdf = pw.Document();
    final List<Map<String, dynamic>> data = courseOutcomeDataByYear[selectedYear!]!;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Course Outcome Report - $selectedYear", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...data.map((item) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                "${item['course']} - ${item['outcome']} | Achieved: ${item['achieved']}, Target: ${item['target']}",
                style: const pw.TextStyle(fontSize: 12),
              ),
            )),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final selectedData = selectedYear != null ? courseOutcomeDataByYear[selectedYear!] ?? [] : [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        automaticallyImplyLeading: true, // ← Show back arrow
        iconTheme: const IconThemeData(color: Colors.white), // ← Make arrow white
        title: Text(
          "COURSE OUTCOME ",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: _exportToPDF,
            tooltip: 'Export as PDF',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                DateFormat("dd MMM yyyy").format(DateTime.now()),
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: double.infinity,
            color: const Color(0xFFF4F6F8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Course Outcome Wise Report",
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Select Academic Year",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        value: selectedYear,
                        items: academicYears.map((year) {
                          return DropdownMenuItem(value: year, child: Text(year));
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedYear = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () => setState(() => selectedYear = null),
                      icon: const Icon(Icons.refresh, color: Colors.black54),
                      tooltip: "Reset Filters",
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: selectedYear == null
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.school_outlined, size: 50, color: Colors.black45),
                    const SizedBox(height: 16),
                    Text(
                      "Please select an academic year",
                      style: GoogleFonts.poppins(fontSize: 16.5, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Select an academic year to view course outcome reports.",
                      style: GoogleFonts.inter(fontSize: 13.5, color: Colors.grey.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                itemCount: selectedData.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = selectedData[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A1070).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.book, color: Color(0xFF2A1070)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${item['course']} - ${item['outcome']}",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Achieved: ${item['achieved']}  |  Target: ${item['target']}",
                                style: GoogleFonts.inter(fontSize: 13.5, color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
