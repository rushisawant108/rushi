import 'package:flutter/material.dart';

class FacultyWiseReportsScreen extends StatefulWidget {
  const FacultyWiseReportsScreen({super.key});

  @override
  State<FacultyWiseReportsScreen> createState() => _FacultyWiseReportsScreenState();
}

class _FacultyWiseReportsScreenState extends State<FacultyWiseReportsScreen> {
  String selectedAcademicYear = 'No academic years available';
  String selectedDepartment = 'All Departments';
  final TextEditingController searchController = TextEditingController();

  // Function to clear all filters (common for both buttons)
  void clearAllFilters() {
    setState(() {
      selectedAcademicYear = 'No academic years available';
      selectedDepartment = 'All Departments';
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0C6E), // Purple background
        title: const Text(
          'Faculty Wise Reports',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Academic Year Heading + Dropdown
                  Row(
                    children: const [
                      Icon(Icons.calendar_today, size: 20, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(
                        'Academic Year',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedAcademicYear,
                    items: [
                      const DropdownMenuItem(
                        value: 'No academic years available',
                        child: Text('No academic years available'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedAcademicYear = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Faculty Heading + TextField
                  Row(
                    children: const [
                      Icon(Icons.search, size: 20, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(
                        'Search Faculty',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by faculty name...', // your required placeholder
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Department Heading + Dropdown
                  Row(
                    children: const [
                      Icon(Icons.apartment, size: 20, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(
                        'Department',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedDepartment,
                    items: [
                      const DropdownMenuItem(
                        value: 'All Departments',
                        child: Text('All Departments'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reset Filters button (aligned right)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue, // Text color forced to blue
                      ),
                      onPressed: clearAllFilters, // function that clears all filters
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Filters'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // No Faculty Found Section
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'No faculty found',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please select an academic year to view faculty members.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    MouseRegion(
                      cursor: SystemMouseCursors.click, // pointer cursor on hover
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D0C6E), // Button color
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: clearAllFilters, // this clears filters
                        child: const Text(
                          'Clear Filters',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Refresh Data Button at bottom right
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700], // Light gray text color
                  side: BorderSide(color: Colors.grey[400]!), // Light gray border
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () {
                  // TODO: Implement refresh action
                },
                icon: const Icon(Icons.refresh), // Recycle arrows icon
                label: const Text('Refresh Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}