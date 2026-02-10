import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/screeens/common/add_button.dart';
import 'package:vikas_app/screeens/common/deletion_popup.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ReviewRequests extends StatefulWidget {
  const ReviewRequests({super.key});

  @override
  State<ReviewRequests> createState() => _ReviewRequestsState();
}

class _ReviewRequestsState extends State<ReviewRequests> {
  final List<Map<String, dynamic>> requests = [
    {"name": "Ravi Kumar", "type": "Updated by Ravi", "status": "Pending"},
    {"name": "Sita Devi", "type": "Updated by Jeewan", "status": "Approved"},
    {"name": "Mahesh", "type": "Updated by sruthi", "status": "Pending"},
    {"name": "Anita", "type": "Updated by kalyan", "status": "Rejected"},
    {"name": "Rajesh", "type": "Updated by sindhu", "status": "Pending"},
    {"name": "Kiran", "type": "Updated by pavan", "status": "Approved"},
    // {"name": "Kiran", "type": "Education Support", "status": "Approved"},
    {"name": "Sita Devi", "type": "Updated by Jeewan", "status": "Approved"},
    {"name": "Mahesh", "type": "Updated by sruthi", "status": "Pending"},
    {"name": "Anita", "type": "Updated by kalyan", "status": "Rejected"},
    {"name": "Rajesh", "type": "Updated by sindhu", "status": "Pending"},
    {"name": "Kiran", "type": "Updated by pavan", "status": "Approved"},
  ];

  final List<Map<String, dynamic>> newRequests = [
    {"name": "Ravi Kumar", "type": "Updated by Ravi", "status": "Pending"},
    {"name": "Sita Devi", "type": "Updated by Jeewan", "status": "Approved"},
    {"name": "Mahesh", "type": "Updated by sruthi", "status": "Pending"},
    {"name": "Anita", "type": "Updated by kalyan", "status": "Rejected"},
    {"name": "Rajesh", "type": "Updated by sindhu", "status": "Pending"},
    {"name": "Kiran", "type": "Updated by pavan", "status": "Approved"},
    // {"name": "Kiran", "type": "Education Support", "status": "Approved"},
    {"name": "Sita Devi", "type": "Updated by Jeewan", "status": "Approved"},
    {"name": "Mahesh", "type": "Updated by sruthi", "status": "Pending"},
    {"name": "Anita", "type": "Updated by kalyan", "status": "Rejected"},
    {"name": "Rajesh", "type": "Updated by sindhu", "status": "Pending"},
    {"name": "Kiran", "type": "Updated by pavan", "status": "Approved"},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadMoreRequests() {
    setState(() {
      requests.addAll(newRequests);
    });
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 800) {
      return 2; // small screen
    } else {
      return 3; // large screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "All Review Requests",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 500,
              child: GridView.builder(
                itemCount: requests.length + 1, // +1 for Load More
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.6,
                ),
                itemBuilder: (context, index) {
                  // If last item → show Load More button
                  if (index == requests.length) {
                    return Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: loadMoreRequests,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4F46E5),
                                Color(0xFF6366F1),
                              ], // indigo
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Load More",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final item = requests[index];
                  return _AnimatedRequestCard(
                    index: index,
                    name: item["name"],
                    type: item["type"],
                    status: item["status"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedRequestCard extends StatefulWidget {
  final int index;
  final String name;
  final String type;
  final String status;

  const _AnimatedRequestCard({
    required this.index,
    required this.name,
    required this.type,
    required this.status,
  });

  @override
  State<_AnimatedRequestCard> createState() => _AnimatedRequestCardState();
}

class _AnimatedRequestCardState extends State<_AnimatedRequestCard> {
  bool _hovered = false;

  Color getStatusColor() {
    switch (widget.status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Widget _buildCard() {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 480),
        margin: const EdgeInsets.all(2), // ensures layout
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: _hovered ? Colors.black26 : Colors.black12,
              blurRadius: _hovered ? 18 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.assignment, color: Colors.blue.shade700),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusPill(text: widget.status, color: getStatusColor()),
                ],
              ),
              Spacer(),
              Text(
                "Profile updation by all karyakartas",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              Text(
                widget.type,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ApprovePopup.showApproveConfirmation(
                          context: context,
                          title: "Approve?",
                          message:
                              "Are you sure you want to Approve this request?",
                          buttonText: "Approve",
                          onConfirm: () {},
                        );
                      },
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text("Approve"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.toNamed('/jeevandiview');
                      },
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                      label: const Text("View"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusPill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
