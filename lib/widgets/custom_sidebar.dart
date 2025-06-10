import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/my_faculty_screen.dart';
import '../screen/student.dart';
import '../screen/mentor_assign.dart';
import '../screen/mentor_mentee_list_page.dart';
import '../screen/pending_leaves_approved.dart';
import '../screen/approval_leave.dart';
import '../screen/assign_course_screen.dart';
import '../screen/program_outcome.dart';
import '../screen/course_assignment_screen.dart'; // Import for CourseAssignmentScreen
import '../screen/faculty.dart'; // Import for FacultyWiseReportsScreen

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({super.key});

  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  final Map<String, bool> _expandedSections = {};

  Widget sectionHeader(String title) {
    final isExpanded = _expandedSections[title] ?? false;

    return InkWell(
      onTap: () {
        setState(() {
          _expandedSections[title] = !isExpanded;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2639),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget navItem(String title, IconData icon, VoidCallback onTap, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: isSelected ? const Color(0xFF1E324A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: Colors.white70, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13.5,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List<Widget> children) {
    final isExpanded = _expandedSections[title] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(title),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(children: children),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D1B2A),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Dashboard',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white24, height: 1, thickness: 0.5),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: [
                  buildSection('My Department', [
                    navItem('My Faculty', Icons.people_outline, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MyFacultyScreen()));
                    }),
                    navItem('My Students', Icons.school_outlined, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentScreen()));
                    }),
                    navItem('Mentor Assign', Icons.assignment_ind_outlined, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorAssignScreen()));
                    }),
                    navItem('Mentor Mentee List', Icons.list_alt_outlined, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MentorMenteeListPage()));
                    }),
                  ]),
                  buildSection('Course Management', [
                    navItem('Assign Course', Icons.bookmark_border, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AssignCourseScreen()));
                    }),
                    navItem('Course Assignments', Icons.assignment_outlined, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseAssignmentScreen()));
                    }),
                    navItem('Program Outcomes', Icons.checklist_outlined, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgramOutcomeScreen()));
                    }),
                  ]),
                  buildSection('Leaves', [
                    navItem('Approved Leaves', Icons.thumb_up_alt_outlined, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ApprovalLeavePage()));
                    }),
                    navItem('Pending Leave Approvals', Icons.pending_actions, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingLeaveApprovalsPage()));
                    }),
                  ]),
                  buildSection('No Dues', [
                    navItem('UnSigned No Dues', Icons.remove_circle_outline, () {}),
                    navItem('Remarked No Dues', Icons.edit_note_outlined, () {}),
                    navItem('Signed No Dues', Icons.verified_outlined, () {}),
                  ]),
                  buildSection('Reports', [
                    navItem('Faculty Wise Reports', Icons.bar_chart, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FacultyWiseReportsScreen()));
                    }),
                    navItem('Course Outcome Wise Reports', Icons.timeline_outlined, () {}),
                    navItem('Course Wise Reports', Icons.insert_chart_outlined, () {}),
                    navItem('Semester Wise Reports', Icons.date_range_outlined, () {}),
                    navItem('Set Target Reports', Icons.flag_outlined, () {}),
                  ]),
                  buildSection('Budget Request', [
                    navItem('Expense Request', Icons.attach_money_outlined, () {}),
                    navItem('Post Request', Icons.send_outlined, () {}),
                  ]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add logout logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  minimumSize: const Size(double.infinity, 48),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}