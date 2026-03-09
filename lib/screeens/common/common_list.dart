import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:vikas_app/screeens/common/NoDataFound.dart';
import 'package:vikas_app/screeens/models/response/donations.dart';
import 'package:vikas_app/screeens/models/response/donations_pagination.dart';
import 'package:vikas_app/screeens/models/response/Dharmasetu_view.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/screeens/models/response/review_request.dart';
import 'package:vikas_app/screeens/models/response/visit_view.dart';

class CommonList<T> extends StatefulWidget {
  const CommonList({
    super.key,
    required this.currentPage,
    required this.users,
    required this.onUserTap,
    required this.onDelete,
    required this.onUpdate,
    this.screenType,
    this.onApprove,
  });

  final List<T> users;
  final int currentPage;
  final String? screenType;
  final Function(String id) onUserTap;
  final Function(String id) onDelete;
  final Function(String id) onUpdate;
  final Function(String id)? onApprove;

  @override
  State<CommonList> createState() => _CommonListState();
}

class _CommonListState extends State<CommonList> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) {
      return NoDataState(
        title: widget.screenType == 'DONATION'
            ? 'No Donations Found'
            : 'No Records Found',
        subtitle: 'There is no data available to display.',
      );
    }
    String screenType = widget.screenType ?? "";

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                //tableHeader('#'),
                tableHeader('#', flex: 1),
                if (screenType == 'JEEVANADI') ...[
                  tableHeader('fullName'),
                  tableHeader('Jeevanaadi No'),
                  tableHeader('Profile %'),
                ] else if (screenType == 'REVIEW_REQUEST') ...[
                  tableHeader('Jeevanadi Name', flex: 4),
                  tableHeader('Jeevanadi no', flex: 2),
                  tableHeader('Updated By', flex: 2),
                  tableHeader('Status', flex: 1),
                  //tableHeader('Actions', flex: 2),
                ] else if (screenType == 'DHARMASETU') ...[
                  //tableHeader('UID'),
                  // tableHeader('S.No', flex: 1),
                  //tableHeader('Type', flex: 1),
                  tableHeader('Community Name', flex: 2),
                  tableHeader('POC', flex: 1),
                  //tableHeader('Feedback', flex: 2),
                  tableHeader('Date', flex: 1),
                  tableHeader('Referred By', flex: 1),
                  tableHeader('Status', flex: 1),
                  tableHeader('Actions', flex: 2),
                ] else if (screenType == 'VISIT') ...[
                  //tableHeader('ID', flex: 1),
                  tableHeader('Visitor Name', flex: 2),
                  tableHeader('Phone Number', flex: 2),
                  //tableHeader('Visit Purpose', flex: 2),
                  tableHeader('No. of Guests', flex: 1),
                  // Actions column (optional - you can keep or remove)
                  tableHeader('Actions', flex: 1),
                ] else if (screenType == 'DONATION') ...[
                  tableHeader('Amount'),
                  tableHeader('Donation type'),
                  tableHeader('Donation date'),
                  const SizedBox.shrink(),
                ] else ...[
                  tableHeader('Name'),
                  tableHeader('Mobile'),
                  tableHeader('Role'),
                  tableHeader('Actions'),
                ],
              ],
            ),
          ),

          // subtle divider
          Divider(height: 1, color: Colors.grey.shade200),

          SizedBox(
            height: 460,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.users.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final rowData = widget.users[index];
                String name = "-";
                String mobile = "";
                String email = "";
                String amount = "";
                String JeevanaadiNo = "";
                String userType = "";
                double profilePercent = 0.0;
                String donationType = "";
                String date = "";

                // Data extraction for different types
                if (rowData is JeevanaadiUser) {
                  name = rowData.fullName;
                  JeevanaadiNo = rowData.jeevanaadiNo ?? rowData.id;
                  profilePercent = rowData.profileCompletionPercentage ?? 0.0;
                } else if (rowData is User) {
                  name = rowData.name;
                  email = rowData.email;
                  mobile = rowData.mobileNumber ?? "";
                  userType = rowData.userType ?? "";
                } else if (rowData is DonationEvent) {
                  amount = rowData.amount.toString();
                  donationType = rowData.eventType;
                  date = formatDate(rowData.date.toString());
                }

                final isHovered = hoveredIndex == index;

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => hoveredIndex = index),
                  onExit: (_) => setState(() => hoveredIndex = null),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    color: isHovered
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.06)
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onUserTap(rowData.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            tableData(
                              "${widget.currentPage * 10 + (index + 1)}",
                            ),

                            if (screenType == 'JEEVANADI') ...[
                              tableData(name, flex: 3),
                              tableData(JeevanaadiNo, flex: 2),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: _buildProfileProgress(profilePercent),
                                ),
                              ),
                            ] else if (screenType == 'REVIEW_REQUEST') ...[
                              if (rowData is ReviewRequest) ...[
                                tableData(rowData.jeevnadiName, flex: 4),
                                tableData(rowData.jeevanadiNo, flex: 2),
                                tableData(rowData.updatedBy, flex: 2),
                                Expanded(
                                  flex: 1,
                                  child: _buildStatusPill(
                                    rowData.status ?? 'Pending',
                                  ),
                                ),
                              ] else ...[
                                tableData('', flex: 3),
                                tableData('', flex: 2),
                                tableData('', flex: 2),
                                const Expanded(
                                  flex: 1,
                                  child: SizedBox.shrink(),
                                ),
                                const Expanded(
                                  flex: 2,
                                  child: SizedBox.shrink(),
                                ),
                              ],
                            ] else if (screenType == 'DHARMASETU') ...[
                              if (rowData is DharmasetuView) ...[
                                // tableData(
                                //   (widget.currentPage * 10 + (index + 1))
                                //       .toString(),
                                //   flex: 1,
                                // ),
                                //tableData(rowData.type, flex: 1),
                                tableData(rowData.communityName, flex: 2),
                                tableData(rowData.pointOfContact, flex: 1),
                                // tableData(rowData.feedback, flex: 2),
                                tableData(rowData.date, flex: 1),
                                tableData(rowData.referredBy, flex: 1),
                                Expanded(
                                  flex: 1,
                                  child: _buildStatusPill(
                                    rowData.dharmasetuStatus,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _actionIcon(
                                        Icons.visibility_outlined,
                                        Colors.blue,
                                        () {
                                          Get.toNamed(
                                            '/view/dharmasetu',
                                            arguments: rowData,
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                      _actionIcon(
                                        Icons.edit_outlined,
                                        Colors.orange,
                                        () => widget.onUpdate(rowData.id),
                                      ),
                                      const SizedBox(width: 5),
                                      _actionIcon(
                                        Icons.delete_outline,
                                        Colors.red,
                                        () => widget.onDelete(rowData.id),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ] else if (screenType == 'VISIT') ...[
                              if (rowData is VisitView) ...[
                                tableData(rowData.visitorName, flex: 2),
                                tableData(rowData.phoneNumber, flex: 2),

                                tableData(
                                  rowData.noOfGuests.toString(),
                                  flex: 1,
                                ),
                                //tableHeader('Existing', flex: 1),
                                //tableData(rowData.existing.toString(), flex: 1),
                                // Expanded(
                                //   child: _buildStatusPill(rowData.status),
                                // ),
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // _actionIcon(
                                      //   Icons.visibility_outlined,
                                      //   Colors.blue,
                                      //   () => Get.toNamed(
                                      //     '/view/visit',
                                      //     arguments: rowData,
                                      //   ),
                                      // ),
                                      _actionIcon(
                                        Icons.edit_outlined,
                                        Colors.orange,
                                        () => widget.onUpdate(rowData.id),
                                      ),
                                      const SizedBox(width: 5),
                                      _actionIcon(
                                        Icons.delete_outline,
                                        Colors.red,
                                        () => widget.onDelete(rowData.id),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ] else if (screenType == 'DONATION') ...[
                              tableData(amount),
                              tableData(donationType),
                              tableData(date),
                              const SizedBox.shrink(),
                            ] else ...[
                              // Default case (User)
                              tableData(name),
                              tableData(mobile),
                              tableData(userType),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    HoverIconButton(
                                      icon: Icons.delete_outline,
                                      hoverColor: Colors.red.withOpacity(0.1),
                                      iconColor: Colors.red,
                                      onTap: () => widget.onDelete(rowData.id),
                                    ),
                                    const SizedBox(width: 10),
                                    HoverIconButton(
                                      icon: Icons.edit_outlined,
                                      hoverColor: Colors.blue.withOpacity(0.1),
                                      iconColor: Colors.blue,
                                      onTap: () => widget.onUpdate(rowData.id),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MMM-yyyy').format(parsedDate);
  }

  Widget _buildProfileProgress(double percentage) {
    Color progressColor = _getProgressColor(percentage);

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 16,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        Text(
          "${percentage.toStringAsFixed(1)}%",
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage < 30) return Colors.redAccent;
    if (percentage < 60) return Colors.orange;
    if (percentage < 80) return Colors.blue;
    return Colors.green;
  }

  Widget _buildStatusPill(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget tableHeader(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget tableData(String data, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        data,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return HoverIconButton(
      icon: icon,
      hoverColor: color.withOpacity(0.1),
      iconColor: color,
      onTap: onTap,
    );
  }
}

class HoverIconButton extends StatefulWidget {
  const HoverIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.hoverColor = const Color(0xFFE3F2FD), // light blue
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color hoverColor;
  final Color? iconColor;

  @override
  State<HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _hovering ? widget.hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: widget.iconColor ?? Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
