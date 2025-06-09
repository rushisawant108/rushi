import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final List<Map<String, String>> studentList = [
    {
      'id': 'ST1001',
      'name': 'Anjali Sharma',
      'year': '3rd Year',
      'branch': 'Computer Engineering',
      'department': 'Engineering',
      'contact': '9876543210',
    },
    {
      'id': 'ST1002',
      'name': 'Rohit Kumar',
      'year': '2nd Year',
      'branch': 'Mechanical Engineering',
      'department': 'Engineering',
      'contact': '9123456789',
    },
    {
      'id': 'ST1003',
      'name': 'Sneha Patel',
      'year': '4th Year',
      'branch': 'Electrical Engineering',
      'department': 'Engineering',
      'contact': '9988776655',
    },
    {
      'id': 'ST1004',
      'name': 'Rahul Joshi',
      'year': '1st Year',
      'branch': 'Civil Engineering',
      'department': 'Engineering',
      'contact': '9871234567',
    },
    {
      'id': 'ST1005',
      'name': 'Meena Singh',
      'year': '3rd Year',
      'branch': 'Computer Engineering',
      'department': 'Engineering',
      'contact': '9012345678',
    },
  ];

  final ScrollController _scrollController = ScrollController();

  String searchText = '';
  String? departmentFilter;
  String? yearFilter;
  String? branchFilter;
  int? searchedIndex;

  @override
  void initState() {
    super.initState();
  }

  List<Map<String, String>> get filteredList {
    return studentList.where((student) {
      final matchSearch = searchText.isEmpty ||
          student['name']!.toLowerCase().contains(searchText.toLowerCase()) ||
          student['id']!.contains(searchText);
      final matchDept =
          departmentFilter == null || student['department'] == departmentFilter;
      final matchYear = yearFilter == null || student['year'] == yearFilter;
      final matchBranch = branchFilter == null || student['branch'] == branchFilter;
      return matchSearch && matchDept && matchYear && matchBranch;
    }).toList();
  }

  void searchStudent(String value) {
    setState(() {
      searchText = value.trim();
      searchedIndex = studentList.indexWhere((student) =>
      student['name']!.toLowerCase().contains(searchText.toLowerCase()) ||
          student['id']!.contains(searchText));
    });

    if (searchedIndex != -1 && searchedIndex != null) {
      _scrollController.animateTo(
        searchedIndex! * 160.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (value.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Student Not Found"),
          content: const Text("No student matched your search."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  void clearFilters() {
    setState(() {
      departmentFilter = null;
      yearFilter = null;
      branchFilter = null;
      searchText = '';
      searchedIndex = null;
    });
  }

  void showFilterDialog() {
    final departments = studentList.map((e) => e['department']!).toSet().toList();
    final years = studentList.map((e) => e['year']!).toSet().toList();
    final branches = studentList.map((e) => e['branch']!).toSet().toList();

    String? tempDepartmentFilter = departmentFilter;
    String? tempYearFilter = yearFilter;
    String? tempBranchFilter = branchFilter;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.filter_list, color: Color(0xFF3B1B9D)),
                const SizedBox(width: 8),
                const Text('Filter Students'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Department',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        hint: const Text("Select Department"),
                        value: tempDepartmentFilter,
                        isExpanded: true,
                        underline: const SizedBox(),
                        onChanged: (value) {
                          setDialogState(() {
                            tempDepartmentFilter = value;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text("All Departments"),
                          ),
                          ...departments
                              .map((d) => DropdownMenuItem(value: d, child: Text(d))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Year',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        hint: const Text("Select Year"),
                        value: tempYearFilter,
                        isExpanded: true,
                        underline: const SizedBox(),
                        onChanged: (value) {
                          setDialogState(() {
                            tempYearFilter = value;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text("All Years"),
                          ),
                          ...years
                              .map((y) => DropdownMenuItem(value: y, child: Text(y))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Branch',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        hint: const Text("Select Branch"),
                        value: tempBranchFilter,
                        isExpanded: true,
                        underline: const SizedBox(),
                        onChanged: (value) {
                          setDialogState(() {
                            tempBranchFilter = value;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text("All Branches"),
                          ),
                          ...branches
                              .map((b) => DropdownMenuItem(value: b, child: Text(b))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    departmentFilter = null;
                    yearFilter = null;
                    branchFilter = null;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    departmentFilter = tempDepartmentFilter;
                    yearFilter = tempYearFilter;
                    branchFilter = tempBranchFilter;
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B1B9D),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply'),
              ),
            ],
          );
        });
      },
    );
  }

  void exportToPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text("Student List", style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ["ID", "Name", "Year", "Branch", "Department", "Contact"],
            data: filteredList.map((s) {
              return [
                s['id'],
                s['name'],
                s['year'],
                s['branch'],
                s['department'],
                s['contact']
              ];
            }).toList(),
          )
        ],
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  void exportToExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Excel export is not implemented yet.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Students', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3B1B9D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Filter Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Students...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: searchStudent,
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: showFilterDialog,
                    icon: Stack(
                      children: [
                        const Icon(Icons.filter_list, color: Color(0xFF3B1B9D)),
                        if (departmentFilter != null ||
                            yearFilter != null ||
                            branchFilter != null)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 8,
                                minHeight: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                    tooltip: "Filter Students",
                  ),
                ),
                const SizedBox(width: 8),
                // Export PDF Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: exportToPdf,
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    tooltip: "Export to PDF",
                  ),
                ),
                const SizedBox(width: 8),
                // Export Excel Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: exportToExcel,
                    icon: const Icon(Icons.table_view, color: Colors.green),
                    tooltip: "Export to Excel",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Active Filters display
            if (departmentFilter != null ||
                yearFilter != null ||
                branchFilter != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    const Text(
                      "Active filters: ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (departmentFilter != null)
                      Chip(
                        label: Text("Dept: $departmentFilter"),
                        onDeleted: () => setState(() => departmentFilter = null),
                        deleteIconColor: Colors.red,
                        backgroundColor: Colors.blue.shade100,
                      ),
                    if (yearFilter != null)
                      Chip(
                        label: Text("Year: $yearFilter"),
                        onDeleted: () => setState(() => yearFilter = null),
                        deleteIconColor: Colors.red,
                        backgroundColor: Colors.purple.shade100,
                      ),
                    if (branchFilter != null)
                      Chip(
                        label: Text("Branch: $branchFilter"),
                        onDeleted: () => setState(() => branchFilter = null),
                        deleteIconColor: Colors.red,
                        backgroundColor: Colors.orange.shade100,
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total Students: ${filteredList.length}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // List of Students
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final student = filteredList[index];
                  final isMatched = searchedIndex != null &&
                      student['id'] == studentList[searchedIndex!]['id'];

                  return Container(
                    decoration: isMatched
                        ? BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade100,
                          Colors.green.shade50,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    )
                        : null,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          '${student['id']} - ${student['name']}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: const Color(0xFF3B1B9D),
                          ),
                        ),
                        initiallyExpanded: false,
                        childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        children: [
                          _buildDetailRow('Year', student['year']!),
                          _buildDetailRow('Branch', student['branch']!),
                          _buildDetailRow('Department', student['department']!),
                          _buildDetailRow('Contact', student['contact']!),
                        ],
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

  Widget _buildDetailRow(String label, String value) {
    Color labelColor;
    switch (label) {
      case 'Department':
        labelColor = Colors.deepPurple;
        break;
      case 'Year':
        labelColor = Colors.purple;
        break;
      case 'Branch':
        labelColor = Colors.orange;
        break;
      default:
        labelColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
