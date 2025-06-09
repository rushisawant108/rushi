import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AssignCourseScreen extends StatefulWidget {
  const AssignCourseScreen({super.key});

  @override
  State<AssignCourseScreen> createState() => _AssignCourseScreenState();
}

class _AssignCourseScreenState extends State<AssignCourseScreen> {
  final pdf = pw.Document();
  final List<String> _teachers = [
    'Mr. SWAPNIL RAJENDRA DESAI',
    'Ms. SYEDA MARIYA BEGUM KHAJA NAZIMUDDIN DAIMI',
    'Mrs. PRAJAKTA SUDHIRKUMAR KHELKAR',
    'Dr. MAHENDRA EKNATH PAWAR',
    'Prof. SURESH VISHWANATH NAYAK',
    'Ms. RUPALI JADHAV',
    'Dr. ANITA SHETTY'
  ];
  final List<String> _selectedTeachers = [];

  String? selectedYear;
  String? selectedSemester;
  String? selectedCourse;

  final List<String> _years = ['2022-2023', '2023-2024', '2024-2025'];
  final List<String> _semesters = ['Semester 1', 'Semester 2', 'Semester 3'];
  final List<String> _courses = ['Mathematics', 'Physics', 'Chemistry', 'Computer Science'];

  String _searchQuery = '';

  void _generatePDF() async {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Assigned Courses Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 16),
              pw.Text('Date: ${_getCurrentFormattedDate()}'),
              pw.Text('Academic Year: $selectedYear'),
              pw.Text('Semester: $selectedSemester'),
              pw.Text('Course: $selectedCourse'),
              pw.SizedBox(height: 12),
              pw.Text('Assigned Teachers:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ..._selectedTeachers.map((t) => pw.Bullet(text: t)),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  String _getCurrentFormattedDate() {
    final now = DateTime.now();
    return DateFormat('dd MMMM yyyy').format(now);
  }

  void _assignCourse() {
    if (selectedYear == null || selectedSemester == null || selectedCourse == null || _selectedTeachers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields and assign at least one teacher.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Course successfully assigned to teacher!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addTeacher(String name) {
    setState(() {
      if (!_selectedTeachers.contains(name)) {
        _selectedTeachers.add(name);
      }
    });
  }

  void _removeTeacher(String name) {
    setState(() {
      _selectedTeachers.remove(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1457),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Assign Courses',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: Text(
                _getCurrentFormattedDate(),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assign Courses',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 4),
            Text('Assign teachers to courses for Computer Engineering',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildDropdown(label: 'Branch', hint: 'Computer Engineering', isDisabled: true),
                    _buildDropdown(label: 'Academic Year', hint: 'Select Academic Year', items: _years, selectedValue: selectedYear, onChanged: (val) => setState(() => selectedYear = val)),
                    _buildDropdown(label: 'Semester', hint: 'Select Semester', items: _semesters, selectedValue: selectedSemester, onChanged: (val) => setState(() => selectedSemester = val)),
                    _buildDropdown(label: 'Course (Subject)', hint: 'Select Course', items: _courses, selectedValue: selectedCourse, onChanged: (val) => setState(() => selectedCourse = val), fullWidth: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.group_add, color: Colors.black54),
                        const SizedBox(width: 8),
                        Text('Teacher Assignment',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Assign one or more teachers to this course',
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search teachers...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_selectedTeachers.isNotEmpty) ...[
                      Text('Selected Teachers:',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      ..._selectedTeachers.map((t) => ListTile(
                        title: Text(t, style: GoogleFonts.poppins(fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeTeacher(t),
                        ),
                      )),
                      const Divider(),
                    ],
                    ..._teachers
                        .where((name) => name.toLowerCase().contains(_searchQuery.toLowerCase()))
                        .map((name) => _buildTeacherTile(name: name)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _assignCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D1457),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Assign',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: _generatePDF,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.picture_as_pdf, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    List<String>? items,
    String? selectedValue,
    Function(String?)? onChanged,
    bool isDisabled = false,
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: isDisabled ? null : selectedValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: isDisabled ? Colors.grey[200] : Colors.white,
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: isDisabled
                ? null
                : items?.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
            onChanged: isDisabled ? null : onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherTile({required String name}) {
    final alreadyAdded = _selectedTeachers.contains(name);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 1,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: CircleAvatar(child: Text(name.split(" ").first[0])),
          title: Text(name, style: GoogleFonts.poppins(fontSize: 14)),
          trailing: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: alreadyAdded ? Colors.grey : const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: alreadyAdded ? null : () => _addTeacher(name),
            icon: const Icon(Icons.person_add_alt, size: 18),
            label: const Text("Add"),
          ),
        ),
      ),
    );
  }
}