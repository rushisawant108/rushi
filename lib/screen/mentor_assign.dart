import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart';

class MentorAssignScreen extends StatefulWidget {
  const MentorAssignScreen({super.key});

  @override
  State<MentorAssignScreen> createState() => _MentorAssignScreenState();
}

class _MentorAssignScreenState extends State<MentorAssignScreen> with TickerProviderStateMixin {
  final List<Map<String, String>> students = [
    {'id': 'S101', 'name': 'John Doe', 'branch': 'Computer', 'semester': 'Semester 5', 'year': '2023-2024'},
    {'id': 'S102', 'name': 'Jane Smith', 'branch': 'IT', 'semester': 'Semester 5', 'year': '2023-2024'},
    {'id': 'S103', 'name': 'Mike Johnson', 'branch': 'Computer', 'semester': 'Semester 5', 'year': '2023-2024'},
    {'id': 'S104', 'name': 'Emily Davis', 'branch': 'EXTC', 'semester': 'Semester 5', 'year': '2023-2024'},
  ];
  Set<int> selectedStudentIndices = {};

  // Controllers for inputs
  final _groupNameController = TextEditingController();

  // Dropdown selections
  String? selectedTeacher;
  String? selectedAcademicYear;
  String? selectedSemester;
  String? selectedYear;

  // Filters
  String selectedDepartment = 'All';
  bool isGroupSetupExpanded = true;
  final _searchController = TextEditingController();

  // Dummy data for dropdowns
  final List<String> teachers = [
    "Mr. Swapnil Rajendra Desai",
    "Ms. Anjali Kumar",
    "Dr. Rajesh Patel",
    "Prof. Sneha Joshi"
  ];

  final List<String> academicYears = [
    "2023-2024",
    "2022-2023",
    "2021-2022",
  ];

  final List<String> semesters = [
    "Semester 3",
    "Semester 4",
    "Semester 5",
    "Semester 6",
  ];

  final List<String> years = [
    "First Year",
    "Second Year",
    "Third Year",
    "Final Year",
  ];

  Future<void> _exportPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Mentor Group Assignment', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Teacher: ${selectedTeacher ?? "-"}'),
            pw.Text('Group Name: ${_groupNameController.text}'),
            pw.SizedBox(height: 10),
            pw.Text('Selected Students:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            ...selectedStudentIndices.map((i) {
              final student = students[i];
              return pw.Text('${student['id']} - ${student['name']} (${student['branch']}, ${student['semester']}, ${student['year']})');
            })
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  List<Map<String, String>> get filteredStudents {
    final searchText = _searchController.text.toLowerCase();
    return students.where((student) {
      final matchSearch = student['name']!.toLowerCase().contains(searchText);
      final matchDept = selectedDepartment == 'All' || student['branch'] == selectedDepartment;
      return matchSearch && matchDept;
    }).toList();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Filter Students", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: ['All', 'Computer', 'IT', 'EXTC']
                    .map((dep) => DropdownMenuItem(value: dep, child: Text(dep)))
                    .toList(),
                onChanged: (val) => setState(() => selectedDepartment = val!),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A4FCF),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Apply Filter"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Set defaults
    selectedTeacher = teachers.first;
    selectedAcademicYear = academicYears.first;
    selectedSemester = semesters.first;
    selectedYear = years.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1070),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Mentor Assign", style: GoogleFonts.poppins(color: Colors.white)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _exportPDF,
        child: const Icon(Icons.picture_as_pdf, color: Colors.red),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Collapsible Group Setup Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Group Setup", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                      trailing: IconButton(
                        icon: Icon(isGroupSetupExpanded ? Icons.expand_less : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            isGroupSetupExpanded = !isGroupSetupExpanded;
                          });
                        },
                      ),
                    ),
                    if (isGroupSetupExpanded)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            _buildDropdownField("Select Teacher", teachers, selectedTeacher, (val) => setState(() => selectedTeacher = val)),
                            const SizedBox(height: 12),
                            _buildDropdownField("Academic Year", academicYears, selectedAcademicYear, (val) => setState(() => selectedAcademicYear = val)),
                            const SizedBox(height: 12),
                            _buildDropdownField("Semester", semesters, selectedSemester, (val) => setState(() => selectedSemester = val)),
                            const SizedBox(height: 12),
                            _buildDropdownField("Year", years, selectedYear, (val) => setState(() => selectedYear = val)),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _groupNameController,
                              decoration: InputDecoration(
                                labelText: "Group Name",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Search and Filter Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search Students...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _showFilterSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A4FCF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(12),
                    minimumSize: const Size(48, 48),
                  ),
                  child: const Icon(Icons.filter_list, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Stats Bar
            Card(
              color: const Color(0xFF5A4FCF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("Department", selectedDepartment),
                    _buildStatItem("Total", filteredStudents.length.toString()),
                    _buildStatItem("Selected", selectedStudentIndices.length.toString()),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Student List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredStudents.length,
              itemBuilder: (context, idx) {
                final student = filteredStudents[idx];
                final originalIndex = students.indexOf(student);
                final selected = selectedStudentIndices.contains(originalIndex);

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  child: ExpansionTile(
                    leading: Checkbox(
                      value: selected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedStudentIndices.add(originalIndex);
                          } else {
                            selectedStudentIndices.remove(originalIndex);
                          }
                        });
                      },
                    ),
                    title: Text("${student['id']} - ${student['name']}", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.school, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text("Branch: ${student['branch']}", style: GoogleFonts.inter()),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text("Semester: ${student['semester']}", style: GoogleFonts.inter()),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text("Academic Year: ${student['year']}", style: GoogleFonts.inter()),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Assign Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Students assigned successfully!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A1070),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              child: Text("Assign", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}