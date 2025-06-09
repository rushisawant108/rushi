import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApprovedLeave {
  final int srNo;
  final String collegeId;
  final String facultyName;
  final String post;
  final String leaveType;
  final double noOfDays;
  final String reason;
  final String fromDate;
  final String toDate;
  final String proof;
  final bool chargeTaken;
  final String signedByHOD;
  final String status;
  final DateTime approvedDate;

  ApprovedLeave({
    required this.srNo,
    required this.collegeId,
    required this.facultyName,
    required this.post,
    required this.leaveType,
    required this.noOfDays,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.proof,
    required this.chargeTaken,
    required this.signedByHOD,
    required this.status,
    required this.approvedDate,
  });
}

class ApprovalLeavePage extends StatefulWidget {
  const ApprovalLeavePage({super.key});

  @override
  State<ApprovalLeavePage> createState() => _ApprovalLeavePageState();
}

class _ApprovalLeavePageState extends State<ApprovalLeavePage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  List<ApprovedLeave> approvedLeaves = [];
  List<ApprovedLeave> filteredLeaves = [];
  bool isSearchActive = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Purple Color Palette
  static const primaryColor = Color(0xFF2A1070);
  static const secondaryColor = Color(0xFF1E0A4F);
  static const accentColor = Color(0xFF3D1A8F);
  static const successColor = Color(0xFF059669);
  static const warningColor = Color(0xFFF59E0B);
  static const backgroundColor = Color(0xFFF8FAFC);
  static const cardColor = Colors.white;
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _loadApprovedLeaves();
    _searchController.addListener(_onSearchChanged);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  void _loadApprovedLeaves() {
    approvedLeaves = [
      ApprovedLeave(
        srNo: 1,
        collegeId: "1033",
        facultyName: "JAGADALE UDAY BHAGWAN",
        post: "Assistant Professor",
        leaveType: "Casual Leave",
        noOfDays: 1.0,
        reason: "Personal Work",
        fromDate: "11/7/2023",
        toDate: "11/7/2023",
        proof: "Medical Certificate",
        chargeTaken: true,
        signedByHOD: "BORADE RAJESH ROHIDAS",
        status: "Approved",
        approvedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ApprovedLeave(
        srNo: 2,
        collegeId: "3012",
        facultyName: "Mrs. PRAJAKTA KHELKAR",
        post: "Associate Professor",
        leaveType: "Medical Leave",
        noOfDays: 2.0,
        reason: "Medical Treatment",
        fromDate: "18/7/2023",
        toDate: "19/7/2023",
        proof: "Doctor's Prescription",
        chargeTaken: true,
        signedByHOD: "MRS. MANJIRI KARANDIKAR",
        status: "Approved",
        approvedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ApprovedLeave(
        srNo: 3,
        collegeId: "2045",
        facultyName: "DR. RAJESH KUMAR",
        post: "Professor",
        leaveType: "Casual Leave",
        noOfDays: 0.5,
        reason: "Family Function",
        fromDate: "20/7/2023",
        toDate: "20/7/2023",
        proof: "Self Declaration",
        chargeTaken: false,
        signedByHOD: "DR. SURESH PATIL",
        status: "Approved",
        approvedDate: DateTime.now(),
      ),
    ];

    filteredLeaves = approvedLeaves;
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredLeaves = approvedLeaves;
        isSearchActive = false;
      } else {
        isSearchActive = true;
        filteredLeaves = approvedLeaves.where((leave) {
          return leave.facultyName.toLowerCase().contains(query) ||
              leave.collegeId.toLowerCase().contains(query) ||
              leave.leaveType.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      filteredLeaves = approvedLeaves;
      isSearchActive = false;
    });
  }

  void _viewLeaveDetails(ApprovedLeave leave) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: successColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Leave Details",
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          Text(
                            "Approved Application",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: textSecondary),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildDetailSection(
                        "Personal Information",
                        Icons.person_outline,
                        [
                          _buildDetailRow("Faculty Name", leave.facultyName),
                          _buildDetailRow("College ID", leave.collegeId),
                          _buildDetailRow("Position", leave.post),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDetailSection(
                        "Leave Information",
                        Icons.calendar_today_outlined,
                        [
                          _buildDetailRow("Leave Type", leave.leaveType),
                          _buildDetailRow("Duration", "${leave.noOfDays} day${leave.noOfDays > 1 ? 's' : ''}"),
                          _buildDetailRow("Reason", leave.reason),
                          _buildDetailRow("From Date", leave.fromDate),
                          _buildDetailRow("To Date", leave.toDate),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDetailSection(
                        "Administrative Details",
                        Icons.admin_panel_settings_outlined,
                        [
                          _buildDetailRow("Proof Submitted", leave.proof),
                          _buildDetailRow("Charge Taken", leave.chargeTaken ? "Yes" : "No"),
                          _buildDetailRow("Approved By", leave.signedByHOD),
                          _buildStatusRow("Status", leave.status),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$label:",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$label:",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textSecondary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: successColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Compact Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  secondaryColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(40, 40),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Approved Leaves",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${filteredLeaves.length}",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search_outlined, color: textSecondary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search faculty, ID, or leave type...",
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: textSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
                    ),
                  ),
                  if (isSearchActive)
                    IconButton(
                      onPressed: _clearSearch,
                      icon: Icon(Icons.clear, color: textSecondary, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Leave Cards Section
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: filteredLeaves.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredLeaves.length,
                itemBuilder: (context, index) {
                  final leave = filteredLeaves[index];
                  return _buildModernLeaveCard(leave, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isSearchActive ? "No results found" : "No approved leaves",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearchActive
                ? "Try different search terms"
                : "Approved applications will appear here",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernLeaveCard(ApprovedLeave leave, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with faculty info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      leave.facultyName.split(' ').map((e) => e[0]).take(2).join(),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
                        leave.facultyName,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${leave.post} • ID: ${leave.collegeId}",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: successColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Approved",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Leave details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        Icons.category_outlined,
                        leave.leaveType,
                        primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoChip(
                        Icons.access_time_outlined,
                        "${leave.noOfDays} day${leave.noOfDays > 1 ? 's' : ''}",
                        warningColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.date_range_outlined,
                  "Duration",
                  "${leave.fromDate} - ${leave.toDate}",
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.description_outlined,
                  "Reason",
                  leave.reason,
                ),
                const SizedBox(height: 20),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _viewLeaveDetails(leave),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: Text(
                      "View Details",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: textSecondary, size: 16),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}