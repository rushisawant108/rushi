import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MyFacultyScreen extends StatefulWidget {
  const MyFacultyScreen({super.key});

  @override
  State<MyFacultyScreen> createState() => _MyFacultyScreenState();
}

class _MyFacultyScreenState extends State<MyFacultyScreen> {
  final List<Map<String, String>> facultyList = [
    {
      'id': '1033',
      'name': 'JAGADALE UDAY BHAGWAN',
      'designation': 'Clerk',
      'type': 'Non-Teaching Admin',
      'dept': 'COMPUTER ENGINEERING',
      'contact': '8369631639',
    },
    {
      'id': '12345678',
      'name': 'Faculty Demo',
      'designation': 'PROFESSOR',
      'type': 'Teaching UGC',
      'dept': 'COMPUTER ENGINEERING',
      'contact': '1234567890',
    },
    {
      'id': '2002',
      'name': 'Mr. PATIL SHIRISH MADHUKAR',
      'designation': 'Technical Head Lab.',
      'type': 'Technical Regular',
      'dept': 'COMPUTER ENGINEERING',
      'contact': '9869583108',
    },
    {
      'id': '2003',
      'name': 'ATTARDE SANJAY SHANKAR',
      'designation': 'Sr Tech Asstt',
      'type': 'Technical Regular',
      'dept': 'COMPUTER ENGINEERING',
      'contact': '9004715910',
    },
    {
      'id': '20043',
      'name': 'Ms. Akanksha Bharat Jadhav',
      'designation': 'Lab Assistant',
      'type': 'Technical Contract',
      'dept': 'COMPUTER ENGINEERING',
      'contact': '9325223173',
    },
  ];

  final List<bool> _expanded = [];
  String searchText = '';
  String? departmentFilter;
  String? typeFilter;
  String? designationFilter;
  int? searchedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _expanded.addAll(List.generate(facultyList.length, (_) => false));
  }

  List<Map<String, String>> get filteredList {
    return facultyList.where((faculty) {
      final matchSearch = searchText.isEmpty ||
          faculty['name']!.toLowerCase().contains(searchText.toLowerCase()) ||
          faculty['id']!.contains(searchText);
      final matchDept =
          departmentFilter == null || faculty['dept'] == departmentFilter;
      final matchType = typeFilter == null || faculty['type'] == typeFilter;
      final matchDesignation = designationFilter == null || faculty['designation'] == designationFilter;
      return matchSearch && matchDept && matchType && matchDesignation;
    }).toList();
  }

  void searchFaculty(String value) {
    setState(() {
      searchText = value.trim();
      searchedIndex = facultyList.indexWhere((faculty) =>
      faculty['name']!.toLowerCase().contains(searchText.toLowerCase()) ||
          faculty['id']!.contains(searchText));
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
          title: const Text("Faculty Not Found"),
          content: const Text("No faculty matched your search."),
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
      typeFilter = null;
      designationFilter = null;
      searchText = '';
      searchedIndex = null;
    });
  }

  void showFilterDialog() {
    final departments = facultyList.map((e) => e['dept']!).toSet().toList();
    final designations = facultyList.map((e) => e['designation']!).toSet().toList();

    String? tempDepartmentFilter = departmentFilter;
    String? tempDesignationFilter = designationFilter;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.filter_list, color: Color(0xFF3B1B9D)),
                  const SizedBox(width: 8),
                  const Text('Filter Faculty'),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Department',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                          ...departments.map((d) =>
                              DropdownMenuItem(value: d, child: Text(d))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Designation',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        hint: const Text("Select Designation"),
                        value: tempDesignationFilter,
                        isExpanded: true,
                        underline: const SizedBox(),
                        onChanged: (value) {
                          setDialogState(() {
                            tempDesignationFilter = value;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text("All Designations"),
                          ),
                          ...designations.map((d) =>
                              DropdownMenuItem(value: d, child: Text(d))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      departmentFilter = null;
                      designationFilter = null;
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
                      designationFilter = tempDesignationFilter;
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
          },
        );
      },
    );
  }

  void exportToPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text("Faculty List", style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ["ID", "Name", "Designation", "Type", "Dept", "Contact"],
            data: filteredList.map((f) {
              return [
                f['id'],
                f['name'],
                f['designation'],
                f['type'],
                f['dept'],
                f['contact']
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
        title: const Text('My Faculty', style: TextStyle(color: Colors.white)),
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
                      hintText: 'Search Faculty...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: searchFaculty,
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
                        if (departmentFilter != null || designationFilter != null)
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
                    tooltip: "Filter Faculty",
                  ),
                ),
                const SizedBox(width: 8),
                // Export buttons
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
            // Show active filters
            if (departmentFilter != null || designationFilter != null)
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
                    const Text("Active filters: ", style: TextStyle(fontWeight: FontWeight.w600)),
                    if (departmentFilter != null)
                      Chip(
                        label: Text("Dept: $departmentFilter"),
                        onDeleted: () => setState(() => departmentFilter = null),
                        deleteIconColor: Colors.red,
                        backgroundColor: Colors.blue.shade100,
                      ),
                    if (designationFilter != null)
                      Chip(
                        label: Text("Designation: $designationFilter"),
                        onDeleted: () => setState(() => designationFilter = null),
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
                'Total Faculty: ${filteredList.length}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final faculty = filteredList[index];
                  final isMatched = searchedIndex != null &&
                      faculty['id'] ==
                          facultyList[searchedIndex!]['id'];

                  return Container(
                    decoration: isMatched
                        ? BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade100,
                          Colors.green.shade50
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
                          '${faculty['id']} - ${faculty['name']}',
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
                          _buildDetailRow('Designation', faculty['designation']!),
                          _buildDetailRow('Faculty Type', faculty['type']!),
                          _buildDetailRow('Department', faculty['dept']!),
                          _buildDetailRow('Contact', faculty['contact']!),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: label == 'Department'
                  ? Colors.deepPurple
                  : label == 'Faculty Type'
                  ? Colors.indigo
                  : label == 'Designation'
                  ? Colors.blue
                  : Colors.black,
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