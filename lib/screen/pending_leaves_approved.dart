import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveRequest {
  final String collegeId;
  final String name;
  final String leaveType;
  final String department;
  final double days;
  final String reason;
  final String fromDate;
  final String toDate;
  final String status;
  final String approvedBy;

  LeaveRequest({
    required this.collegeId,
    required this.name,
    required this.leaveType,
    required this.department,
    required this.days,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.approvedBy,
  });
}

class PendingLeaveApprovalsPage extends StatefulWidget {
  const PendingLeaveApprovalsPage({super.key});

  @override
  State<PendingLeaveApprovalsPage> createState() => _PendingLeaveApprovalsPageState();
}

class _PendingLeaveApprovalsPageState extends State<PendingLeaveApprovalsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Search controller and filtered lists
  final TextEditingController _searchController = TextEditingController();
  List<LeaveRequest> filteredRequests = [];
  bool isSearchActive = false;
  bool showInvalidMessage = false;

  final List<LeaveRequest> requests = [
    LeaveRequest(
      collegeId: "1033",
      name: "JAGADALE UDAY BHAGWAN",
      leaveType: "Casual Leave",
      department: "COMPUTER ENGINEERING",
      days: 1.0,
      reason: "Personal Work",
      fromDate: "11/7/2023",
      toDate: "11/7/2023",
      approvedBy: "BORADE RAJESH ROHIDAS",
      status: "Pending",
    ),
    LeaveRequest(
      collegeId: "3012",
      name: "Mrs. PRAJAKTA KHELKAR",
      leaveType: "Medical Leave",
      department: "COMPUTER ENGINEERING",
      days: 2.0,
      reason: "Medical Treatment",
      fromDate: "18/7/2023",
      toDate: "19/7/2023",
      approvedBy: "MRS. MANJIRI KARANDIKAR",
      status: "Pending",
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredRequests = requests; // Initialize with all requests

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000)
    );
    _fadeAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();

    // Add listener to search controller
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredRequests = requests;
        isSearchActive = false;
        showInvalidMessage = false;
      } else {
        isSearchActive = true;
        filteredRequests = requests.where((request) {
          return request.name.toLowerCase().contains(query) ||
              request.collegeId.toLowerCase().contains(query) ||
              request.department.toLowerCase().contains(query);
        }).toList();

        // Show invalid message if no results found
        showInvalidMessage = filteredRequests.isEmpty;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      filteredRequests = requests;
      isSearchActive = false;
      showInvalidMessage = false;
    });
  }

  void _showInvalidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                "Invalid Search",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "No faculty found matching '${_searchController.text}'. Please check the name and try again.",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearSearch();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                "Clear Search",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2A1070),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                "OK",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2A1070),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleApproval(int index, bool isApproved) {
    final name = filteredRequests[index].name;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isApproved ? Icons.check_circle : Icons.cancel,
              color: isApproved ? Colors.green : Colors.red,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              isApproved ? "Request Approved" : "Request Denied",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Leave request for $name has been ${isApproved ? 'approved' : 'denied'} successfully.",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "OK",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2A1070),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(LeaveRequest req, int index) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2A1070).withOpacity(0.1),
                      const Color(0xFF2A1070).withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF2A1070),
                      child: Text(
                        req.name.split(' ').map((e) => e[0]).take(2).join(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "ID: ${req.collegeId} • Faculty",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.shade300, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            req.status,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Leave Details Grid
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildInfoTile(Icons.category_outlined, "Leave Type", req.leaveType)),
                              Expanded(child: _buildInfoTile(Icons.business_outlined, "Department", req.department)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildInfoTile(Icons.access_time, "Duration", "${req.days} day${req.days > 1 ? 's' : ''}")),
                              Expanded(child: _buildInfoTile(Icons.description_outlined, "Reason", req.reason)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildInfoTile(Icons.date_range_outlined, "From", req.fromDate)),
                              Expanded(child: _buildInfoTile(Icons.date_range_outlined, "To", req.toDate)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Approver Info
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person_outline, size: 16, color: Colors.blue.shade700),
                          const SizedBox(width: 6),
                          Text(
                            "Reporting to: ",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              req.approvedBy,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => handleApproval(index, false),
                            icon: const Icon(Icons.close, size: 16),
                            label: const Text("Deny"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => handleApproval(index, true),
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text("Approve"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Pending Approvals",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2A1070),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Add filter functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Add more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Clean Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A1070),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.assignment_turned_in,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Leave Requests",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${requests.length} pending approval${requests.length != 1 ? 's' : ''}",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "09 June 2025",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List with Search Bar
          Expanded(
            child: Column(
              children: [
                // Search Bar
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isSearchActive
                            ? (showInvalidMessage ? Colors.red : const Color(0xFF2A1070))
                            : Colors.grey.shade300
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                          Icons.search,
                          color: isSearchActive
                              ? (showInvalidMessage ? Colors.red : const Color(0xFF2A1070))
                              : Colors.grey[500],
                          size: 20
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search Faculty...",
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      if (isSearchActive) ...[
                        IconButton(
                          onPressed: _clearSearch,
                          icon: Icon(Icons.clear, color: Colors.grey[600], size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (showInvalidMessage)
                        GestureDetector(
                          onTap: _showInvalidDialog,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.error, color: Colors.red, size: 18),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.tune, color: Colors.grey[600], size: 18),
                        ),
                    ],
                  ),
                ),

                // Search Results Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        isSearchActive
                            ? "Search Results: ${filteredRequests.length}"
                            : "Total Requests: ${requests.length}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (isSearchActive && !showInvalidMessage) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A1070).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Searching: '${_searchController.text}'",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2A1070),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Request List
                Expanded(
                  child: showInvalidMessage
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.red[400]
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No Results Found",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "No faculty found matching '${_searchController.text}'",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _showInvalidDialog,
                          icon: const Icon(Icons.info_outline, size: 16),
                          label: const Text("Show Details"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : filteredRequests.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: Colors.grey[400]
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No pending requests",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "All leave requests have been processed",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) => buildCard(filteredRequests[index], index),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}