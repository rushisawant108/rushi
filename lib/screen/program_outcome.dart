import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProgramOutcome {
  final String id;
  String title;
  String description;
  String status;
  final String branch;
  final DateTime createdOn;
  bool isPinned;
  bool isExpanded;

  ProgramOutcome({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.branch,
    required this.createdOn,
    this.isPinned = false,
    this.isExpanded = false,
  });
}

class ProgramOutcomeScreen extends StatefulWidget {
  const ProgramOutcomeScreen({super.key});

  @override
  State<ProgramOutcomeScreen> createState() => _ProgramOutcomeScreenState();
}

class _ProgramOutcomeScreenState extends State<ProgramOutcomeScreen> {
  final List<ProgramOutcome> outcomes = [];
  String searchQuery = '';

  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _addOutcomeDialog({ProgramOutcome? existingPO}) {
    if (existingPO != null) {
      _idController.text = existingPO.id;
      _titleController.text = existingPO.title;
      _descriptionController.text = existingPO.description;
    } else {
      _idController.clear();
      _titleController.clear();
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existingPO == null ? "Add Program Outcome" : "Edit Program Outcome", style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'PO ID'),
                readOnly: existingPO != null,
              ),
              TextField(controller: _titleController, decoration: InputDecoration(labelText: 'PO Title')),
              TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'PO Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isEmpty) return;
              setState(() {
                if (existingPO != null) {
                  existingPO.title = _titleController.text;
                  existingPO.description = _descriptionController.text;
                } else {
                  outcomes.add(ProgramOutcome(
                    id: _idController.text,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    status: 'Active',
                    branch: 'Computer Engineering',
                    createdOn: DateTime.now(),
                  ));
                }
              });
              _idController.clear();
              _titleController.clear();
              _descriptionController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _exportPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: outcomes.map((po) {
              return pw.Text("${po.id}: ${po.title} - ${po.description}");
            }).toList(),
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final filteredOutcomes = outcomes.where((po) =>
    po.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        po.description.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    filteredOutcomes.sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1356),
        title: const Text("Program Outcomes", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: _exportPDF,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search by title or description',
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addOutcomeDialog(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C1356)),
              child: const Text("Add PO", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOutcomes.length,
                itemBuilder: (context, index) {
                  final po = filteredOutcomes[index];
                  return Card(
                    child: ExpansionTile(
                      initiallyExpanded: po.isExpanded,
                      onExpansionChanged: (val) => setState(() => po.isExpanded = val),
                      title: Row(
                        children: [
                          const Icon(Icons.circle, size: 10, color: Colors.green),
                          const SizedBox(width: 8),
                          Text("${po.id}: ${po.title}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            icon: Icon(po.isPinned ? Icons.push_pin : Icons.push_pin_outlined, color: Colors.orange),
                            onPressed: () => setState(() => po.isPinned = !po.isPinned),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _addOutcomeDialog(existingPO: po),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => setState(() => outcomes.remove(po)),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(po.description, style: GoogleFonts.poppins()),
                              const SizedBox(height: 8),
                              Text("Date Added: ${DateFormat('dd MMM yyyy').format(po.createdOn)}",
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
