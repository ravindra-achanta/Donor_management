import 'package:flutter/material.dart';
import 'package:vikas_app/screeens/common/NoDataFound.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
import 'package:vikas_app/screeens/models/response/user.dart';

class CommonList<T> extends StatefulWidget {
  const CommonList({
    super.key,
    required this.currentPage,
    required this.users,
    required this.onUserTap,
    required this.onDelete,
    required this.onUpdate,
    this.screenType,
  });

  final List<T> users;
  final int currentPage;
  final String? screenType;
  final Function(String id) onUserTap;
  final Function(String id) onDelete;
  final Function(String id) onUpdate;

  @override
  State<CommonList> createState() => _CommonListState();
}

class _CommonListState extends State<CommonList> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) {
      return const NoDataState(
        title: 'No Records Found',
        subtitle: 'There is no user data available to display.',
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
          // 🟦 HEADER
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
                tableHeader('#'),
                screenType == 'DONATION'
                    ? tableHeader('Amount')
                    : tableHeader('Name'),
                screenType == 'DONATION'
                    ? tableHeader('Donation type'): screenType == 'JEEVANADI'?tableHeader('Jeevanaadi.No')
                    : tableHeader('Mobile'),
                screenType == 'DONATION'
                    ? tableHeader('Date'): screenType == 'JEEVANADI'?tableHeader('User type')
                    : tableHeader('Email'),
                screenType == 'DONATION'
                    ? SizedBox.shrink()
                    : tableHeader(
                        screenType == 'JEEVANADI'
                            ? 'Profile %'
                            : 'Actions',
                      ),
              ],
            ),
          ),

          // subtle divider
          Divider(height: 1, color: Colors.grey.shade200),

          // 🟦 LIST
          SizedBox(
            height: 460,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.users.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final rowData = widget.users[index];
                String name = "";
                String mobile = "";
                String email = "";
                String amount = "";
                String JeevanaadiNo = "";
                String userType = "";
                String profilePercent = "";
                String donationType = "";
                String date = "";
                if (rowData is JeevanaadiUser) {
                  name = rowData.userName;
                  email = rowData.email ?? "";
                  userType = rowData.userType ?? "";
                  JeevanaadiNo = rowData.id;
                  // profilePercent = rowData.profilePercent ?? "";
                }else if (rowData is User) {
                  name = rowData.name;
                  email = rowData.email;
                  mobile = rowData.mobileNumber ?? "";
                  userType = rowData.userType ?? "";
                } 
                // else if (rowData is DonationView) {
                //   amount = rowData.amount.toString();
                //   donationType = rowData.donationType ?? "";
                //   date = rowData.date ?? "";
                // }
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
                              "${ widget.currentPage * 10 + (index + 1)}",
                            ),
                            screenType == 'DONATION'
                                ? tableData(
                                    "${(index + 1 * 1000).toString()}/-",
                                  )
                                : tableData(name),
                            screenType == 'DONATION'
                                ? tableData("Seva"):screenType=="JEEVANADI"?tableData(JeevanaadiNo)
                                : tableData(mobile),
                            screenType == 'DONATION'
                                ? tableData("2025-01-${index + 1}"):screenType=="JEEVANADI"?tableData(userType)
                                : tableData(email),
                            // 🟢 Status Pill
                            // SizedBox(
                            //   width: 120,
                            //   child: _StatusPill(status: user.status),
                            // ),
                            screenType == 'JEEVANADI'
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: LinearProgressIndicator(
                                              value:
                                                  index * 20 / 100, // 0.0 - 1.0
                                              minHeight: 16,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                              valueColor: index * 20 < 30
                                                  ? AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.redAccent)
                                                  : index * 20 < 60
                                                  ? AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.blue)
                                                  : AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.green),
                                            ),
                                          ),
                                          Text(
                                            "${index * 20 / 100 * 100}%",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : screenType == 'DONATION'
                                ? SizedBox.shrink()
                                : Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        HoverIconButton(
                                          icon: Icons.delete_outline,
                                          hoverColor: Colors.red.withOpacity(
                                            0.1,
                                          ),
                                          iconColor: Colors.red,
                                          onTap: () {
                                            widget.onDelete(rowData.id);
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        HoverIconButton(
                                          icon: Icons.edit_outlined,
                                          hoverColor: Colors.blue.withOpacity(
                                            0.1,
                                          ),
                                          iconColor: Colors.blue,
                                          onTap: () {
                                            widget.onUpdate(rowData.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
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

  tableHeader(String title) {
    return Expanded(
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

  tableData(String data) {
    return Expanded(
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
