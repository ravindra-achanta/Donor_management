import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/visits/visit_bloc.dart';
import 'package:vikas_app/bloc_management/visits/visit_event.dart';
import 'package:vikas_app/bloc_management/visits/visit_state.dart';
import 'package:vikas_app/screeens/common/ErrorText.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/screeens/models/request/visit_model.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ViewVisit extends StatefulWidget {
  final VisitModel? visitData;

  const ViewVisit({super.key, this.visitData});

  @override
  State<ViewVisit> createState() => _ViewVisitState();
}

class _ViewVisitState extends State<ViewVisit> {
  late VisitModel visit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final args = Get.arguments;

    if (args != null && args is VisitModel) {
      visit = args;
    } else if (args != null && args is Map) {
      visit = VisitModel(
        id: args['id'] ?? '',
        jeevandNum: args['jeevandNum'] ?? 'N/A',
        name: args['name'] ?? 'Unknown',
        phone: args['phone'] ?? 'N/A',
        email: args['email'] ?? 'N/A',
        visitPurpose: args['visitPurpose'] ?? 'N/A',
        noOfGuests: args['noOfGuests'] ?? 0,
        comments: args['comments'] ?? '',
        date: args['date'] ?? 'N/A',
        status: args['status'] ?? 'Pending',
      );
    } else if (widget.visitData != null) {
      visit = widget.visitData!;
    } else {
      visit = VisitModel(
        id: '',
        jeevandNum: 'N/A',
        name: 'Unknown',
        phone: 'N/A',
        email: 'N/A',
        visitPurpose: 'N/A',
        noOfGuests: 0,
        comments: '',
        date: 'N/A',
        status: 'Pending',
      );
    }
  }

  String _getValue(String value, [String defaultValue = 'N/A']) {
    return value.isNotEmpty ? value : defaultValue;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'scheduled':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusChip(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Visit',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete the visit record for "${visit.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isLoading = true);

                context.read<VisitBloc>().add(DeleteVisit(visit.id));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleting visit for ${visit.name}...'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );

                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    Get.offNamed('/visits');
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<VisitBloc, VisitState>(
          listener: (context, state) {
            if (state is VisitOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } else if (state is VisitError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              setState(() => _isLoading = false);
            }
          },
          builder: (context, state) {
            return _isLoading
                ? const Center(child: ScreenLoader())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Avatar with gradient border
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.blue.shade700,
                                      Colors.blue.shade500,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    visit.name.isNotEmpty
                                        ? visit.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      visit.name,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(
                                              visit.status,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            visit.status,
                                            style: TextStyle(
                                              color: _getStatusColor(
                                                visit.status,
                                              ),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'ID: ${visit.jeevandNum}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 11,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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

                        const SizedBox(height: 20),

                        /// Member Information Card
                        _buildInfoCard('Member Information', [
                          _buildInfoRow(
                            'Jeevandi Number',
                            visit.jeevandNum,
                            icon: Icons.confirmation_number,
                          ),
                          _buildInfoRow('Name', visit.name, icon: Icons.person),
                          _buildInfoRow(
                            'Phone',
                            visit.phone,
                            icon: Icons.phone,
                          ),
                          _buildInfoRow(
                            'Email',
                            visit.email,
                            icon: Icons.email,
                          ),
                        ]),

                        /// Visit Information Card
                        _buildInfoCard('Visit Information', [
                          _buildInfoRow(
                            'Visit Purpose',
                            visit.visitPurpose,
                            icon: Icons.flag,
                          ),
                          _buildInfoRow(
                            'Number of Guests',
                            '${visit.noOfGuests} ${visit.noOfGuests == 1 ? 'Guest' : 'Guests'}',
                            icon: Icons.group,
                          ),
                          _buildInfoRow(
                            'Date',
                            visit.date,
                            icon: Icons.calendar_today,
                          ),
                          _buildInfoRow(
                            'Status',
                            visit.status,
                            icon: Icons.info,
                          ),
                        ]),

                        /// Comments Card
                        if (visit.comments.isNotEmpty)
                          _buildInfoCard('Additional Comments', [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                visit.comments,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ]),

                        const SizedBox(height: 20),

                        /// Action Buttons - Compact Design
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSmallActionButton(
                                icon: Icons.arrow_back,
                                label: 'Back',
                                color: Colors.grey.shade600,
                                onPressed: () => Get.back(),
                              ),
                              _buildSmallDivider(),
                              _buildSmallActionButton(
                                icon: Icons.edit,
                                label: 'Edit',
                                color: Colors.orange,
                                onPressed: () => Get.toNamed(
                                  '/edit/visit',
                                  arguments: visit,
                                ),
                              ),
                              _buildSmallDivider(),
                              _buildSmallActionButton(
                                icon: Icons.delete,
                                label: 'Delete',
                                color: Colors.red,
                                onPressed: _showDeleteDialog,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildSmallActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallDivider() {
    return Container(height: 20, width: 1, color: Colors.grey.shade300);
  }
}
