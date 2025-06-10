import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class SemesterWiseReportScreen extends StatefulWidget {
  const SemesterWiseReportScreen({super.key});

  @override
  State<SemesterWiseReportScreen> createState() => _SemesterWiseReportScreenState();
}

class _SemesterWiseReportScreenState extends State<SemesterWiseReportScreen> with TickerProviderStateMixin {
  String? selectedAcademicYear;
  String? selectedDepartment;
  bool isLoading = false;
  bool showReports = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> academicYears = [
    '2024-25',
    '2023-24',
    '2022-23',
    '2021-22',
    '2020-21',
  ];

  final List<String> departments = [
    'All Departments',
    'Computer Science Engineering',
    'Information Technology',
    'Electronics & Communication',
    'Mechanical Engineering',
    'Civil Engineering',
    'Electrical Engineering',
  ];

  // Enhanced mock data with semester-wise GPA
  final Map<String, List<StudentReportData>> mockReports = {
    '2024-25': [
      StudentReportData('John Doe', 'CS001', 'Computer Science Engineering',
          [8.5, 8.7, 8.9, 9.1, 8.8, 9.0, 8.6, 8.9], 8.81),
      StudentReportData('Jane Smith', 'CS002', 'Computer Science Engineering',
          [9.2, 9.0, 9.3, 9.1, 9.4, 9.2, 9.0, 9.1], 9.16),
      StudentReportData('Mike Johnson', 'IT001', 'Information Technology',
          [7.8, 8.0, 8.2, 8.4, 8.1, 8.3, 8.0, 8.2], 8.13),
      StudentReportData('Sarah Wilson', 'IT002', 'Information Technology',
          [8.9, 9.1, 8.8, 9.0, 8.7, 8.9, 9.0, 8.8], 8.90),
      StudentReportData('David Brown', 'EC001', 'Electronics & Communication',
          [8.2, 8.4, 8.0, 8.3, 8.1, 8.2, 8.0, 8.1], 8.16),
      StudentReportData('Lisa Davis', 'EC002', 'Electronics & Communication',
          [9.0, 8.8, 9.1, 8.9, 9.2, 9.0, 8.9, 9.0], 8.99),
      StudentReportData('Robert Garcia', 'ME001', 'Mechanical Engineering',
          [7.5, 7.8, 7.6, 7.9, 7.7, 7.8, 7.6, 7.7], 7.70),
      StudentReportData('Emily Martinez', 'ME002', 'Mechanical Engineering',
          [8.3, 8.1, 8.4, 8.2, 8.0, 8.3, 8.1, 8.2], 8.20),
    ],
    '2023-24': [
      StudentReportData('Alex Kumar', 'CS101', 'Computer Science Engineering',
          [8.8, 9.0, 8.9, 9.1, 8.7, 8.9, 9.0, 8.8], 8.90),
      StudentReportData('Priya Sharma', 'IT101', 'Information Technology',
          [9.1, 8.9, 9.2, 9.0, 9.3, 9.1, 8.9, 9.0], 9.06),
      StudentReportData('Rahul Patel', 'EC101', 'Electronics & Communication',
          [8.4, 8.6, 8.3, 8.5, 8.2, 8.4, 8.3, 8.4], 8.39),
      StudentReportData('Anjali Singh', 'ME101', 'Mechanical Engineering',
          [7.9, 8.1, 7.8, 8.0, 7.7, 7.9, 8.0, 7.8], 7.90),
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<StudentReportData> get filteredReports {
    final reports = mockReports[selectedAcademicYear] ?? [];
    if (selectedDepartment == null || selectedDepartment == 'All Departments') {
      return reports;
    }
    return reports.where((r) => r.department == selectedDepartment).toList();
  }

  void _generateReports() async {
    if (selectedAcademicYear == null) {
      _showSnackBar('Please select an academic year', Colors.orange);
      return;
    }

    setState(() {
      isLoading = true;
      showReports = false;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
      showReports = true;
    });

    _animationController.forward();
    _showSnackBar('Reports generated successfully!', Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _exportToPDF() async {
    final reports = filteredReports;
    if (reports.isEmpty) {
      _showSnackBar('No data to export', Colors.orange);
      return;
    }

    try {
      final pdf = pw.Document();

      // Calculate statistics
      final avgCGPA = reports.fold(0.0, (sum, r) => sum + r.cgpa) / reports.length;
      final highestCGPA = reports.map((r) => r.cgpa).reduce((a, b) => a > b ? a : b);
      final lowestCGPA = reports.map((r) => r.cgpa).reduce((a, b) => a < b ? a : b);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          header: (context) => pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Semester-wise GPA Report',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Academic Year: $selectedAcademicYear',
                  style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                ),
                if (selectedDepartment != null && selectedDepartment != 'All Departments')
                  pw.Text(
                    'Department: $selectedDepartment',
                    style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                  ),
                pw.SizedBox(height: 10),
                pw.Divider(),
              ],
            ),
          ),
          build: (context) => [
            // Summary Section
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Summary Statistics',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Students: ${reports.length}'),
                      pw.Text('Average CGPA: ${avgCGPA.toStringAsFixed(2)}'),
                      pw.Text('Highest CGPA: ${highestCGPA.toStringAsFixed(2)}'),
                      pw.Text('Lowest CGPA: ${lowestCGPA.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Student Data Table
            pw.Text(
              'Student Performance Details',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: {
                0: const pw.FixedColumnWidth(80),
                1: const pw.FixedColumnWidth(60),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FixedColumnWidth(30),
                4: const pw.FixedColumnWidth(30),
                5: const pw.FixedColumnWidth(30),
                6: const pw.FixedColumnWidth(30),
                7: const pw.FixedColumnWidth(30),
                8: const pw.FixedColumnWidth(30),
                9: const pw.FixedColumnWidth(30),
                10: const pw.FixedColumnWidth(30),
                11: const pw.FixedColumnWidth(40),
              },
              children: [
                // Header Row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Name', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Roll No', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Department', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('S1', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('S2', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('S3', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('S4', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('S5', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('S6', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('S7', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('S8', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('CGPA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    ),
                  ],
                ),
                // Data Rows
                ...reports.map((student) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(student.name, style: const pw.TextStyle(fontSize: 9)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(student.rollNumber, style: const pw.TextStyle(fontSize: 9)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(student.department.length > 20 ?
                      student.department.substring(0, 20) + '...' : student.department,
                          style: const pw.TextStyle(fontSize: 8)),
                    ),
                    ...student.semesterGPAs.map((gpa) => pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(gpa.toStringAsFixed(1),
                          style: const pw.TextStyle(fontSize: 9)),
                    )),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(student.cgpa.toStringAsFixed(2),
                          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                )),
              ],
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Semester_Report_${selectedAcademicYear ?? 'All'}.pdf',
      );

      _showSnackBar('PDF exported successfully!', Colors.green);
    } catch (e) {
      _showSnackBar('Error exporting PDF: ${e.toString()}', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF220C5A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Semester GPA Reports',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          if (showReports)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: _exportToPDF,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                tooltip: 'Export to PDF',
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF220C5A), Color(0xFF4338CA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF220C5A).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.analytics,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Semester GPA Reports',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Analyze semester-wise GPA and overall CGPA performance',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Selection Cards
              Column(
                children: [
                  _buildSelectionCard(
                    'Academic Year',
                    selectedAcademicYear ?? 'Select Year',
                    Icons.calendar_today,
                        () => _showYearPicker(),
                    selectedAcademicYear != null,
                  ),
                  const SizedBox(height: 12),
                  _buildSelectionCard(
                    'Department',
                    selectedDepartment ?? 'All Departments',
                    Icons.business,
                        () => _showDepartmentPicker(),
                    selectedDepartment != null,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _generateReports,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: const Color(0xFF059669).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Generating Reports...',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.analytics, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Generate Reports',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Reports Section
              if (showReports)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildReportsSection(),
                ),

              if (!showReports && !isLoading)
                _buildEmptyState(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard(String title, String value, IconData icon, VoidCallback onTap, bool isSelected) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF220C5A) : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? const Color(0xFF220C5A) : const Color(0xFF6B7280),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: const Color(0xFF111827),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school,
              size: 40,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select filters to generate reports',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose academic year and department to view GPA reports.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportsSection() {
    final reports = filteredReports;

    if (reports.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(Icons.info_outline, size: 48, color: Color(0xFF6B7280)),
            const SizedBox(height: 16),
            Text(
              'No data found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
            Text(
              'No students found for the selected criteria.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      );
    }

    final avgCGPA = reports.fold(0.0, (sum, r) => sum + r.cgpa) / reports.length;
    final highestCGPA = reports.map((r) => r.cgpa).reduce((a, b) => a > b ? a : b);
    final lowestCGPA = reports.map((r) => r.cgpa).reduce((a, b) => a < b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GPA Report for ${selectedAcademicYear ?? 'All Years'}',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),

        // Summary Cards
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Students',
                    reports.length.toString(),
                    Icons.people,
                    const Color(0xFF220C5A),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Average CGPA',
                    avgCGPA.toStringAsFixed(2),
                    Icons.trending_up,
                    const Color(0xFF059669),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Highest CGPA',
                    highestCGPA.toStringAsFixed(2),
                    Icons.star,
                    const Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Lowest CGPA',
                    lowestCGPA.toStringAsFixed(2),
                    Icons.trending_down,
                    const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Responsive Table with Horizontal Scroll
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.table_chart, color: Color(0xFF374151), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Student Performance Data',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.all(const Color(0xFFF8FAFC)),
                  columns: [
                    DataColumn(
                      label: Text(
                        'Name',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Roll No',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Department',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'S1',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'S2',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'S3',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'S4',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'S5',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'S6',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'S7',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'S8',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'CGPA',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ],
                  rows: reports.map((student) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          student.name,
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ),
                      DataCell(
                        Text(
                          student.rollNumber,
                          style: GoogleFonts.inter(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        Text(
                          student.department.length > 15
                              ? '${student.department.substring(0, 15)}...'
                              : student.department,
                          style: GoogleFonts.inter(fontSize: 10),
                        ),
                      ),
                      ...student.semesterGPAs.map((gpa) => DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getGPAColor(gpa).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            gpa.toStringAsFixed(1),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getGPAColor(gpa),
                            ),
                          ),
                        ),
                      )),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getGPAColor(student.cgpa).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _getGPAColor(student.cgpa),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            student.cgpa.toStringAsFixed(2),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _getGPAColor(student.cgpa),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Icon(Icons.trending_up, color: color, size: 14),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGPAColor(double gpa) {
    if (gpa >= 9.0) return const Color(0xFF059669); // Excellent - Green
    if (gpa >= 8.0) return const Color(0xFF3B82F6); // Good - Blue
    if (gpa >= 7.0) return const Color(0xFFF59E0B); // Average - Orange
    return const Color(0xFFDC2626); // Below Average - Red
  }

  void _showYearPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Academic Year',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...academicYears.map((year) => ListTile(
              title: Text(year),
              trailing: selectedAcademicYear == year
                  ? const Icon(Icons.check, color: Color(0xFF3B82F6))
                  : null,
              onTap: () {
                setState(() {
                  selectedAcademicYear = year;
                  showReports = false;
                });
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _showDepartmentPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Department',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...departments.map((dept) => ListTile(
              title: Text(dept),
              trailing: selectedDepartment == dept
                  ? const Icon(Icons.check, color: Color(0xFF3B82F6))
                  : null,
              onTap: () {
                setState(() {
                  selectedDepartment = dept;
                  showReports = false;
                });
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class StudentReportData {
  final String name;
  final String rollNumber;
  final String department;
  final List<double> semesterGPAs; // S1 to S8
  final double cgpa;

  StudentReportData(
      this.name,
      this.rollNumber,
      this.department,
      this.semesterGPAs,
      this.cgpa,
      );
}