import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/styles/text_style.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:vikas_app/api_services/local_storage/VikasDB.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_bloc.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_event.dart';
import 'package:vikas_app/bloc_management/karyakarthas/karyakartha_state.dart';
import 'package:vikas_app/screeens/common/backButton.dart';
import 'package:vikas_app/screeens/common/common_filter.dart';
import 'package:vikas_app/screeens/common/common_search_bar.dart';
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
  String? _unassignedOrder;
  String? _assignedOrder;
  int? unassignedTotalElements;
  int? unassignedSearchCount;
  bool isSearchingUnassigned = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _karyakarthaSearchController =
      TextEditingController();
  final TextEditingController _assignedSearchController =
      TextEditingController();
  final bool isAdmin =
      Vikasdb().getString("USER_TYPE")?.toUpperCase() == "ADMIN";
      final bool isJeevanadiLead =
    Vikasdb().getString("USER_TYPE")?.toUpperCase() == "JEEVANAADI_LEAD";


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: isJeevanadiLead ? 2 : 1, vsync: this);
    _loadKaryakarthaList();
    if (widget.karyakarthaId != null) {
      _selectedKaryakarthaId = widget.karyakarthaId;
      _loadDataForSelected();
    }
  }

  void _loadKaryakarthaList() {
    _karyakarthaSearchController.clear();
    context.read<KaryakarthaBloc>().add(FetchKaryakattasEvent(0));
  }

  void _loadDataForSelected() {
    if (_selectedKaryakarthaId == null) return;
    setState(() {
      _assignedPage = 0;
      _unassignedPage = 0;
    });
    //_searchController.clear();
    context.read<JeevanaadiBloc>().add(
      FetchAssignedKaryakarthasEvent(
        _selectedKaryakarthaId!,
        _assignedPage,
        10,
      ),
    );
    context.read<JeevanaadiBloc>().add(
      FetchUnassignedKaryakarthasEvent(0, 10, null, null),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _assignedSearchController.dispose();
    _karyakarthaSearchController.dispose();
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
                CommonSearchBar(
                  controller: _karyakarthaSearchController,
                  hintText: "Search karyakartha...",
                  onSearch: (value) {
                    _performKaryakarthaSearch();
                  },
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

                                            Row(
                                              children: [
                                                Text(
                                                  user.mobileNumber ??
                                                      'No mobile',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                if (user.mobileNumber != null &&
                                                    user.joinedDate != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                        ),
                                                    child: Text(
                                                      "|",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey
                                                            .shade500,
                                                      ),
                                                    ),
                                                  ),
                                                if (user.joinedDate != null)
                                                  Text(
                                                    "Joined: ${user.joinedDate}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                              ],
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
                  tabs: isJeevanadiLead
                      ? const [
                          Tab(text: "Allocated"),
                          Tab(text: "Unassigned"),
                        ]
                      : const [Tab(text: "Assigned Members")],

                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    // children: [
                    //   _buildAssignedTabContent(state),
                    //   _buildUnassignedTabContent(state),
                    // ],
                    children: [
                      _buildAssignedTabContent(
                        state,
                        isAdmin: isAdmin,
                      ), // Deallocate
                      if (isJeevanadiLead)
                        _buildUnassignedTabContent(
                          state,
                          isAdmin: isAdmin,
                        ), // Allocate
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
  Widget _buildAssignedTabContent(
    JeevanaadiState state, {
    required bool isAdmin,
  }) {
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
            CommonFilter(
              selectedValue: _assignedOrder,
              onChanged: (newOrder) {
                setState(() {
                  _assignedOrder = newOrder;
                });
                _refreshAssignedList(order: newOrder);
              },
            ),
            const SizedBox(width: 3),

            SizedBox(
              width: 200,
              child: CommonSearchBar(
                controller: _assignedSearchController,
                hintText: "Search assigned...",
                onSearch: (value) {
                  _performAssignedSearch();
                },
              ),
            ),
            const SizedBox(width: 8),

            if (isJeevanadiLead && state.selectedAssignedIds.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TextButton.icon(
                  //   onPressed: () {
                  //     context.read<JeevanaadiBloc>().add(
                  //       ClearAssignedSelectionEvent(),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.clear, size: 16),
                  //   label: FxText.labelMedium(
                  //     'Clear (${state.selectedAssignedIds.length})',
                  //   ),
                  //   style: TextButton.styleFrom(
                  //     foregroundColor: Colors.grey.shade700,
                  //     padding: const EdgeInsets.symmetric(horizontal: 8),
                  //     minimumSize: const Size(0, 36),
                  //   ),
                  // ),
                  // const SizedBox(width: 4),
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
                    return _buildAssignedListItem(
                      user,
                      isSelected,
                      isAdmin: isAdmin,
                    );
                  },
                ),
        ),
        const SizedBox(height: 16),
        _buildAssignedLoadMoreButton(state),
      ],
    );
  }

  // ========== Unassigned Tab ==========
  Widget _buildUnassignedTabContent(
    JeevanaadiState state, {
    required bool isAdmin,
  }) {
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
                  // "Unassigned (${state.unassignedTotalElementsBeforeSearch ?? 0})",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            CommonFilter(
              selectedValue: _unassignedOrder,
              onChanged: (newOrder) {
                setState(() {
                  _unassignedOrder = newOrder;
                });
                _refreshUnassignedList(order: newOrder);
              },
            ),
            const SizedBox(width: 3),
            SizedBox(
              width: 200,
              child: CommonSearchBar(
                controller: _searchController,
                hintText: "Search unassigned...",
                onSearch: (value) {
                  _performUnassignedSearch();
                },
              ),
            ),
            if (state.selectedUnassignedIds.isNotEmpty)
              Flexible(
                // SizedBox(
                //   width: 80,
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
  Widget _buildAssignedListItem(
    JeevanaadiUser user,
    bool isSelected, {
    required bool isAdmin,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: isJeevanadiLead
            ? Checkbox(
                value: isSelected,
                onChanged: (value) {
                  context.read<JeevanaadiBloc>().add(
                    ToggleAssignedSelectionEvent(
                      user.id,
                    ), // also fix event name
                  );
                },
                activeColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            : const SizedBox(),

        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            if (user.jeevanaadiNo != null)
              Text(
                "Jeevanaadi No: ${user.jeevanaadiNo!}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            if (user.jeevanaadiNo != null && user.joinedDate != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  "||",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            if (user.joinedDate != null)
              Text(
                "Joined: ${user.joinedDate}",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
          ],
        ),
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
        leading: isJeevanadiLead
            ? Checkbox(
                value: isSelected,
                onChanged: (value) {
                  context.read<JeevanaadiBloc>().add(
                    ToggleUnassignedSelectionEvent(user.id),
                  );
                },
                activeColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            : const SizedBox(),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            if (user.jeevanaadiNo != null)
              Text(
                "Jeevanaadi No: ${user.jeevanaadiNo!}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            if (user.jeevanaadiNo != null && user.joinedDate != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  "||",
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            //const SizedBox(width: 8),
            if (user.joinedDate != null)
              Text(
                "Joined: ${user.joinedDate}",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedLoadMoreButton(JeevanaadiState state) {
    return SizedBox(
      width: 200,
      child: ElevatedButton.icon(
        // onPressed: state.assignedCurrentPage < state.assignedTotalPages - 1
        //     ? () {
        //         setState(() {
        //           _assignedPage = state.assignedCurrentPage + 1;
        //         });
        //         context.read<JeevanaadiBloc>().add(
        //           FetchAssignedKaryakarthasEvent(
        //             _selectedKaryakarthaId!,
        //             _assignedPage,
        //             10,
        //           ),
        //         );
        //       }
        //     : null,
        onPressed: state.assignedCurrentPage < state.assignedTotalPages - 1
            ? () {
                setState(() {
                  _assignedPage = state.assignedCurrentPage + 1;
                });
                final currentQuery = _assignedSearchController.text.trim();
                context.read<JeevanaadiBloc>().add(
                  FetchAssignedKaryakarthasEvent(
                    _selectedKaryakarthaId!,
                    _assignedPage,
                    10,
                    searchQuery: currentQuery.isNotEmpty ? currentQuery : null,
                    order: _assignedOrder,
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
        // onPressed: state.unassignedCurrentPage < state.unassignedTotalPages - 1
        //     ? () {
        //         setState(() {
        //           _unassignedPage = state.unassignedCurrentPage + 1;
        //         });
        //         context.read<JeevanaadiBloc>().add(
        //           FetchUnassignedKaryakarthasEvent(_unassignedPage),
        //         );
        //       }
        //     : null,
        onPressed: state.unassignedCurrentPage < state.unassignedTotalPages - 1
            ? () {
                setState(() {
                  _unassignedPage = state.unassignedCurrentPage + 1;
                });
                final currentQuery = _searchController.text.trim();
                context.read<JeevanaadiBloc>().add(
                  FetchUnassignedKaryakarthasEvent(
                    _unassignedPage,
                    10,
                    currentQuery.isNotEmpty ? currentQuery : null,
                    _unassignedOrder,
                  ),
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

  void _performUnassignedSearch() {
    setState(() {
      _unassignedPage = 0;
    });
    final query = _searchController.text.trim();
    context.read<JeevanaadiBloc>().add(
      FetchUnassignedKaryakarthasEvent(
        0,
        10,
        query.isNotEmpty ? query : null,
        _unassignedOrder,
      ),
    );
  }

  void _performAssignedSearch() {
    setState(() {
      _assignedPage = 0;
    });
    final query = _assignedSearchController.text.trim();
    context.read<JeevanaadiBloc>().add(
      FetchAssignedKaryakarthasEvent(
        _selectedKaryakarthaId!,
        0,
        10,
        searchQuery: query.isNotEmpty ? query : null,
        order: _assignedOrder,
      ),
    );
  }

  void _performKaryakarthaSearch() {
    final query = _karyakarthaSearchController.text.trim();
    context.read<KaryakarthaBloc>().add(
      FetchKaryakattasEvent(0, query.isNotEmpty ? query : null),
    );
  }

  void _refreshAssignedList({String? order}) {
    setState(() {
      _assignedPage = 0; // reset to first page
    });
    final query = _assignedSearchController.text.trim();
    context.read<JeevanaadiBloc>().add(
      FetchAssignedKaryakarthasEvent(
        _selectedKaryakarthaId!,
        0,
        10,
        searchQuery: query.isNotEmpty ? query : null,
        order: order, // ← new parameter
      ),
    );
  }

  void _refreshUnassignedList({String? order}) {
    setState(() {
      _unassignedPage = 0;
    });
    final query = _searchController.text.trim();
    context.read<JeevanaadiBloc>().add(
      FetchUnassignedKaryakarthasEvent(
        0,
        10,
        query.isNotEmpty ? query : null,
        _unassignedOrder,
      ),
    );
  }
}
