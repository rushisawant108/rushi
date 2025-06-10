import 'package:flutter/material.dart';

class CourseOutcomeWiseReportsScreen extends StatefulWidget {
  const CourseOutcomeWiseReportsScreen({super.key});

  @override
  State<CourseOutcomeWiseReportsScreen> createState() => _CourseOutcomeWiseReportsScreenState();
}

class _CourseOutcomeWiseReportsScreenState extends State<CourseOutcomeWiseReportsScreen> {
  String selectedAcademicYear = 'No academic years available';

  void clearFilters() {
    setState(() {
      selectedAcademicYear = 'No academic years available';
    });
  }

  void refreshData() {
    // TODO: Implement refresh logic here
    print('Refresh Data clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0C6E),
        title: const Text(
          'Course Outcome Wise Reports',
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
            // Academic Year Dropdown + Reset button on right
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Reset Search',
                        onPressed: clearFilters,
                      ),
                      const Text(
                        'Reset Search',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Empty state
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'Please select an academic year',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select an academic year to view course outcome reports.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D0C6E),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: clearFilters,
                      child: const Text('Reset Search'),
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
                  foregroundColor: Colors.grey[700],
                  side: BorderSide(color: Colors.grey[400]!),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: refreshData,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}