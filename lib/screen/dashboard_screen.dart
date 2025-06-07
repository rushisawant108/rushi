import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import 'daily_attendance_screen.dart';
import 'gender_chart_screen.dart';
import 'calendar_screen.dart';
import '../widgets/custom_sidebar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 24.0;
    final cardWidth = screenWidth - 2 * horizontalPadding;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      drawer: const CustomSidebar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF22066A), Color(0xFF3B1B9D)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        tooltip: 'Open navigation menu',
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.school, color: Colors.white, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Academate',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF22066A), Color(0xFF3B1B9D)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'HOD',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '07 June 2025',
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAnimatedCard(
                      context,
                      delayMs: 100,
                      title: 'Daily Attendance',
                      subtitle: '41 Total Faculty\nPresent: 0 | Leave: 0 | Absent: 41',
                      icon: Icons.groups_rounded,
                      color: Colors.pink.shade600,
                      width: cardWidth,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DailyAttendanceScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedCard(
                      context,
                      delayMs: 200,
                      title: 'Leave Applications',
                      subtitle: '785 Pending Approvals',
                      icon: Icons.assignment_turned_in_rounded,
                      color: Colors.orange.shade700,
                      width: cardWidth,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedCard(
                      context,
                      delayMs: 300,
                      title: 'Total Faculty',
                      subtitle: '41 Faculty Members',
                      icon: Icons.school_rounded,
                      color: Colors.teal.shade700,
                      width: cardWidth,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedCard(
                      context,
                      delayMs: 400,
                      title: 'Total Students',
                      subtitle: '0 Students',
                      icon: Icons.person_outline_rounded,
                      color: Colors.deepPurple.shade600,
                      width: cardWidth,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(
      BuildContext context, {
        required int delayMs,
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required double width,
        required VoidCallback onTap,
      }) {
    return FadeInDown(
      delay: Duration(milliseconds: delayMs),
      child: _buildCard(context, title, subtitle, icon, color, width, onTap),
    );
  }

  Widget _buildCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      double width,
      VoidCallback onTap,
      ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: color.withOpacity(0.15),
        highlightColor: color.withOpacity(0.1),
        child: Container(
          width: width,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: color, width: 6),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 34, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 1,
                      width: 60,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey[400],
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
