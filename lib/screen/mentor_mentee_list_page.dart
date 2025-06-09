import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MentorMenteeListPage extends StatefulWidget {
  const MentorMenteeListPage({super.key});

  @override
  State<MentorMenteeListPage> createState() => _MentorMenteeListPageState();
}

class _MentorMenteeListPageState extends State<MentorMenteeListPage> {
  final ScrollController _scrollController = ScrollController();

  String selectedFaculty = 'All';
  String selectedProgram = 'All';
  String searchText = '';

  final List<String> facultyList = ['All', 'Dr. Asha Mehta', 'Dr. Ravi Sharma'];
  final List<String> programList = ['All', 'UG', 'PG'];

  final List<Map<String, String>> mentees = [
    {
      'gr': '201',
      'collegeId': '2019CS101',
      'name': 'Ananya Patel',
      'branch': 'CS',
      'program': 'UG',
      'mentor': 'Dr. Asha Mehta'
    },
    {
      'gr': '202',
      'collegeId': '2019CS102',
      'name': 'Rohit Sharma',
      'branch': 'CS',
      'program': 'UG',
      'mentor': 'Dr. Ravi Sharma'
    },
    {
      'gr': '203',
      'collegeId': '2019CS103',
      'name': 'Sneha Kulkarni',
      'branch': 'IT',
      'program': 'PG',
      'mentor': 'Dr. Asha Mehta'
    },
  ];

  int? searchedIndex;

  void performSearch(String query) {
    setState(() {
      searchText = query.trim();
      searchedIndex = mentees.indexWhere((mentee) =>
      mentee['name']!.toLowerCase().contains(query.toLowerCase()) ||
          mentee['collegeId']!.toLowerCase().contains(query.toLowerCase()));

      if (searchedIndex != -1 && searchedIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            searchedIndex! * 85.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        });
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Student Not Found'),
            content: const Text('No matching student found.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    });
  }

  void _exportToPdf() async {
    final pdf = pw.Document();

    final filteredMentees = mentees.where((mentee) {
      final matchesSearch = searchText.isEmpty ||
          mentee['name']!.toLowerCase().contains(searchText.toLowerCase()) ||
          mentee['collegeId']!.toLowerCase().contains(searchText.toLowerCase());
      final matchesFaculty =
          selectedFaculty == 'All' || mentee['mentor'] == selectedFaculty;
      final matchesProgram =
          selectedProgram == 'All' || mentee['program'] == selectedProgram;
      return matchesSearch && matchesFaculty && matchesProgram;
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Mentor-Mentee List')),
          pw.Table.fromTextArray(
            headers: ["GR", "College ID", "Name", "Branch", "Program", "Mentor"],
            data: filteredMentees.map((mentee) => [
              mentee['gr'],
              mentee['collegeId'],
              mentee['name'],
              mentee['branch'],
              mentee['program'],
              mentee['mentor'],
            ]).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMentees = mentees.where((mentee) {
      final matchesSearch = searchText.isEmpty ||
          mentee['name']!.toLowerCase().contains(searchText.toLowerCase()) ||
          mentee['collegeId']!.toLowerCase().contains(searchText.toLowerCase());
      final matchesFaculty =
          selectedFaculty == 'All' || mentee['mentor'] == selectedFaculty;
      final matchesProgram =
          selectedProgram == 'All' || mentee['program'] == selectedProgram;
      return matchesSearch && matchesFaculty && matchesProgram;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FD),
      appBar: AppBar(
        title: const Text('Mentor-Mentee List', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2A1070),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            onPressed: _exportToPdf,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 280,
                  child: TextField(
                    onChanged: performSearch,
                    decoration: InputDecoration(
                      hintText: 'Search by name or college ID...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: selectedFaculty,
                    items: facultyList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedFaculty = val!),
                    decoration: InputDecoration(
                      labelText: 'Select Faculty',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: DropdownButtonFormField<String>(
                    value: selectedProgram,
                    items: programList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedProgram = val!),
                    decoration: InputDecoration(
                      labelText: 'Select Program',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredMentees.isEmpty
                  ? const Center(child: Text('No Mentees Found'))
                  : ListView.builder(
                controller: _scrollController,
                itemCount: filteredMentees.length,
                itemBuilder: (context, index) {
                  final mentee = filteredMentees[index];
                  final originalIndex = mentees.indexOf(mentee);
                  final isSearched = searchedIndex != null && originalIndex == searchedIndex;
                  final borderColor = isSearched ? Colors.green : Colors.transparent;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: borderColor, width: 2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      title: Text(
                        mentee['name']!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text("GR: ${mentee['gr']} • ID: ${mentee['collegeId']}"),
                          Text("Branch: ${mentee['branch']} | Program: ${mentee['program']}"),
                          Text("Mentor: ${mentee['mentor']}"),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A1070),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(mentee['name']!),
                              content: Text(
                                  'Mentor: ${mentee['mentor']}\nBranch: ${mentee['branch']}\nProgram: ${mentee['program']}'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text('Close')),
                              ],
                            ),
                          );
                        },
                        child: const Text('View'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
