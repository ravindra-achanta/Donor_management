import 'package:flutter/material.dart';
import 'package:vikas_app/screeens/common/NoDataFound.dart';

class CommonList extends StatefulWidget {
  const CommonList({
    super.key,
    required this.users,
    required this.onUserTap,
    required this.onDelete,
    required this.onUpdate,
  });

  final List users;
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
                tableHeader('Name'),
                tableHeader('Mobile'),
                tableHeader('Email'),
                tableHeader('Actions'),
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
                final user = widget.users[index];
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
                      onTap: () => widget.onUserTap(user.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            tableData("${(index + 1).toString()}."),
                            tableData(user.name ?? "-"),
                            tableData(user.mobileNumber ?? "-"),
                            tableData(user.email ?? "-"),
                            // 🟢 Status Pill
                            // SizedBox(
                            //   width: 120,
                            //   child: _StatusPill(status: user.status),
                            // ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  HoverIconButton(
                                    icon: Icons.delete_outline,
                                    hoverColor: Colors.red.withOpacity(0.1),
                                    iconColor: Colors.red,
                                    onTap: () {
                                      // delete logic
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  HoverIconButton(
                                    icon: Icons.edit_outlined,
                                    hoverColor: Colors.blue.withOpacity(0.1),
                                    iconColor: Colors.blue,
                                    onTap: () {
                                      // edit logic
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
          fontSize: 13,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  tableData(String data) {
    return Expanded(
      child: Text(
        data,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13.5, color: Colors.grey.shade700),
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
