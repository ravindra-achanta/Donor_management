import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/styles/text_style.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_bloc.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_event.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_state.dart';
import 'package:vikas_app/screeens/common/backButton.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class KaryaKarthaViewScreen extends StatefulWidget {
  final String? karyakarthaId; // optional preselected ID

  const KaryaKarthaViewScreen({super.key, this.karyakarthaId});

  @override
  State<KaryaKarthaViewScreen> createState() => _KaryaKarthaViewScreenState();
}

class _KaryaKarthaViewScreenState extends State<KaryaKarthaViewScreen>
    with SingleTickerProviderStateMixin {
  int _unassignedPage = 0;
  int _assignedPage = 0;
  late TabController _tabController;
  String? _selectedKaryakarthaId;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _assignedSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadKaryakarthaList();
    if (widget.karyakarthaId != null) {
      _selectedKaryakarthaId = widget.karyakarthaId;
      _loadDataForSelected();
    }
  }

  void _loadKaryakarthaList() {
    context.read<KaryakarthaBloc>().add(FetchKaryakattasEvent(0));
  }

  void _loadDataForSelected() {
    if (_selectedKaryakarthaId == null) return;
    setState(() {
      _assignedPage = 0;
      _unassignedPage = 0;
    });
    _searchController.clear();
    context.read<JeevanaadiBloc>().add(
      FetchAssignedKaryakarthasEvent(
        _selectedKaryakarthaId!,
        _assignedPage,
        10,
      ),
    );
    context.read<JeevanaadiBloc>().add(FetchUnassignedKaryakarthasEvent(0));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _assignedSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Backbutton().buildBackButton(context, ""),
                  const SizedBox(width: 16),
                  const Text(
                    "Karyakartha Panel",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 600,
                child: Row(
                  children: [
                    Expanded(flex: 4, child: _buildKaryakarthaListPanel()),
                    const SizedBox(width: 30),
                    Expanded(flex: 6, child: _buildRightPanel()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== LEFT PANEL: Karyakartha list ====================
  Widget _buildKaryakarthaListPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BlocBuilder<KaryakarthaBloc, KaryakarthaState?>(
        builder: (context, state) {
          if (state == null || state.status == KaryakattaApiStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == KaryakattaApiStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    state.errorMessage ?? "Error loading karyakarthas",
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _loadKaryakarthaList(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }
          if (state.status == KaryakattaApiStatus.loaded) {
            final users = state.karyakarthas ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "All Karyakarthas :",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text('${state.totalElements}'),
                            avatar: const Icon(Icons.people, size: 18),
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final isSelected =
                                  user.id == _selectedKaryakarthaId;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedKaryakarthaId = user.id;
                                  });
                                  _loadDataForSelected();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue.shade50
                                        : Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: isSelected
                                            ? Colors.blue.shade200
                                            : Colors.grey.shade300,
                                        child: Text(
                                          user.name.isNotEmpty
                                              ? user.name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              user.mobileNumber ?? 'No mobile',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.blue.shade600,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (state.totalpages > 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: state.currentPage > 0
                                      ? () {
                                          context.read<KaryakarthaBloc>().add(
                                            FetchKaryakattasEvent(
                                              state.currentPage - 1,
                                            ),
                                          );
                                        }
                                      : null,
                                  icon: const Icon(
                                    Icons.skip_previous_outlined,
                                  ),
                                ),
                                Text(
                                  "${state.currentPage + 1}/${state.totalpages}",
                                ),
                                IconButton(
                                  onPressed:
                                      state.currentPage < state.totalpages - 1
                                      ? () {
                                          context.read<KaryakarthaBloc>().add(
                                            FetchKaryakattasEvent(
                                              state.currentPage + 1,
                                            ),
                                          );
                                        }
                                      : null,
                                  icon: const Icon(Icons.skip_next_outlined),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ==================== RIGHT PANEL: Tabs only ====================
  Widget _buildRightPanel() {
    if (_selectedKaryakarthaId == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                "Select a karyakartha from the left to view members",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return BlocListener<JeevanaadiBloc, JeevanaadiState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: FxText.labelMedium(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<JeevanaadiBloc, JeevanaadiState>(
        builder: (context, state) {
          if (state.status == JeevanaadiApiStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == JeevanaadiApiStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    state.errorMessage ?? "Error loading data",
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "For Deallocate"),
                    Tab(text: "For Allocate"),
                  ],
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAssignedTabContent(state),
                      _buildUnassignedTabContent(state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ========== Assigned Tab ==========
  Widget _buildAssignedTabContent(JeevanaadiState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.people,
                      color: Colors.green.shade700,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FxText.bodyMedium(
                      "Assigned (${state.assignedTotalElements ?? 0})",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _assignedSearchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  isDense: true,
                ),
                onChanged: (value) {},
              ),
            ),
            if (state.selectedAssignedIds.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      context.read<JeevanaadiBloc>().add(
                        ClearAssignedSelectionEvent(),
                      );
                    },
                    icon: const Icon(Icons.clear, size: 16),
                    label: FxText.labelMedium(
                      'Clear (${state.selectedAssignedIds.length})',
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 36),
                    ),
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton.icon(
                    onPressed: state.isRemoving
                        ? null
                        : () {
                            context.read<JeevanaadiBloc>().add(
                              RemoveSelectedAssignedMembersEvent(
                                karyakarthaId: _selectedKaryakarthaId!,
                              ),
                            );
                          },
                    icon: state.isRemoving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.remove, size: 16),
                    label: FxText.labelMedium(
                      state.isRemoving ? '' : 'Remove',
                      maxLines: 1,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 3,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: state.isRemoving
              ? const Center(child: CircularProgressIndicator())
              : state.assignedKaryakarthas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off,
                        color: Colors.grey.shade400,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      FxText.bodyMedium(
                        'No assigned jeevanadi members',
                        style: FxTextStyle.bodyMedium(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: state.assignedKaryakarthas.length,
                  itemBuilder: (context, index) {
                    final user = state.assignedKaryakarthas[index];
                    final isSelected = state.selectedAssignedIds.contains(
                      user.id,
                    );
                    return _buildAssignedListItem(user, isSelected);
                  },
                ),
        ),
        const SizedBox(height: 16),
        _buildAssignedLoadMoreButton(state),
      ],
    );
  }

  // ========== Unassigned Tab ==========
  Widget _buildUnassignedTabContent(JeevanaadiState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_add,
                    color: Colors.orange.shade700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                FxText.bodyMedium(
                  "Unassigned (${state.unassignedTotalElements ?? 0})",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  isDense: true,
                ),
                onChanged: (value) {},
              ),
            ),
            if (state.selectedUnassignedIds.isNotEmpty)
              SizedBox(
                width: 80,
                child: ElevatedButton.icon(
                  onPressed: state.isAssigning
                      ? null
                      : () {
                          context.read<JeevanaadiBloc>().add(
                            AssignSelectedKaryakarthasEvent(
                              karyakarthaId: _selectedKaryakarthaId!,
                              memberIds: state.selectedUnassignedIds,
                            ),
                          );
                        },
                  icon: state.isAssigning
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add, size: 18),
                  label: FxText.bodyMedium(state.isAssigning ? '...' : 'Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 2,
                    minimumSize: const Size(0, 36),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: state.unassignedKaryakarthas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off,
                        color: Colors.grey.shade400,
                        size: 56,
                      ),
                      const SizedBox(height: 12),
                      FxText.bodyMedium(
                        'No unassigned members',
                        style: FxTextStyle.bodyMedium(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: state.unassignedKaryakarthas.length,
                  itemBuilder: (context, index) {
                    final user = state.unassignedKaryakarthas[index];
                    final isSelected = state.selectedUnassignedIds.contains(
                      user.id,
                    );
                    return _buildUnassignedListItem(user, isSelected);
                  },
                ),
        ),
        const SizedBox(height: 8),
        _buildUnassignedLoadMoreButton(state),
      ],
    );
  }

  // ========== List item widgets (same as before) ==========
  Widget _buildAssignedListItem(JeevanaadiUser user, bool isSelected) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: isSelected,
          onChanged: (value) {
            context.read<JeevanaadiBloc>().add(
              ToggleAssignedSelectionEvent(user.id),
            );
          },
          activeColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: user.jeevanaadiNo != null
            ? Text(
                "JeevanaadiNo: ${user.jeevanaadiNo!}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              )
            : null,
      ),
    );
  }

  Widget _buildUnassignedListItem(JeevanaadiUser user, bool isSelected) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: isSelected,
          onChanged: (value) {
            context.read<JeevanaadiBloc>().add(
              ToggleUnassignedSelectionEvent(user.id),
            );
          },
          activeColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: user.jeevanaadiNo != null
            ? Text(
                "JeevanaadiNo: ${user.jeevanaadiNo!}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              )
            : null,
      ),
    );
  }

  Widget _buildAssignedLoadMoreButton(JeevanaadiState state) {
    return SizedBox(
      width: 200,
      child: ElevatedButton.icon(
        onPressed: state.assignedCurrentPage < state.assignedTotalPages - 1
            ? () {
                setState(() {
                  _assignedPage = state.assignedCurrentPage + 1;
                });
                context.read<JeevanaadiBloc>().add(
                  FetchAssignedKaryakarthasEvent(
                    _selectedKaryakarthaId!,
                    _assignedPage,
                    10,
                  ),
                );
              }
            : null,
        icon: state.isLoadingAssigned
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.arrow_downward, size: 18),
        label: FxText.labelMedium(
          state.isLoadingAssigned
              ? 'Loading...'
              : state.assignedCurrentPage < state.assignedTotalPages - 1
              ? 'Load More (Page ${state.assignedCurrentPage + 1}/${state.assignedTotalPages})'
              : 'No More Data',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              state.assignedCurrentPage < state.assignedTotalPages - 1
              ? Colors.blue.shade600
              : Colors.grey.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 3,
        ),
      ),
    );
  }

  Widget _buildUnassignedLoadMoreButton(JeevanaadiState state) {
    return SizedBox(
      width: 200,
      child: ElevatedButton.icon(
        onPressed: state.unassignedCurrentPage < state.unassignedTotalPages - 1
            ? () {
                setState(() {
                  _unassignedPage = state.unassignedCurrentPage + 1;
                });
                context.read<JeevanaadiBloc>().add(
                  FetchUnassignedKaryakarthasEvent(_unassignedPage),
                );
              }
            : null,
        icon: state.isLoadingUnassigned
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.arrow_downward, size: 18),
        label: FxText.labelMedium(
          state.isLoadingUnassigned
              ? 'Loading...'
              : state.unassignedCurrentPage < state.unassignedTotalPages - 1
              ? 'Load More (Page ${state.unassignedCurrentPage + 1}/${state.unassignedTotalPages})'
              : 'No More Data',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              state.unassignedCurrentPage < state.unassignedTotalPages - 1
              ? Colors.orange.shade600
              : Colors.grey.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 3,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutx/styles/text_style.dart';
// import 'package:flutx/widgets/breadcrumb/breadcrumb.dart';
// import 'package:flutx/widgets/breadcrumb/breadcrumb_item.dart';
// import 'package:flutx/widgets/text/text.dart';
// import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
// import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
// import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
// import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_bloc.dart';
// import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_event.dart';
// import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_state.dart';
// import 'package:vikas_app/screeens/common/backButton.dart';
// import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
// import 'package:vikas_app/screeens/models/response/user.dart';
// import 'package:vikas_app/views/layouts/layout.dart';

// class KaryaKarthaViewScreen extends StatefulWidget {
//   final String karyakarthaId;

//   const KaryaKarthaViewScreen({super.key, required this.karyakarthaId});

//   @override
//   State<KaryaKarthaViewScreen> createState() => _KaryaKarthaViewScreenState();
// }

// class _KaryaKarthaViewScreenState extends State<KaryaKarthaViewScreen> {
//   int _unassignedPage = 0;
//   int _assignedPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   void _loadData() {
//     setState(() {
//       _assignedPage = 0;
//       _unassignedPage = 0;
//     });
//     context.read<KaryakarthaBloc>().add(
//       FetchKaryakarthaProfileEvent(widget.karyakarthaId),
//     );
//     context.read<JeevanaadiBloc>().add(
//       FetchAssignedKaryakarthasEvent(widget.karyakarthaId, _assignedPage, 10),
//     );
//     context.read<JeevanaadiBloc>().add(FetchUnassignedKaryakarthasEvent(0));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Layout(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: BlocListener<JeevanaadiBloc, JeevanaadiState>(
//             listener: (context, state) {
//               if (state.errorMessage != null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: FxText.labelMedium(state.errorMessage!),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             child: BlocBuilder<JeevanaadiBloc, JeevanaadiState>(
//               builder: (context, state) {
//                 if (state.status == JeevanaadiApiStatus.loading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (state.status == JeevanaadiApiStatus.error) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.error, size: 64, color: Colors.red),
//                         const SizedBox(height: 16),
//                         FxText.headlineSmall(
//                           'Error loading data',
//                           color: Colors.red,
//                         ),
//                         const SizedBox(height: 8),
//                         FxText.bodyMedium(
//                           state.errorMessage ?? 'Unknown error occurred',
//                           color: Colors.grey.shade700,
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton.icon(
//                           onPressed: _loadData,
//                           icon: const Icon(Icons.refresh, size: 18),
//                           label: FxText.labelMedium('Retry'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue.shade600,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 12,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             elevation: 2,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 final member = state.jeevanadiMember;

//                 return Container(
//                   constraints: const BoxConstraints(maxWidth: 1400),
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Backbutton().buildBackButton(context, "Karyakartha List"),
//                       const SizedBox(height: 20),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Colors
//                                             .purple
//                                             .shade50, // Changed to purple
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Icon(
//                                         Icons.person,
//                                         color: Colors
//                                             .purple
//                                             .shade700, // Changed to purple
//                                         size: 24,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     FxText.labelMedium(
//                                       "Karyakartha Details", // Changed title
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineSmall
//                                           ?.copyWith(color: Colors.black),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20),

//                                 // Use BlocBuilder to get karyakartha details
//                                 BlocBuilder<KaryakarthaBloc, KaryakarthaState>(
//                                   builder: (context, karyakarthaState) {
//                                     if (karyakarthaState.profileLoading ==
//                                         true) {
//                                       return const Center(
//                                         child: Padding(
//                                           padding: EdgeInsets.all(20),
//                                           child: CircularProgressIndicator(),
//                                         ),
//                                       );
//                                     }

//                                     final karyakartha =
//                                         karyakarthaState.karyakarthaProfile;

//                                     if (karyakartha != null) {
//                                       return _buildKaryakarthaDetails(
//                                         karyakartha,
//                                       );
//                                     } else {
//                                       return Container(
//                                         padding: const EdgeInsets.all(20),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey.shade100,
//                                           borderRadius: BorderRadius.circular(
//                                             16,
//                                           ),
//                                         ),
//                                         child: Center(
//                                           child: FxText.bodyMedium(
//                                             'No karyakartha data available',
//                                             color: Colors.grey.shade600,
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 30),

//                       // Main Content
//                       SizedBox(
//                         height:
//                             MediaQuery.of(context).size.height -
//                             (MediaQuery.of(context).size.width > 1200
//                                 ? 120
//                                 : 180),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 4,
//                               child: Container(
//                                 padding: EdgeInsets.all(
//                                   MediaQuery.of(context).size.width > 1200
//                                       ? 20
//                                       : 16,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: Colors.grey.shade200,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.03),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 padding: const EdgeInsets.all(
//                                                   8,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.green.shade50,
//                                                   borderRadius:
//                                                       BorderRadius.circular(8),
//                                                 ),
//                                                 child: Icon(
//                                                   Icons.people,
//                                                   color: Colors.green.shade700,
//                                                   size: 22,
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 12),
//                                               Expanded(
//                                                 child:
//                                                     //  FxText.bodyMedium(
//                                                     //   "Assigned Jeevanadi members",
//                                                     //   style: Theme.of(context)
//                                                     //       .textTheme
//                                                     //       .titleMedium
//                                                     //       ?.copyWith(
//                                                     //         color: Colors.black,
//                                                     //         fontSize: 16,
//                                                     //       ),
//                                                     //   maxLines: 1,
//                                                     //   overflow:
//                                                     //       TextOverflow.ellipsis,
//                                                     // ),
//                                                     FxText.bodyMedium(
//                                                       "Assigned Jeevanadi members ${state.assignedTotalElements != null ? '(${state.assignedTotalElements})' : ''}",
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .titleMedium
//                                                           ?.copyWith(
//                                                             color: Colors.black,
//                                                             fontSize: 16,
//                                                           ),
//                                                     ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         if (state
//                                             .selectedAssignedIds
//                                             .isNotEmpty)
//                                           Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               TextButton.icon(
//                                                 onPressed: () {
//                                                   context
//                                                       .read<JeevanaadiBloc>()
//                                                       .add(
//                                                         ClearAssignedSelectionEvent(),
//                                                       );
//                                                 },
//                                                 icon: const Icon(
//                                                   Icons.clear,
//                                                   size: 16,
//                                                 ),
//                                                 label: FxText.labelMedium(
//                                                   'Clear (${state.selectedAssignedIds.length})',
//                                                 ),
//                                                 style: TextButton.styleFrom(
//                                                   foregroundColor:
//                                                       Colors.grey.shade700,
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         horizontal: 8,
//                                                       ),
//                                                   minimumSize: const Size(
//                                                     0,
//                                                     36,
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 4),
//                                               ElevatedButton.icon(
//                                                 onPressed: state.isRemoving
//                                                     ? null
//                                                     : () {
//                                                         context
//                                                             .read<
//                                                               JeevanaadiBloc
//                                                             >()
//                                                             .add(
//                                                               RemoveSelectedAssignedMembersEvent(
//                                                                 karyakarthaId:
//                                                                     widget
//                                                                         .karyakarthaId,
//                                                               ),
//                                                             );
//                                                       },
//                                                 icon: state.isRemoving
//                                                     ? const SizedBox(
//                                                         width: 16,
//                                                         height: 16,
//                                                         child:
//                                                             CircularProgressIndicator(
//                                                               strokeWidth: 2,
//                                                               color:
//                                                                   Colors.white,
//                                                             ),
//                                                       )
//                                                     : const Icon(
//                                                         Icons.remove,
//                                                         size: 16,
//                                                       ),
//                                                 label: FxText.labelMedium(
//                                                   state.isRemoving
//                                                       ? ''
//                                                       : 'Remove',
//                                                   maxLines: 1,
//                                                 ),
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor:
//                                                       Colors.red.shade600,
//                                                   foregroundColor: Colors.white,
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         horizontal: 12,
//                                                         vertical: 8,
//                                                       ),
//                                                   minimumSize: const Size(
//                                                     0,
//                                                     36,
//                                                   ),
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           8,
//                                                         ),
//                                                   ),
//                                                   elevation: 3,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height:
//                                           MediaQuery.of(context).size.width >
//                                               1200
//                                           ? 16
//                                           : 12,
//                                     ),
//                                     Expanded(
//                                       child: state.isRemoving
//                                           ? const Center(
//                                               child:
//                                                   CircularProgressIndicator(),
//                                             )
//                                           : state.assignedKaryakarthas.isEmpty
//                                           ? Center(
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.person_off,
//                                                     color: Colors.grey.shade400,
//                                                     size: 56,
//                                                   ),
//                                                   const SizedBox(height: 12),
//                                                   FxText.bodyMedium(
//                                                     'No assigned jeevanadi members',
//                                                     style:
//                                                         FxTextStyle.bodyMedium(
//                                                           color: Colors
//                                                               .grey
//                                                               .shade600,
//                                                           fontSize: 16,
//                                                         ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           // : GridView.builder(
//                                           //     gridDelegate:
//                                           //         SliverGridDelegateWithFixedCrossAxisCount(
//                                           //           crossAxisCount:
//                                           //               MediaQuery.of(
//                                           //                     context,
//                                           //                   ).size.width >
//                                           //                   1200
//                                           //               ? 4
//                                           //               : 3,
//                                           //           crossAxisSpacing:
//                                           //               MediaQuery.of(
//                                           //                     context,
//                                           //                   ).size.width >
//                                           //                   1200
//                                           //               ? 10
//                                           //               : 8,
//                                           //           mainAxisSpacing:
//                                           //               MediaQuery.of(
//                                           //                     context,
//                                           //                   ).size.width >
//                                           //                   1200
//                                           //               ? 2
//                                           //               : 1,
//                                           //           childAspectRatio:
//                                           //               MediaQuery.of(
//                                           //                     context,
//                                           //                   ).size.width >
//                                           //                   1200
//                                           //               ? 0.75
//                                           //               : 0.8,
//                                           //         ),
//                                           //     itemCount: state
//                                           //         .assignedKaryakarthas
//                                           //         .length,
//                                           //     itemBuilder: (context, index) {
//                                           //       final user = state
//                                           //           .assignedKaryakarthas[index];
//                                           //       return _buildAssignedUserItem(
//                                           //         user,
//                                           //         state,
//                                           //       );
//                                           //     },
//                                           //   ),
//                                           // : ListView.builder(
//                                           //     itemCount: state
//                                           //         .assignedKaryakarthas
//                                           //         .length,
//                                           //     itemBuilder: (context, index) {
//                                           //       final user = state
//                                           //           .assignedKaryakarthas[index];
//                                           //       final isSelected = state
//                                           //           .selectedAssignedIds
//                                           //           .contains(user.id);
//                                           //       return CheckboxListTile(
//                                           //         value: isSelected,
//                                           //         onChanged: (value) {
//                                           //           context
//                                           //               .read<JeevanaadiBloc>()
//                                           //               .add(
//                                           //                 ToggleAssignedSelectionEvent(
//                                           //                   user.id,
//                                           //                 ),
//                                           //               );
//                                           //         },
//                                           //         title: FxText.bodyMedium(
//                                           //           user.fullName,
//                                           //           style:
//                                           //               FxTextStyle.bodyMedium(
//                                           //                 fontWeight: 600,
//                                           //               ),
//                                           //         ),
//                                           //         subtitle:
//                                           //             user.jeevanaadiNo != null
//                                           //             ? FxText.labelSmall(
//                                           //                 user.jeevanaadiNo!,
//                                           //               )
//                                           //             : null,
//                                           //         secondary: CircleAvatar(
//                                           //           backgroundColor:
//                                           //               Colors.green.shade100,
//                                           //           child: Icon(
//                                           //             Icons.person,
//                                           //             color:
//                                           //                 Colors.green.shade700,
//                                           //           ),
//                                           //         ),
//                                           //         activeColor: Colors.green,
//                                           //         controlAffinity:
//                                           //             ListTileControlAffinity
//                                           //                 .leading,
//                                           //       );
//                                           //     },
//                                           //   ),
//                                           : ListView.builder(
//                                               itemCount: state
//                                                   .assignedKaryakarthas
//                                                   .length,
//                                               itemBuilder: (context, index) {
//                                                 final user = state
//                                                     .assignedKaryakarthas[index];
//                                                 final isSelected = state
//                                                     .selectedAssignedIds
//                                                     .contains(user.id);
//                                                 return _buildAssignedListItem(
//                                                   user,
//                                                   isSelected,
//                                                 );
//                                               },
//                                             ),
//                                     ),

//                                     const SizedBox(height: 16),
//                                     _buildAssignedLoadMoreButton(state),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 30),

//                             // Right side - Unassigned Karyakarthas (40%)
//                             Expanded(
//                               flex: 4,
//                               child: Container(
//                                 padding: const EdgeInsets.all(20),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: Colors.grey.shade200,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.03),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Container(
//                                               padding: const EdgeInsets.all(8),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.orange.shade50,
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               child: Icon(
//                                                 Icons.person_add,
//                                                 color: Colors.orange.shade700,
//                                                 size: 22,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 12),
//                                             SizedBox(
//                                               width: 235,
//                                               child:
//                                                   //  FxText.bodyMedium(
//                                                   //   "Unassigned jeevanadi members",
//                                                   //   style: Theme.of(context)
//                                                   //       .textTheme
//                                                   //       .titleMedium
//                                                   //       ?.copyWith(
//                                                   //         color: Colors.black,
//                                                   //         fontSize: 16,
//                                                   //       ),
//                                                   //   maxLines: 1,
//                                                   //   overflow: TextOverflow.ellipsis,
//                                                   // ),
//                                                   FxText.bodyMedium(
//                                                     "Unassigned members ${state.unassignedTotalElements != null ? '(${state.unassignedTotalElements})' : ''}",
//                                                     style: Theme.of(context)
//                                                         .textTheme
//                                                         .titleMedium
//                                                         ?.copyWith(
//                                                           color: Colors.black,
//                                                           fontSize: 16,
//                                                         ),
//                                                   ),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(width: 10),
//                                         if (state
//                                             .selectedUnassignedIds
//                                             .isNotEmpty)
//                                           if (state
//                                               .selectedUnassignedIds
//                                               .isNotEmpty)
//                                             SizedBox(
//                                               width: 80,
//                                               child: ElevatedButton.icon(
//                                                 onPressed: state.isAssigning
//                                                     ? null
//                                                     : () {
//                                                         context.read<JeevanaadiBloc>().add(
//                                                           AssignSelectedKaryakarthasEvent(
//                                                             karyakarthaId: widget
//                                                                 .karyakarthaId,
//                                                             memberIds: state
//                                                                 .selectedUnassignedIds,
//                                                           ),
//                                                         );
//                                                       },
//                                                 icon: state.isAssigning
//                                                     ? const SizedBox(
//                                                         width: 18,
//                                                         height: 18,
//                                                         child:
//                                                             CircularProgressIndicator(
//                                                               strokeWidth: 2,
//                                                               color:
//                                                                   Colors.white,
//                                                             ),
//                                                       )
//                                                     : const Icon(
//                                                         Icons.add,
//                                                         size: 18,
//                                                       ),
//                                                 label: FxText.bodyMedium(
//                                                   state.isAssigning
//                                                       ? '...'
//                                                       : 'Add',
//                                                 ),
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor:
//                                                       Colors.green.shade600,
//                                                   foregroundColor: Colors.white,
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         horizontal: 12,
//                                                         vertical: 8,
//                                                       ),
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           6,
//                                                         ),
//                                                   ),
//                                                   elevation: 2,
//                                                   minimumSize: const Size(
//                                                     0,
//                                                     36,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height:
//                                           MediaQuery.of(context).size.width >
//                                               1200
//                                           ? 16
//                                           : 12,
//                                     ),

//                                     Expanded(
//                                       child:
//                                           state.unassignedKaryakarthas.isEmpty
//                                           ? Center(
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.person_off,
//                                                     color: Colors.grey.shade400,
//                                                     size: 56,
//                                                   ),
//                                                   const SizedBox(height: 12),
//                                                   FxText.bodyMedium(
//                                                     'No unassigned karyakarthas available',
//                                                     style:
//                                                         FxTextStyle.bodyMedium(
//                                                           color: Colors
//                                                               .grey
//                                                               .shade600,
//                                                           fontSize: 16,
//                                                         ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             )
//                                           // : GridView.builder(
//                                           //     gridDelegate:
//                                           //         SliverGridDelegateWithFixedCrossAxisCount(
//                                           //           crossAxisCount:
//                                           //               MediaQuery.of(
//                                           //                     context,
//                                           //                   ).size.width >
//                                           //                   1200
//                                           //               ? 4
//                                           //               : 3,
//                                           //           crossAxisSpacing:
//                                           //               MediaQuery.of(
//                                           //                     context,
//                                           //                   ).size.width >
//                                           //                   1200
//                                           //               ? 5
//                                           //               : 4,
//                                           //           mainAxisSpacing:
//                                           //               MediaQuery.of(
//                                           //                     context,
//                                           //                   ).size.width >
//                                           //                   1200
//                                           //               ? 2
//                                           //               : 1,
//                                           //           childAspectRatio:
//                                           //               MediaQuery.of(
//                                           //                     context,
//                                           //                   ).size.width >
//                                           //                   1200
//                                           //               ? 0.75
//                                           //               : 0.8,
//                                           //         ),
//                                           //     itemCount: state
//                                           //         .unassignedKaryakarthas
//                                           //         .length,
//                                           //     itemBuilder: (context, index) {
//                                           //       final user = state
//                                           //           .unassignedKaryakarthas[index];
//                                           //       final isSelected = state
//                                           //           .selectedUnassignedIds
//                                           //           .contains(user.id);
//                                           //       return GestureDetector(
//                                           //         onTap: () {
//                                           //           context
//                                           //               .read<JeevanaadiBloc>()
//                                           //               .add(
//                                           //                 ToggleUnassignedSelectionEvent(
//                                           //                   user.id,
//                                           //                 ),
//                                           //               );
//                                           //         },
//                                           //         child: Column(
//                                           //           children: [
//                                           //             Stack(
//                                           //               children: [
//                                           //                 Container(
//                                           //                   padding:
//                                           //                       const EdgeInsets.all(
//                                           //                         2,
//                                           //                       ),
//                                           //                   decoration: BoxDecoration(
//                                           //                     color: isSelected
//                                           //                         ? Colors
//                                           //                               .blue
//                                           //                               .shade50
//                                           //                         : Colors
//                                           //                               .grey
//                                           //                               .shade50,
//                                           //                     borderRadius:
//                                           //                         BorderRadius.circular(
//                                           //                           30,
//                                           //                         ),
//                                           //                     border: isSelected
//                                           //                         ? Border.all(
//                                           //                             color: Colors
//                                           //                                 .blue
//                                           //                                 .shade200,
//                                           //                             width: 2,
//                                           //                           )
//                                           //                         : null,
//                                           //                     boxShadow:
//                                           //                         isSelected
//                                           //                         ? [
//                                           //                             BoxShadow(
//                                           //                               color: Colors
//                                           //                                   .blue
//                                           //                                   .withOpacity(
//                                           //                                     0.3,
//                                           //                                   ),
//                                           //                               blurRadius:
//                                           //                                   8,
//                                           //                               offset:
//                                           //                                   const Offset(
//                                           //                                     0,
//                                           //                                     2,
//                                           //                                   ),
//                                           //                             ),
//                                           //                           ]
//                                           //                         : [
//                                           //                             BoxShadow(
//                                           //                               color: Colors
//                                           //                                   .black
//                                           //                                   .withOpacity(
//                                           //                                     0.1,
//                                           //                                   ),
//                                           //                               blurRadius:
//                                           //                                   4,
//                                           //                               offset:
//                                           //                                   const Offset(
//                                           //                                     0,
//                                           //                                     2,
//                                           //                                   ),
//                                           //                             ),
//                                           //                           ],
//                                           //                   ),
//                                           //                   child: CircleAvatar(
//                                           //                     radius: 24,
//                                           //                     backgroundColor:
//                                           //                         isSelected
//                                           //                         ? Colors
//                                           //                               .blue
//                                           //                               .shade200
//                                           //                         : Colors
//                                           //                               .grey
//                                           //                               .shade200,
//                                           //                     child: Icon(
//                                           //                       Icons.person,
//                                           //                       color:
//                                           //                           isSelected
//                                           //                           ? Colors
//                                           //                                 .blue
//                                           //                                 .shade800
//                                           //                           : Colors
//                                           //                                 .grey
//                                           //                                 .shade600,
//                                           //                       size: 26,
//                                           //                     ),
//                                           //                   ),
//                                           //                 ),
//                                           //                 if (isSelected)
//                                           //                   Positioned(
//                                           //                     right: -2,
//                                           //                     top: -2,
//                                           //                     child: Container(
//                                           //                       width: 22,
//                                           //                       height: 22,
//                                           //                       decoration: BoxDecoration(
//                                           //                         color: Colors
//                                           //                             .green,
//                                           //                         shape: BoxShape
//                                           //                             .circle,
//                                           //                         border: Border.all(
//                                           //                           color: Colors
//                                           //                               .white,
//                                           //                           width: 3,
//                                           //                         ),
//                                           //                         boxShadow: [
//                                           //                           BoxShadow(
//                                           //                             color: Colors
//                                           //                                 .green
//                                           //                                 .withOpacity(
//                                           //                                   0.3,
//                                           //                                 ),
//                                           //                             blurRadius:
//                                           //                                 4,
//                                           //                             offset:
//                                           //                                 const Offset(
//                                           //                                   0,
//                                           //                                   2,
//                                           //                                 ),
//                                           //                           ),
//                                           //                         ],
//                                           //                       ),
//                                           //                       child: const Icon(
//                                           //                         Icons.check,
//                                           //                         color: Colors
//                                           //                             .white,
//                                           //                         size: 14,
//                                           //                       ),
//                                           //                     ),
//                                           //                   ),
//                                           //               ],
//                                           //             ),
//                                           //             const SizedBox(height: 6),
//                                           //             SizedBox(
//                                           //               width: 70,
//                                           //               child: FxText.bodyMedium(
//                                           //                 user.fullName,
//                                           //                 style: FxTextStyle.bodyMedium(
//                                           //                   fontSize: 11,
//                                           //                   fontWeight: 600,
//                                           //                   color: isSelected
//                                           //                       ? Colors
//                                           //                             .blue
//                                           //                             .shade800
//                                           //                       : Colors.black,
//                                           //                 ),
//                                           //                 textAlign:
//                                           //                     TextAlign.center,
//                                           //                 maxLines: 2,
//                                           //                 overflow: TextOverflow
//                                           //                     .ellipsis,
//                                           //               ),
//                                           //             ),
//                                           //           ],
//                                           //         ),
//                                           //       );
//                                           //     },
//                                           //   ),
//                                           : ListView.builder(
//                                               itemCount: state
//                                                   .unassignedKaryakarthas
//                                                   .length,
//                                               itemBuilder: (context, index) {
//                                                 final user = state
//                                                     .unassignedKaryakarthas[index];
//                                                 final isSelected = state
//                                                     .selectedUnassignedIds
//                                                     .contains(user.id);
//                                                 return _buildUnassignedListItem(
//                                                   user,
//                                                   isSelected,
//                                                 );
//                                               },
//                                             ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     SizedBox(
//                                       width: 200,
//                                       child: ElevatedButton.icon(
//                                         onPressed:
//                                             state.unassignedCurrentPage <
//                                                 state.unassignedTotalPages - 1
//                                             ? () {
//                                                 setState(() {
//                                                   _unassignedPage =
//                                                       state
//                                                           .unassignedCurrentPage +
//                                                       1;
//                                                 });
//                                                 context.read<JeevanaadiBloc>().add(
//                                                   FetchUnassignedKaryakarthasEvent(
//                                                     _unassignedPage,
//                                                   ),
//                                                 );
//                                               }
//                                             : null,
//                                         icon: state.isLoadingUnassigned
//                                             ? const SizedBox(
//                                                 width: 18,
//                                                 height: 18,
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                       strokeWidth: 2,
//                                                       color: Colors.white,
//                                                     ),
//                                               )
//                                             : const Icon(
//                                                 Icons.arrow_downward,
//                                                 size: 18,
//                                               ),
//                                         label: FxText.labelMedium(
//                                           state.isLoadingUnassigned
//                                               ? 'Loading...'
//                                               : state.unassignedCurrentPage <
//                                                     state.unassignedTotalPages -
//                                                         1
//                                               ? 'Load More (Page ${state.unassignedCurrentPage + 1}/${state.unassignedTotalPages})'
//                                               : 'No More Data',
//                                         ),
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor:
//                                               state.unassignedCurrentPage <
//                                                   state.unassignedTotalPages - 1
//                                               ? Colors.orange.shade600
//                                               : Colors.grey.shade400,
//                                           foregroundColor: Colors.white,
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 16,
//                                             vertical: 10,
//                                           ),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                           ),
//                                           elevation: 3,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildKaryakarthaDetails(User karyakartha) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.purple.shade50, Colors.deepPurple.shade50],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.purple.shade100),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //_buildDetailRow('ID:', karyakartha.id),
//                 const SizedBox(height: 8),
//                 _buildDetailRow('Name:', karyakartha.name),
//                 const SizedBox(height: 8),
//                 _buildDetailRow('Email:', karyakartha.email),
//                 const SizedBox(height: 8),
//                 _buildDetailRow('Mobile:', karyakartha.mobileNumber ?? 'N/A'),
//                 const SizedBox(height: 8),
//                 _buildDetailRow('Status:', karyakartha.status),
//               ],
//             ),
//           ),
//           const SizedBox(width: 20),
//           // Second column - remaining 5 fields
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildDetailRow('Pincode:', karyakartha.pincode ?? 'N/A'),
//                 const SizedBox(height: 8),
//                 _buildDetailRow('City:', karyakartha.city ?? 'N/A'),
//                 const SizedBox(height: 8),
//                 _buildDetailRow('Area:', karyakartha.area ?? 'N/A'),
//                 const SizedBox(height: 8),
//                 _buildDetailRow('State:', karyakartha.state ?? 'N/A'),
//                 const SizedBox(height: 8),
//                 _buildDetailRow('Country:', karyakartha.country ?? 'N/A'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Reusable detail row widget
//   Widget _buildDetailRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 70,
//           child: FxText.labelMedium(
//             label,
//             style: FxTextStyle.labelMedium(
//               fontWeight: 700,
//               color: Colors.deepPurple.shade700,
//               fontSize: 13,
//             ),
//           ),
//         ),
//         Expanded(
//           child: FxText.bodyMedium(
//             value.isEmpty ? 'N/A' : value,
//             style: FxTextStyle.labelMedium(fontWeight: 600, fontSize: 14),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAssignedLoadMoreButton(JeevanaadiState state) {
//     return SizedBox(
//       width: 200,
//       child: ElevatedButton.icon(
//         onPressed: state.assignedCurrentPage < state.assignedTotalPages - 1
//             ? () {
//                 setState(() {
//                   _assignedPage = state.assignedCurrentPage + 1;
//                 });
//                 context.read<JeevanaadiBloc>().add(
//                   FetchAssignedKaryakarthasEvent(
//                     widget.karyakarthaId,
//                     _assignedPage,
//                     10,
//                   ),
//                 );
//               }
//             : null,
//         icon: state.isLoadingAssigned
//             ? const SizedBox(
//                 width: 18,
//                 height: 18,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               )
//             : const Icon(Icons.arrow_downward, size: 18),
//         label: FxText.labelMedium(
//           state.isLoadingAssigned
//               ? 'Loading...'
//               : state.assignedCurrentPage < state.assignedTotalPages - 1
//               ? 'Load More (Page ${state.assignedCurrentPage + 1}/${state.assignedTotalPages})'
//               : 'No More Data',
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//               state.assignedCurrentPage < state.assignedTotalPages - 1
//               ? Colors.blue.shade600
//               : Colors.grey.shade400,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           elevation: 3,
//         ),
//       ),
//     );
//   }

//   // Widget _buildAssignedUserItem(User user) {
//   //   return Column(
//   //     children: [
//   //       Stack(
//   //         children: [
//   //           Container(
//   //             padding: const EdgeInsets.all(3),
//   //             decoration: BoxDecoration(
//   //               color: Colors.blue.shade50,
//   //               borderRadius: BorderRadius.circular(35),
//   //             ),
//   //             child: CircleAvatar(
//   //               radius: 28,
//   //               backgroundColor: Colors.blue.shade100,
//   //               child: Icon(
//   //                 Icons.person,
//   //                 color: Colors.blue.shade800,
//   //                 size: 30,
//   //               ),
//   //             ),
//   //           ),
//   //           Positioned(
//   //             right: -3,
//   //             top: -3,
//   //             child: GestureDetector(
//   //               onTap: () {
//   //                 context.read<JeevanaadiBloc>().add(
//   //                   RemoveAssignedKaryakarthaEvent(
//   //                     karyakarthaId: widget.karyakarthaId,
//   //                     memberId: user.id,
//   //                   ),
//   //                 );
//   //               },
//   //               child: Container(
//   //                 width: 26,
//   //                 height: 26,
//   //                 decoration: BoxDecoration(
//   //                   color: Colors.red.shade500,
//   //                   shape: BoxShape.circle,
//   //                   border: Border.all(color: Colors.white, width: 3),
//   //                 ),
//   //                 child: const Icon(Icons.close, color: Colors.white, size: 16),
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       const SizedBox(height: 8),
//   //       SizedBox(
//   //         width: 80,
//   //         child: FxText.bodyMedium(
//   //           user.name,
//   //           style: FxTextStyle.bodyMedium(
//   //             fontSize: 12,
//   //             fontWeight: 600,
//   //             color: Colors.black,
//   //           ),
//   //           textAlign: TextAlign.center,
//   //           maxLines: 2,
//   //           overflow: TextOverflow.ellipsis,
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//   Widget _buildAssignedUserItem(JeevanaadiUser user, JeevanaadiState state) {
//     final isSelected = state.selectedAssignedIds.contains(user.id);

//     return GestureDetector(
//       onTap: () {
//         context.read<JeevanaadiBloc>().add(
//           ToggleAssignedSelectionEvent(user.id),
//         );
//       },
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               // Member avatar with selection styling
//               Container(
//                 padding: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? Colors.blue.shade50
//                       : Colors.green.shade50,
//                   borderRadius: BorderRadius.circular(30),
//                   border: isSelected
//                       ? Border.all(color: Colors.blue.shade200, width: 2)
//                       : null,
//                   boxShadow: isSelected
//                       ? [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ]
//                       : [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 28,
//                   backgroundColor: isSelected
//                       ? Colors.blue.shade200
//                       : Colors.green.shade200,
//                   child: Icon(
//                     Icons.person,
//                     color: isSelected
//                         ? Colors.blue.shade800
//                         : Colors.green.shade800,
//                     size: 30,
//                   ),
//                 ),
//               ),
//               // Selection indicator (checkmark)
//               if (isSelected)
//                 Positioned(
//                   right: -2,
//                   top: -2,
//                   child: Container(
//                     width: 22,
//                     height: 22,
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 3),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.green.withOpacity(0.3),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 14,
//                     ),
//                   ),
//                 ),
//               // Individual remove button (X)
//               Positioned(
//                 right: -3,
//                 top: -3,
//                 child: GestureDetector(
//                   onTap: () {
//                     context.read<JeevanaadiBloc>().add(
//                       RemoveAssignedKaryakarthaEvent(
//                         karyakarthaId: widget.karyakarthaId,
//                         memberId: user.id,
//                       ),
//                     );
//                   },
//                   child: Container(
//                     width: 26,
//                     height: 26,
//                     decoration: BoxDecoration(
//                       color: Colors.red.shade500,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 3),
//                     ),
//                     child: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           // Member name
//           SizedBox(
//             width: 80,
//             child: FxText.bodyMedium(
//               user.fullName,
//               style: FxTextStyle.bodyMedium(
//                 fontSize: 12,
//                 fontWeight: 600,
//                 color: isSelected ? Colors.blue.shade800 : Colors.black,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAssignedListItem(JeevanaadiUser user, bool isSelected) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         leading: Checkbox(
//           value: isSelected,
//           onChanged: (value) {
//             context.read<JeevanaadiBloc>().add(
//               ToggleAssignedSelectionEvent(user.id),
//             );
//           },
//           activeColor: Colors.green,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         ),
//         leadingAndTrailingTextStyle: const TextStyle(fontSize: 14),
//         title: Text(
//           user.fullName,
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//         ),
//         subtitle: user.jeevanaadiNo != null
//             ? Text(
//                 "JeevanaadiNo: ${user.jeevanaadiNo!}",
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//               )
//             : null,
//         // trailing: IconButton(
//         //   icon: const Icon(Icons.close, size: 20),
//         //   color: Colors.red.shade400,
//         //   onPressed: () {
//         //     _showRemoveConfirmation(context, user.id);
//         //   },
//         //   tooltip: 'Remove',
//         // ),
//       ),
//     );
//   }

//   Widget _buildUnassignedListItem(JeevanaadiUser user, bool isSelected) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         leading: Checkbox(
//           value: isSelected,
//           onChanged: (value) {
//             context.read<JeevanaadiBloc>().add(
//               ToggleUnassignedSelectionEvent(user.id),
//             );
//           },
//           activeColor: Colors.blue,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         ),
//         title: Text(
//           user.fullName,
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//         ),
//         subtitle: user.jeevanaadiNo != null
//             ? Text(
//                 "JeevanaadiNo: ${user.jeevanaadiNo!}",
//                 style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//               )
//             : null,
//       ),
//     );
//   }
// }
