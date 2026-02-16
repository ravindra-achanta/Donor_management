import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/styles/text_style.dart';
import 'package:flutx/widgets/breadcrumb/breadcrumb.dart';
import 'package:flutx/widgets/breadcrumb/breadcrumb_item.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/common/backButton.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class KaryaKarthaViewScreen extends StatefulWidget {
  final String memberId;
  

  const KaryaKarthaViewScreen({super.key, required this.memberId});

  @override
  State<KaryaKarthaViewScreen> createState() => _KaryaKarthaViewScreenState();
}

class _KaryaKarthaViewScreenState extends State<KaryaKarthaViewScreen> {
  int _unassignedPage = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<JeevanaadiBloc>().add(
      FetchJeevanadiMemberEvent(widget.memberId),
    );
    context.read<JeevanaadiBloc>().add(
      FetchAssignedKaryakarthasEvent(widget.memberId),
    );
    context.read<JeevanaadiBloc>().add(
      FetchUnassignedKaryakarthasEvent(0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocListener<JeevanaadiBloc, JeevanaadiState>(
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
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        FxText.headlineSmall(
                          'Error loading data',
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        FxText.bodyMedium(
                          state.errorMessage ?? 'Unknown error occurred',
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadData,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: FxText.labelMedium('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final member = state.jeevanadiMember;

                return Container(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Backbutton().buildBackButton(context, "Karyakartha List"),
                      const SizedBox(height: 20),

                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.blue.shade700,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    FxText.labelMedium(
                                      "karyakatha  Details",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                if (member != null)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade50,
                                          Colors.indigo.shade50,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.blue.shade100,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                    ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      child: FxText.labelMedium(
                                                        'JN-ID:',
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 700,
                                                              color: Colors
                                                                  .blue
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FxText.bodyMedium(
                                                        member.id,
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 600,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                    ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      child: FxText.labelMedium(
                                                        'Name:',
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 700,
                                                              color: Colors
                                                                  .blue
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FxText.bodyMedium(
                                                        member.name,
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 600,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                    ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      child: FxText.labelMedium(
                                                        'Mobile:',
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 700,
                                                              color: Colors
                                                                  .blue
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FxText.bodyMedium(
                                                        member.mobile,
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 600,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                    ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      child: FxText.labelMedium(
                                                        'Gothram:',
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 700,
                                                              color: Colors
                                                                  .blue
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FxText.bodyMedium(
                                                        member.gothram,
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 600,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                    ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      child: FxText.labelMedium(
                                                        'Email:',
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 700,
                                                              color: Colors
                                                                  .blue
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FxText.bodyMedium(
                                                        member.email,
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 600,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                    ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      child: FxText.labelMedium(
                                                        'Role:',
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 700,
                                                              color: Colors
                                                                  .blue
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FxText.bodyMedium(
                                                        member.role,
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 600,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                    ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      child: FxText.labelMedium(
                                                        'Joined:',
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 700,
                                                              color: Colors
                                                                  .blue
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FxText.bodyMedium(
                                                        member.joined,
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 600,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                    ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 100,
                                                      child: FxText.labelMedium(
                                                        'Referred By:',
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 700,
                                                              color: Colors
                                                                  .blue
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: FxText.bodyMedium(
                                                        member.referredBy,
                                                        style:
                                                            FxTextStyle.labelMedium(
                                                              fontWeight: 600,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Main Content
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.width > 1200
                                ? 120
                                : 180),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left side - Assigned Karyakarthas (40%)
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width > 1200
                                      ? 20
                                      : 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.people,
                                            color: Colors.green.shade700,
                                            size: 22,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        FxText.bodyMedium(
                                          "Assigned Jeevanadi members",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width >
                                              1200
                                          ? 16
                                          : 12,
                                    ),
                                    Expanded(
                                      child: state.isRemoving
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : state.assignedKaryakarthas.isEmpty
                                          ? Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.person_off,
                                                    color: Colors.grey.shade400,
                                                    size: 56,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  FxText.bodyMedium(
                                                    'No assigned jeevanadi members',
                                                    style:
                                                        FxTextStyle.bodyMedium(
                                                          color: Colors
                                                              .grey
                                                              .shade600,
                                                          fontSize: 16,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width >
                                                            1200
                                                        ? 4
                                                        : 3,
                                                    crossAxisSpacing:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width >
                                                            1200
                                                        ? 10
                                                        : 8,
                                                    mainAxisSpacing:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width >
                                                            1200
                                                        ? 10
                                                        : 8,
                                                    childAspectRatio:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width >
                                                            1200
                                                        ? 0.75
                                                        : 0.8,
                                                  ),
                                              itemCount: state
                                                  .assignedKaryakarthas
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final user = state
                                                    .assignedKaryakarthas[index];
                                                return Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                3,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .blue
                                                                .shade50,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  35,
                                                                ),
                                                          ),
                                                          child: CircleAvatar(
                                                            radius: 28,
                                                            backgroundColor:
                                                                Colors
                                                                    .blue
                                                                    .shade100,
                                                            child: Icon(
                                                              Icons.person,
                                                              color: Colors
                                                                  .blue
                                                                  .shade800,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: -3,
                                                          top: -3,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              context
                                                                  .read<
                                                                    JeevanaadiBloc
                                                                  >()
                                                                  .add(
                                                                    RemoveAssignedKaryakarthaEvent(
                                                                      widget
                                                                          .memberId,
                                                                      user.id,
                                                                    ),
                                                                  );
                                                            },
                                                            child: Container(
                                                              width: 26,
                                                              height: 26,
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .red
                                                                    .shade500,
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 3,
                                                                ),
                                                              ),
                                                              child: const Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    SizedBox(
                                                      width: 80,
                                                      child: FxText.bodyMedium(
                                                        user.name,
                                                        style:
                                                            FxTextStyle.bodyMedium(
                                                              fontSize: 12,
                                                              fontWeight: 600,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),

                            // Right side - Unassigned Karyakarthas (40%)
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.person_add,
                                                color: Colors.orange.shade700,
                                                size: 22,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            FxText.bodyMedium(
                                              "Unassigned jeevanadi members",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        if (state
                                            .selectedUnassignedIds
                                            .isNotEmpty)
                                          ElevatedButton.icon(
                                            onPressed: state.isAssigning
                                                ? null
                                                : () {
                                                    context
                                                        .read<JeevanaadiBloc>()
                                                        .add(
                                                          AssignSelectedKaryakarthasEvent(
                                                            widget.memberId,
                                                          ),
                                                        );
                                                  },
                                            icon: state.isAssigning
                                                ? const SizedBox(
                                                    width: 18,
                                                    height: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                : const Icon(
                                                    Icons.add,
                                                    size: 20,
                                                  ),
                                            label: FxText.bodyMedium(
                                              state.isAssigning
                                                  ? 'Adding...'
                                                  : 'Add members',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.green.shade600,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              elevation: 3,
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width >
                                              1200
                                          ? 16
                                          : 12,
                                    ),
                                    Expanded(
                                      child:
                                          state.unassignedKaryakarthas.isEmpty
                                          ? Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.person_off,
                                                    color: Colors.grey.shade400,
                                                    size: 56,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  FxText.bodyMedium(
                                                    'No unassigned karyakarthas available',
                                                    style:
                                                        FxTextStyle.bodyMedium(
                                                          color: Colors
                                                              .grey
                                                              .shade600,
                                                          fontSize: 16,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width >
                                                            1200
                                                        ? 4
                                                        : 3,
                                                    crossAxisSpacing:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width >
                                                            1200
                                                        ? 10
                                                        : 8,
                                                    mainAxisSpacing:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width >
                                                            1200
                                                        ? 10
                                                        : 8,
                                                    childAspectRatio:
                                                        MediaQuery.of(
                                                              context,
                                                            ).size.width >
                                                            1200
                                                        ? 0.75
                                                        : 0.8,
                                                  ),
                                              itemCount: state
                                                  .unassignedKaryakarthas
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final user = state
                                                    .unassignedKaryakarthas[index];
                                                final isSelected = state
                                                    .selectedUnassignedIds
                                                    .contains(user.id);
                                                return GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<JeevanaadiBloc>()
                                                        .add(
                                                          ToggleUnassignedSelectionEvent(
                                                            user.id,
                                                          ),
                                                        );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  2,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color: isSelected
                                                                  ? Colors
                                                                        .blue
                                                                        .shade50
                                                                  : Colors
                                                                        .grey
                                                                        .shade50,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    30,
                                                                  ),
                                                              border: isSelected
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .blue
                                                                          .shade200,
                                                                      width: 2,
                                                                    )
                                                                  : null,
                                                              boxShadow:
                                                                  isSelected
                                                                  ? [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .blue
                                                                            .withOpacity(
                                                                              0.3,
                                                                            ),
                                                                        blurRadius:
                                                                            8,
                                                                        offset:
                                                                            const Offset(
                                                                              0,
                                                                              2,
                                                                            ),
                                                                      ),
                                                                    ]
                                                                  : [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                              0.1,
                                                                            ),
                                                                        blurRadius:
                                                                            4,
                                                                        offset:
                                                                            const Offset(
                                                                              0,
                                                                              2,
                                                                            ),
                                                                      ),
                                                                    ],
                                                            ),
                                                            child: CircleAvatar(
                                                              radius: 24,
                                                              backgroundColor:
                                                                  isSelected
                                                                  ? Colors
                                                                        .blue
                                                                        .shade200
                                                                  : Colors
                                                                        .grey
                                                                        .shade200,
                                                              child: Icon(
                                                                Icons.person,
                                                                color:
                                                                    isSelected
                                                                    ? Colors
                                                                          .blue
                                                                          .shade800
                                                                    : Colors
                                                                          .grey
                                                                          .shade600,
                                                                size: 26,
                                                              ),
                                                            ),
                                                          ),
                                                          if (isSelected)
                                                            Positioned(
                                                              right: -2,
                                                              top: -2,
                                                              child: Container(
                                                                width: 22,
                                                                height: 22,
                                                                decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 3,
                                                                  ),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .green
                                                                          .withOpacity(
                                                                            0.3,
                                                                          ),
                                                                      blurRadius:
                                                                          4,
                                                                      offset:
                                                                          const Offset(
                                                                            0,
                                                                            2,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: const Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 6),
                                                      SizedBox(
                                                        width: 70,
                                                        child: FxText.bodyMedium(
                                                          user.name,
                                                          style: FxTextStyle.bodyMedium(
                                                            fontSize: 11,
                                                            fontWeight: 600,
                                                            color: isSelected
                                                                ? Colors
                                                                      .blue
                                                                      .shade800
                                                                : Colors.black,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                    const SizedBox(height: 16),
SizedBox(
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
      backgroundColor: state.unassignedCurrentPage < state.unassignedTotalPages - 1
          ? Colors.orange.shade600
          : Colors.grey.shade400,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
    ),
  ),
),
                                    // SizedBox(
                                    //   width: 200,
                                    //   child: ElevatedButton.icon(
                                    //     onPressed: () {
                                    //       _unassignedPage++;
                                    //       context.read<JeevanaadiBloc>().add(
                                    //         FetchUnassignedKaryakarthasEvent(
                                    //           _unassignedPage,
                                    //         ),
                                    //       );
                                    //     },
                                    //     icon: const Icon(
                                    //       Icons.arrow_downward,
                                    //       size: 18,
                                    //     ),
                                    //     label: FxText.labelMedium('Load More'),
                                    //     style: ElevatedButton.styleFrom(
                                    //       backgroundColor:
                                    //           Colors.orange.shade600,
                                    //       foregroundColor: Colors.white,
                                    //       padding: const EdgeInsets.symmetric(
                                    //         horizontal: 16,
                                    //         vertical: 10,
                                    //       ),
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(
                                    //           8,
                                    //         ),
                                    //       ),
                                    //       elevation: 3,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
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
        ),
      ),
    );
  }
}
