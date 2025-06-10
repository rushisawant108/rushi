import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Faculty model
class Faculty {
  final String id;
  final String name;
  final String department;
  final String designation;
  final String email;
  final String phone;
  final int experience;
  final String qualification;
  final List<String> subjects;
  final String academicYear;

  Faculty({
    required this.id,
    required this.name,
    required this.department,
    required this.designation,
    required this.email,
    required this.phone,
    required this.experience,
    required this.qualification,
    required this.subjects,
    required this.academicYear,
  });
}

class FacultyWiseReportsScreen extends StatefulWidget {
  const FacultyWiseReportsScreen({super.key});

  @override
  State<FacultyWiseReportsScreen> createState() =>
      _FacultyWiseReportsScreenState();
}

class _FacultyWiseReportsScreenState extends State<FacultyWiseReportsScreen>
    with TickerProviderStateMixin {
  final List<String> academicYears = [
    '2020-2021',
    '2021-2022',
    '2022-2023',
    '2023-2024',
    '2024-2025'
  ];
  final List<String> departments = [
    'All Departments',
    'Computer Science',
    'Electronics',
    'Mechanical',
    'Civil',
    'IT'
  ];

  String selectedAcademicYear = '2023-2024';
  String selectedDepartment = 'All Departments';
  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  List<Faculty> allFaculty = [];
  List<Faculty> filteredFaculty = [];
  bool isFilterExpanded = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadSampleData();
    searchController.addListener(_filterFaculty);
    _animationController.forward();
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadSampleData() {
    // Sample faculty data
    allFaculty = [
      Faculty(
        id: 'F001',
        name: 'Dr. Sarah Johnson',
        department: 'Computer Science',
        designation: 'Professor',
        email: 'sarah.johnson@university.edu',
        phone: '+1-555-0123',
        experience: 12,
        qualification: 'Ph.D. in Computer Science',
        subjects: ['Data Structures', 'Algorithms', 'Machine Learning'],
        academicYear: '2023-2024',
      ),
      Faculty(
        id: 'F002',
        name: 'Mr. David Chen',
        department: 'Electronics',
        designation: 'Associate Professor',
        email: 'david.chen@university.edu',
        phone: '+1-555-0124',
        experience: 8,
        qualification: 'M.Tech in Electronics',
        subjects: ['Digital Electronics', 'Microprocessors'],
        academicYear: '2023-2024',
      ),
      Faculty(
        id: 'F003',
        name: 'Dr. Maria Rodriguez',
        department: 'Mechanical',
        designation: 'Assistant Professor',
        email: 'maria.rodriguez@university.edu',
        phone: '+1-555-0125',
        experience: 5,
        qualification: 'Ph.D. in Mechanical Engineering',
        subjects: ['Thermodynamics', 'Fluid Mechanics'],
        academicYear: '2023-2024',
      ),
      Faculty(
        id: 'F004',
        name: 'Prof. Robert Wilson',
        department: 'Civil',
        designation: 'Professor',
        email: 'robert.wilson@university.edu',
        phone: '+1-555-0126',
        experience: 15,
        qualification: 'Ph.D. in Civil Engineering',
        subjects: ['Structural Engineering', 'Construction Management'],
        academicYear: '2023-2024',
      ),
      Faculty(
        id: 'F005',
        name: 'Ms. Priya Sharma',
        department: 'IT',
        designation: 'Assistant Professor',
        email: 'priya.sharma@university.edu',
        phone: '+1-555-0127',
        experience: 4,
        qualification: 'M.Tech in Information Technology',
        subjects: ['Database Systems', 'Web Development'],
        academicYear: '2023-2024',
      ),
      Faculty(
        id: 'F006',
        name: 'Dr. James Brown',
        department: 'Computer Science',
        designation: 'Associate Professor',
        email: 'james.brown@university.edu',
        phone: '+1-555-0128',
        experience: 10,
        qualification: 'Ph.D. in Computer Science',
        subjects: ['Operating Systems', 'Computer Networks'],
        academicYear: '2023-2024',
      ),
    ];
    _filterFaculty();
  }

  void _filterFaculty() {
    setState(() {
      filteredFaculty = allFaculty.where((faculty) {
        bool matchesYear = faculty.academicYear == selectedAcademicYear;
        bool matchesDepartment = selectedDepartment == 'All Departments' ||
            faculty.department == selectedDepartment;
        bool matchesSearch = searchController.text.isEmpty ||
            faculty.name.toLowerCase().contains(searchController.text.toLowerCase());

        return matchesYear && matchesDepartment && matchesSearch;
      }).toList();
    });
  }

  void clearAllFilters() {
    setState(() {
      selectedAcademicYear = '2023-2024';
      selectedDepartment = 'All Departments';
      searchController.clear();
    });
    _filterFaculty();
  }

  Future<void> _generatePdfReport() async {
    setState(() => isLoading = true);

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Faculty Wise Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Academic Year: $selectedAcademicYear',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Department: $selectedDepartment',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Total Faculty: ${filteredFaculty.length}',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            ...filteredFaculty.map((faculty) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    faculty.name,
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text('Department: ${faculty.department}'),
                  pw.Text('Designation: ${faculty.designation}'),
                  pw.Text('Experience: ${faculty.experience} years'),
                  pw.Text('Qualification: ${faculty.qualification}'),
                  pw.Text('Email: ${faculty.email}'),
                  pw.Text('Phone: ${faculty.phone}'),
                  pw.Text('Subjects: ${faculty.subjects.join(', ')}'),
                ],
              ),
            )).toList(),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _buildFilterSection(),
                const SizedBox(height: 24),
                if (filteredFaculty.isEmpty)
                  _buildEmptyState()
                else
                  _buildContentSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF1C1356),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Faculty Reports',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1C1356), Color(0xFF2D1B69)],
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            onPressed: isLoading ? null : _generatePdfReport,
            tooltip: 'Export PDF',
            splashRadius: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Filter Header
            InkWell(
              onTap: () {
                setState(() {
                  isFilterExpanded = !isFilterExpanded;
                });
              },
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1356).withOpacity(0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1356),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.filter_list, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Filters',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1C1356),
                      ),
                    ),
                    const Spacer(),
                    AnimatedRotation(
                      turns: isFilterExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter Content
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isFilterExpanded ? null : 0,
              child: isFilterExpanded
                  ? Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Search Field
                    _buildFilterItem(
                      icon: Icons.search,
                      label: 'Search Faculty',
                      child: TextFormField(
                        controller: searchController,
                        decoration: _inputDecoration(
                          hint: 'Search by name...',
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dropdowns Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterItem(
                            icon: Icons.calendar_today,
                            label: 'Academic Year',
                            child: DropdownButtonFormField<String>(
                              value: selectedAcademicYear,
                              decoration: _inputDecoration(),
                              items: academicYears
                                  .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() => selectedAcademicYear = value!);
                                _filterFaculty();
                              },
                              isExpanded: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFilterItem(
                            icon: Icons.apartment,
                            label: 'Department',
                            child: DropdownButtonFormField<String>(
                              value: selectedDepartment,
                              decoration: _inputDecoration(),
                              items: departments
                                  .map((dept) => DropdownMenuItem(
                                value: dept,
                                child: Text(
                                  dept,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() => selectedDepartment = value!);
                                _filterFaculty();
                              },
                              isExpanded: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Results and Reset
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1356).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${filteredFaculty.length} faculty found',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF1C1356),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange.shade600,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          onPressed: clearAllFilters,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Faculty Found',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search criteria or reset filters to see all faculty members.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C1356),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: clearAllFilters,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Enhanced Summary Cards
          _buildSummarySection(),
          const SizedBox(height: 24),

          // Faculty List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredFaculty.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildEnhancedFacultyCard(filteredFaculty[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1C1356).withOpacity(0.05),
            const Color(0xFF2D1B69).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1C1356).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Faculty',
              '${filteredFaculty.length}',
              Icons.people,
              Colors.blue,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          Expanded(
            child: _buildSummaryCard(
              'Departments',
              '${_getUniqueDepartments()}',
              Icons.apartment,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedFacultyCard(Faculty faculty, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1C1356).withOpacity(0.05),
                      const Color(0xFF2D1B69).withOpacity(0.05),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1C1356), Color(0xFF2D1B69)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1C1356).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          faculty.name.split(' ').map((n) => n[0]).take(2).join(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            faculty.name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            faculty.designation,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF1C1356),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            faculty.department,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getExperienceColor(faculty.experience).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getExperienceColor(faculty.experience).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${faculty.experience} yrs',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: _getExperienceColor(faculty.experience),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Info
                    _buildInfoRow(Icons.email_outlined, faculty.email),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.phone_outlined, faculty.phone),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.school_outlined, faculty.qualification),
                    const SizedBox(height: 16),

                    // Subjects
                    Text(
                      'Subjects',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: faculty.subjects.map((subject) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1356).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF1C1356).withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          subject,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF1C1356),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getExperienceColor(int experience) {
    if (experience >= 10) return Colors.green;
    if (experience >= 5) return Colors.orange;
    return Colors.blue;
  }

  int _getUniqueDepartments() {
    return filteredFaculty.map((f) => f.department).toSet().length;
  }

  Widget _buildFilterItem({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF1C1356)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1356),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1C1356), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      hintStyle: GoogleFonts.poppins(
        color: Colors.grey.shade500,
        fontSize: 14,
      ),
    );
  }
}