import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_bloc.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_event.dart';
import 'package:vikas_app/bloc_management/dharmasetu/dharmasetu_state.dart';
import 'package:vikas_app/screeens/common/loader.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ViewDharmasetu extends StatefulWidget {
  const ViewDharmasetu({super.key});

  @override
  State<ViewDharmasetu> createState() => _ViewDharmasetuState();
}

class _ViewDharmasetuState extends State<ViewDharmasetu> {
  late String dharmasetuId;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is String) {
      dharmasetuId = args;
    } else {
      dharmasetuId = '';
    }
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'community':
        return Colors.purple;
      case 'home':
        return Colors.indigo;
      case 'virtual':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'wip':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dharmasetuId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<DharmasetuBloc>().add(LoadDharmasetuDetails(dharmasetuId));
      });
    }

    return Layout(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<DharmasetuBloc, DharmasetuState>(
          listener: (context, state) {
            if (state.profileErrorMsg != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.profileErrorMsg!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.profileLoading == true) {
              return const Center(child: ScreenLoader());
            }

            final data = state.selectedDharmasetuView;
            if (data == null) {
              return const Center(child: Text('No data available'));
            }

            // Build everything in a single scrollable column
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Dharmasetu Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                  //_buildHeaderCard(data),
                  //const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Dharmasetu ID', data.dharmasetuId),
                       _buildRow('Type', data.type),
                        _buildRow('Community Name', data.communityName),
                        _buildRow('Point of Contact', data.pointOfContact),
                        _buildRow('Date', data.date),
                        _buildRow('Referred By', data.referredBy),

                        if (data.address?.isNotEmpty == true)
                          _buildRow('Address', data.address!),
                        if (data.city?.isNotEmpty == true)
                          _buildRow('City', data.city!),
                        if (data.state?.isNotEmpty == true)
                          _buildRow('State', data.state!),
                        if (data.country?.isNotEmpty == true)
                          _buildRow('Country', data.country!),
                        if (data.pincode?.isNotEmpty == true)
                          _buildRow('Pincode', data.pincode!),

                        if (data.meetingLink?.isNotEmpty == true)
                          _buildRow('Meeting Link', data.meetingLink!,
                              isLink: true),

                      _buildRow('Status', data.dharmasetuStatus),

                        if (data.feedback.isNotEmpty)
                          _buildRow('Feedback', data.feedback),
                      ].whereType<Widget>().toList(), // remove nulls
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                      ),
                      const SizedBox(width: 16),
                      // OutlinedButton.icon(
                      //   onPressed: () {
                      //     // TODO: Edit navigation
                      //   },
                      //   icon: const Icon(Icons.edit),
                      //   label: const Text('Edit'),
                      //   style: OutlinedButton.styleFrom(
                      //     foregroundColor: Colors.orange,
                      //     side: const BorderSide(color: Colors.orange),
                      //   ),
                      // ),
                      // const SizedBox(width: 16),
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     // TODO: Delete with confirmation
                      //   },
                      //   icon: const Icon(Icons.delete),
                      //   label: const Text('Delete'),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.red,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Optional header card (you can keep or remove)
  Widget _buildHeaderCard(dynamic data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFF7F89C), const Color(0xFFA1924E)],
              ),
              shape: BoxShape.circle,
            ),
            
            child: Center(
              child: Text(
                data.communityName.isNotEmpty
                    ? data.communityName[0].toUpperCase()
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.communityName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _typeColor(data.type),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.type,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _statusColor(data.dharmasetuStatus),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data.dharmasetuStatus,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F89C).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              data.dharmasetuId,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFA1924E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build a row – returns null if value is empty
  Widget? _buildRow(String label, String value,
      {bool isBadge = false, Color badgeColor = Colors.grey, bool isLink = false}) {
    if (value.isEmpty) return null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isBadge
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: badgeColor),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: badgeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  )
                : isLink
                    ? GestureDetector(
                        onTap: () {
                          // Optionally launch URL
                        },
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
          ),
        ],
      ),
    );
  }
}