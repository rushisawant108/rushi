import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../widgets/custom_sidebar.dart'; // Import the custom sidebar
import 'dashboard_screen.dart';

class CourseAssignmentScreen extends StatefulWidget {
  const CourseAssignmentScreen({super.key});

  @override
  State<CourseAssignmentScreen> createState() => _CourseAssignmentScreenState();
}

class _CourseAssignmentScreenState extends State<CourseAssignmentScreen> {
  String selectedAcademicYear = '2024-25';
  String selectedSemester = 'Semester 1';
  final TextEditingController courseController = TextEditingController();
  final TextEditingController teacherController = TextEditingController();

  final List<String> academicYears = [
    '2024-25',
    '2023-24',
    '2022-23',
    '2021-22',
  ];

  final List<String> semesters = List.generate(8, (i) => 'Semester ${i + 1}');

  final List<String> availableCourses = [
    'Applied Mathematics-I',
    'Applied Physics-I',
    'Engineering Drawing',
    'Computer Programming',
    'Engineering Mechanics',
    'Data Structures',
    'OOP with Java',
    'Database Management Systems',
  ];

  final List<String> availableTeachers = [
    'Dr. RAIS ALLAUDDIN MULLA',
    'Prof. JOHN DOE',
    'Dr. ANITA SHARMA',
    'Prof. VIKAS GUPTA',
    'Dr. RINA MEHTA',
    'Prof. KIRAN JOSHI',
  ];

  final List<Map<String, String>> courseAssignments = [
    {
      'course': 'Applied Mathematics-I',
      'semester': 'Semester 1',
      'year': '2024-25',
      'teacher': 'Dr. RAIS ALLAUDDIN MULLA',
      'createdAt': 'May 26, 2025'
    },
    {
      'course': 'Applied Physics-I',
      'semester': 'Semester 1',
      'year': '2024-25',
      'teacher': 'Prof. JOHN DOE',
      'createdAt': 'June 01, 2025'
    },
    {
      'course': 'Engineering Drawing',
      'semester': 'Semester 1',
      'year': '2024-25',
      'teacher': 'Dr. RAIS ALLAUDDIN MULLA',
      'createdAt': 'June 03, 2025'
    },
    {
      'course': 'OOP with Java',
      'semester': 'Semester 4',
      'year': '2023-24',
      'teacher': 'Prof. VIKAS GUPTA',
      'createdAt': 'May 10, 2024'
    },
  ];

  List<Map<String, String>> _filteredAssignments() {
    return courseAssignments.where((assignment) {
      final matchYear = assignment['year'] == selectedAcademicYear;
      final matchSem = assignment['semester'] == selectedSemester;
      final matchCourse = courseController.text.isEmpty ||
          assignment['course']!.toLowerCase().contains(courseController.text.toLowerCase());
      final matchTeacher = teacherController.text.isEmpty ||
          assignment['teacher']!.toLowerCase().contains(teacherController.text.toLowerCase());
      return matchYear && matchSem && matchCourse && matchTeacher;
    }).toList();
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();
    final filteredData = _filteredAssignments();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Column(
                children: [
                  pw.Text(
                    'Course Assignment Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Academic Year: $selectedAcademicYear | Semester: $selectedSemester',
                    style: pw.TextStyle(fontSize: 16),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Generated on: ${DateTime.now().toString().substring(0, 16)}',
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                  ),
                  pw.Divider(thickness: 2),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Statistics Section
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Summary Statistics',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.Column(
                        children: [
                          pw.Text(
                            courseAssignments.length.toString(),
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue,
                            ),
                          ),
                          pw.Text('Total Courses'),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text(
                            courseAssignments.map((e) => e['semester']).toSet().length.toString(),
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green,
                            ),
                          ),
                          pw.Text('Unique Semesters'),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text(
                            courseAssignments.map((e) => e['teacher']).toSet().length.toString(),
                            style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.purple,
                            ),
                          ),
                          pw.Text('Unique Teachers'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),

            // Table Header
            pw.Text(
              'Course Assignments (${filteredData.length} results)',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 15),

            // Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
                4: const pw.FlexColumnWidth(2),
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey200,
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Course Name',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Teacher',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Semester',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Year',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Created',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                // Table Data
                ...filteredData.map(
                      (assignment) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(assignment['course']!),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(assignment['teacher']!),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(assignment['semester']!),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(assignment['year']!),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(assignment['createdAt']!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Widget _buildSearchFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedAcademicYear,
                decoration: InputDecoration(
                  labelText: 'Academic Year',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: academicYears.map((year) => DropdownMenuItem(value: year, child: Text(year))).toList(),
                onChanged: (val) => setState(() => selectedAcademicYear = val!),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedSemester,
                decoration: InputDecoration(
                  labelText: 'Semester',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: semesters.map((sem) => DropdownMenuItem(value: sem, child: Text(sem))).toList(),
                onChanged: (val) => setState(() => selectedSemester = val!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  return availableCourses.where((course) =>
                      course.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (val) => setState(() => courseController.text = val),
                fieldViewBuilder: (context, controller, focusNode, _) {
                  controller.text = courseController.text;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Course Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => setState(() => courseController.text = val),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  return availableTeachers.where((teacher) =>
                      teacher.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (val) => setState(() => teacherController.text = val),
                fieldViewBuilder: (context, controller, focusNode, _) {
                  controller.text = teacherController.text;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Teacher Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (val) => setState(() => teacherController.text = val),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMatchingCards() {
    final matches = _filteredAssignments();

    if (matches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Center(
          child: Text("No matching results found.", style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[700])),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: matches.map((assignment) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(assignment['course']!,
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text("👨‍🏫 Teacher: ${assignment['teacher']}", style: GoogleFonts.inter(fontSize: 14)),
                    Text("📘 Semester: ${assignment['semester']}", style: GoogleFonts.inter(fontSize: 14)),
                    Text("📅 Year: ${assignment['year']}", style: GoogleFonts.inter(fontSize: 14)),
                    Text("🕒 Created: ${assignment['createdAt']}", style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditDialog(assignment);
                        break;
                      case 'delete':
                        _showDeleteDialog(assignment);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsCards() {
    final totalCourses = courseAssignments.length;
    final uniqueSemesters = courseAssignments.map((e) => e['semester']).toSet().length;
    final uniqueTeachers = courseAssignments.map((e) => e['teacher']).toSet().length;

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        children: [
          _statCard("Total Courses", totalCourses.toString(), Colors.blue, Icons.book),
          _statCard("Unique Semesters", uniqueSemesters.toString(), Colors.green, Icons.school),
          _statCard("Unique Teachers", uniqueTeachers.toString(), Colors.purple, Icons.person),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(height: 12),
                Text(value,
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: color)),
                const SizedBox(height: 4),
                Text(label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[800])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(Map<String, String> assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Assignment', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Edit functionality for ${assignment['course']} would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Assignment edited successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, String> assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Assignment', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete the assignment for ${assignment['course']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Assignment deleted successfully!')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('Course Assignments', style: GoogleFonts.poppins(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            onPressed: _generatePDF,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      drawer: const CustomSidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Search Assignments", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSearchFilters(),
            _buildMatchingCards(),
            _buildStatsCards(),
          ],
        ),
      ),
      // Removed floatingActionButton completely
    );
  }

  @override
  void dispose() {
    courseController.dispose();
    teacherController.dispose();
    super.dispose();
  }
}