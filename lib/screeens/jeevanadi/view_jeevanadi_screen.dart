

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/jeevanadi/edit_jeevanadi_screen.dart';
import 'package:vikas_app/screeens/models/request/JeevanaadiFullProfile.dart';
import 'package:vikas_app/screeens/models/response/jeevanaadiView.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ViewJeevanadiScreen extends StatelessWidget {
  final String userId;

  const ViewJeevanadiScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    context.read<JeevanaadiBloc>().add(FetchJeevanaadiProfileFullEvent(userId));

    return Layout(
      child: BlocBuilder<JeevanaadiBloc, JeevanaadiState>(
        buildWhen: (previous, current) {
          return previous.jeevanaadiProfileFull != current.jeevanaadiProfileFull ||
              previous.profileLoading != current.profileLoading ||
              previous.profileErrorMsg != current.profileErrorMsg;
        },
        builder: (context, state) {
          if (state.profileLoading == true) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state.profileErrorMsg != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading profile',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.profileErrorMsg!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<JeevanaadiBloc>().add(
                              FetchJeevanaadiProfileFullEvent(userId),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profileFull = state.jeevanaadiProfileFull;
          
          if (profileFull == null) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- HEADER ROW ----------
                _buildHeaderRow(context, profileFull),

                const SizedBox(height: 20),

                // ---------- JEEVANADI & CONTACT CONTAINER ----------
                _buildJeevanadiContactContainer(profileFull),

                const SizedBox(height: 20),

                // ---------- PERSONAL DETAILS CONTAINER ----------
                _buildPersonalDetailsContainer(profileFull),

                const SizedBox(height: 20),

                // ---------- RELATIONSHIPS TABLE ----------
                _buildRelationshipsTable(profileFull.relationDetails),

                const SizedBox(height: 20),

                // ---------- SPECIAL OCCASIONS TABLE ----------
                _buildOccasionsTable(profileFull.occupationDetails != null 
                  ? [profileFull.occupationDetails!] 
                  : []),

                const SizedBox(height: 20),

                const Text(
                  "Donations ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),

                CommonList(
                  users: _getDummyUsers(),
                  currentPage: 0,
                  onUserTap: (user) {},
                  onDelete: (user) {},
                  onUpdate: (user) {},
                  screenType: "DONATION",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderRow(
  BuildContext context,
  JeevanaadiFullProfile profileFull,
) {
  final basicDetails = profileFull.basicDetails;
  final profileDetails = profileFull.profileDetails;
  final demoGraphic = profileFull.jeevanaadiDemoGraphicDetails; // Add this

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                context.read<JeevanaadiBloc>().add(CloseProfileView());
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 6),
            const Text(
              "PROFILE VIEW",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        Expanded(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Profile:",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 160,
                  height: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (demoGraphic.profileCompletionPercentage) / 100, // Use demoGraphic
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.brown,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${demoGraphic.profileCompletionPercentage.toStringAsFixed(1)}%", 
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditJeevanadiScreen(
          //profile: profileFull, 
         userId: userId,
        ),
      ),
    );
          },
          icon: const Icon(Icons.edit, size: 16),
          label: const Text("Edit"),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildJeevanadiContactContainer(JeevanaadiFullProfile profileFull) {
    final basicDetails = profileFull.basicDetails;
    final profileDetails = profileFull.profileDetails;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jeevanadi & Contact Details :",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 16),

          // ALL FIELDS IN 3 COLUMNS
          Column(
            children: [
              // Row 1
              Row(
                children: [
                  Expanded(
                    child: _buildFieldItem(
                      "Full Name",
                      profileDetails.fullName,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Jeevanadi ID",
                      basicDetails.jeevanadiNo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Joined Date",
                      profileDetails.joinedDate ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2
              Row(
                children: [
                  Expanded(
                    child: _buildFieldItem(
                      "Mobile Number",
                      profileDetails.phoneNumber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Email",
                      basicDetails.email,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "WhatsApp",
                      profileDetails.whatsappNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3
              Row(
                children: [
                  Expanded(
                    child: _buildFieldItem(
                      "Role",
                      profileDetails.userType,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Referred By",
                      profileDetails.referredByCustom ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Container()), 
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsContainer(JeevanaadiFullProfile profileFull) {
    final profileDetails = profileFull.profileDetails;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Personal Details :",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 16),

          // ALL FIELDS IN 3 COLUMNS
          Column(
            children: [
              // Row 1
              Row(
                children: [
                  Expanded(
                    child: _buildFieldItem(
                      "Gender",
                      profileDetails.gender ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Marital Status",
                      profileDetails.maritalStatus ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Date of Birth",
                      profileDetails.dateOfBirth ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2
              Row(
                children: [
                  Expanded(
                    child: _buildFieldItem(
                      "Profession",
                      profileDetails.profession ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Anniversary",
                      profileDetails.annivDate ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Country",
                      profileDetails.country ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3
              Row(
                children: [
                  Expanded(
                    child: _buildFieldItem(
                      "Gothram",
                      profileDetails.gothram ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Nakshatram",
                      profileDetails.nakshatram ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Rashi",
                      profileDetails.rashi?.toString() ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 4
              Row(
                children: [
                  Expanded(
                    child: _buildFieldItem(
                      "Paadam",
                      profileDetails.paadam?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Communication",
                      profileDetails.communicationPref ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "PAN Number",
                      profileDetails.panNumber ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFieldItem(
                      "Address",
                      profileDetails.address ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "City",
                      profileDetails.city ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "State",
                      profileDetails.state ?? 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFieldItem(
                      "Pincode",
                      profileDetails.pincode ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Profile ID",
                      profileDetails.id.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Container()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipsTable(List<RelationDetails> relations) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Relationships :",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${relations.length}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (relations.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "No relationships added",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                dataRowHeight: 40,
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 12,
                ),
                dataTextStyle: const TextStyle(fontSize: 12),
                columnSpacing: 20,
                horizontalMargin: 12,
                headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
                columns: const [
                  DataColumn(label: Text("#"), numeric: true),
                  DataColumn(label: Text("NAME")),
                  DataColumn(label: Text("RELATION")),
                  DataColumn(label: Text("DOB")),
                ],
                rows: relations.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final rel = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(rel.name)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getRelationColor(rel.relation),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            rel.relation,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      DataCell(Text(rel.dob ?? 'N/A')),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOccasionsTable(List<OccupationDetails> occasions) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Auspicious Family Occasions :",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${occasions.length}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (occasions.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "No occasions added",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                dataRowHeight: 40,
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 12,
                ),
                dataTextStyle: const TextStyle(fontSize: 12),
                columnSpacing: 20,
                horizontalMargin: 12,
                headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
                columns: const [
                  DataColumn(label: Text("#"), numeric: true),
                  DataColumn(label: Text("OCCASION NAME")),
                  DataColumn(label: Text("OCCASION DATE")),
                ],
                rows: occasions.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final occ = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(index.toString())),
                      DataCell(
                        Row(
                          children: [
                            Icon(
                              Icons.celebration,
                              size: 14,
                              color: Colors.purple.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(occ.occName),
                          ],
                        ),
                      ),
                      DataCell(Text(occ.occDate)),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFieldItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isNotEmpty ? value : 'N/A',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Color _getRelationColor(String relation) {
    switch (relation.toLowerCase()) {
      case 'husband':
      case 'wife':
        return Colors.pink.shade50;
      case 'son':
      case 'daughter':
        return Colors.blue.shade50;
      case 'father':
      case 'mother':
        return Colors.green.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  List<User> _getDummyUsers() {
    return [
      User(
        uniqueId: 'UID123',
        userType: "Admin",
        status: "ACTIVE",
        id: '1',
        name: 'John Doe',
        mobileNumber: '1234567890',
        email: 'john.doe@example.com',
      ),
    ];
  }
}