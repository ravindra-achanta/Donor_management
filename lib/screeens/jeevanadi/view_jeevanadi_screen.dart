import 'package:flutter/material.dart';
import 'package:vikas_app/screeens/common/common_list.dart';
import 'package:vikas_app/screeens/donations/DonationsListPage.dart';
import 'package:vikas_app/screeens/jeevanadi/edit_jeevanadi_screen.dart';
import 'package:vikas_app/screeens/models/response/user.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class ViewJeevanadiScreen extends StatelessWidget {
  final JeevanadiProfile? profile;
  final List<JeevanadiRelationship>? relationships;
  final List<JeevanadiOccasion>? occasions;

  ViewJeevanadiScreen({
    super.key,
    this.profile,
    this.relationships,
    this.occasions,
  });

  Map<String, dynamic> get _profileData {
    return profile?.toMap() ?? _defaultProfileData;
  }

  List<Map<String, String>> get _relationshipData {
    return relationships?.map((r) => r.toMap()).toList() ??
        _defaultRelationships;
  }

  List<Map<String, String>> get _occasionData {
    return occasions?.map((o) => o.toMap()).toList() ?? _defaultOccasions;
  }

  // Default data
  final Map<String, dynamic> _defaultProfileData = {
    'fullName': 'Sridurga Gudivada',
    'jeevanadiId': '4734',
    'joinedDate': '04-02-2026',
    'role': 'Donor',
    'referredCount': '0',
    'whatsappNumber': '9951317707',
    'dob': '10-07-1993',
    'maritalStatus': 'Married',
    'address': '102 block B Siddhivinayak Utopia plot no 191 Ulwe Navi Mumbai',
    'mobileNumber': '9951317707',
    'email': 'sridurgachanu@gmail.com',
    'gender': 'Female',
    'profession': 'Home Maker',
    'country': 'India',
    'profileCompletion': 75,
    'gothram': 'Kashyapa',
    'nakshatram': 'Rohini',
    'rashi': 'Vrishabha',
    'paadam': '2',
    'communication': 'WhatsApp',
    'panNumber': 'ABCDE1234F',
    'anniversary': '20-06-2018',
  };

  final List<Map<String, String>> _defaultRelationships = [
    {
      'name': 'Chanakya Gudivada',
      'relation': 'Husband',
      'dob': '29-11-1989',
      'mobileNumber': '8247368165',
      'nakshatram': 'Jyeshta',
      'rashi': 'Vrischika (Scorpio)',
      'paadam': '4',
    },
    {
      'name': 'Eeshan Karthikeya Gudivada',
      'relation': 'Son',
      'dob': '29-06-2019',
      'mobileNumber': '8247368165',
      'nakshatram': 'Krittika',
      'rashi': 'Mesha (Aries)',
      'paadam': '1',
    },
  ];

  final List<Map<String, String>> _defaultOccasions = [
    {'occasionName': 'Marriage', 'occasionDate': '20-06-2018'},
  ];

  List<User> users = [
    User(
      uniqueId: 'UID123',
      userType: "Admin",
      status: "ACTIVE",
      id: '1',
      name: 'John Doe',
      mobileNumber: '1234567890',
      email: 'john.doe@example.com',
    ),
    User(
      uniqueId: 'UID123',
      userType: "Admin",
      status: "ACTIVE",
      id: '1',
      name: 'John Doe',
      mobileNumber: '1234567890',
      email: 'john.doe@example.com',
    ),
    User(
      uniqueId: 'UID123',
      userType: "Admin",
      status: "ACTIVE",
      id: '1',
      name: 'John Doe',
      mobileNumber: '1234567890',
      email: 'john.doe@example.com',
    ),
    User(
      uniqueId: 'UID123',
      userType: "Admin",
      status: "ACTIVE",
      id: '1',
      name: 'John Doe',
      mobileNumber: '1234567890',
      email: 'john.doe@example.com',
    ),
    User(
      uniqueId: 'UID123',
      userType: "Admin",
      status: "ACTIVE",
      id: '1',
      name: 'John Doe',
      mobileNumber: '1234567890',
      email: 'john.doe@example.com',
    ),
    User(
      uniqueId: 'UID123',
      userType: "Admin",
      status: "ACTIVE",
      id: '1',
      name: 'John Doe',
      mobileNumber: '1234567890',
      email: 'john.doe@example.com',
    ),
    User(
      uniqueId: 'UID123',
      userType: "Admin",
      status: "ACTIVE",
      id: '1',
      name: 'John Doe',
      mobileNumber: '1234567890',
      email: 'john.doe@example.com',
    ),
    User(
      uniqueId: 'UID123',
      userType: "Admin",
      status: "ACTIVE",
      id: '1',
      name: 'John Doe',
      mobileNumber: '1234567890',
      email: 'john.doe@example.com',
    ),
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
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER ROW ----------
            _buildHeaderRow(context, _profileData),

            const SizedBox(height: 20),

            // ---------- JEEVANADI & CONTACT CONTAINER ----------
            _buildJeevanadiContactContainer(_profileData),

            const SizedBox(height: 20),

            // ---------- PERSONAL DETAILS CONTAINER ----------
            _buildPersonalDetailsContainer(_profileData),

            const SizedBox(height: 20),

            // ---------- RELATIONSHIPS TABLE ----------
            _buildRelationshipsTable(_relationshipData),

            const SizedBox(height: 20),

            // ---------- SPECIAL OCCASIONS TABLE ----------
            _buildOccasionsTable(_occasionData),

            const SizedBox(height: 20),

            Text(
            "Donations ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),

            CommonList(
              users: users,
              currentPage: 0,
              onUserTap: (user) {},
              onDelete: (user) {},
              onUpdate: (user) {},
              screenType: "DONATION",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(
    BuildContext context,
    Map<String, dynamic> profileData,
  ) {
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

          // CENTER: Profile Completion
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
                        value: (profileData['profileCompletion'] ?? 0) / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.brown,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${profileData['profileCompletion'] ?? 0}%",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT: Edit Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditJeevanadiScreen()),
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
          const SizedBox(width: 8),

          //  ElevatedButton.icon(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => DonationListPage()),
          //     );
          //   },
          //   icon: const Icon(Icons.edit, size: 16),
          //   label: const Text("donations"),
          //   style: ElevatedButton.styleFrom(
          //     elevation: 0,
          //     backgroundColor: Colors.brown,
          //     foregroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildJeevanadiContactContainer(Map<String, dynamic> profileData) {
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
                      profileData['fullName']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Jeevanadi ID",
                      profileData['jeevanadiId']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Joined Date",
                      profileData['joinedDate']?.toString() ?? 'N/A',
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
                      profileData['mobileNumber']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Email",
                      profileData['email']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "WhatsApp",
                      profileData['whatsappNumber']?.toString() ?? 'N/A',
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
                      profileData['role']?.toString() ?? 'Donor',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Referred By",
                      '${profileData['referredCount']?.toString() ?? '0'} Members',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Container()), // Empty for alignment
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsContainer(Map<String, dynamic> profileData) {
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
                      profileData['gender']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Marital Status",
                      profileData['maritalStatus']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Date of Birth",
                      profileData['dob']?.toString() ?? 'N/A',
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
                      profileData['profession']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Anniversary",
                      profileData['anniversary']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Country",
                      profileData['country']?.toString() ?? 'N/A',
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
                      profileData['gothram']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Nakshatram",
                      profileData['nakshatram']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Rashi",
                      profileData['rashi']?.toString() ?? 'N/A',
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
                      profileData['paadam']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "Communication",
                      profileData['communication']?.toString() ?? 'N/A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFieldItem(
                      "PAN Number",
                      profileData['panNumber']?.toString() ?? 'N/A',
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
                      profileData['address']?.toString() ?? 'N/A',
                    ),
                  ),
                ],
              ),

              // _buildFieldItem("Address", profileData['address']?.toString() ?? 'N/A', isMultiline: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipsTable(List<Map<String, String>> relationships) {
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
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (relationships.isEmpty)
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
                  DataColumn(label: Text("MOBILE")),
                  DataColumn(label: Text("NAKSHATRAM")),
                  DataColumn(label: Text("RASHI")),
                  DataColumn(label: Text("PAADAM")),
                ],
                rows: relationships.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final rel = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(rel['name'] ?? 'N/A')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getRelationColor(rel['relation']),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            rel['relation'] ?? 'N/A',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      DataCell(Text(rel['dob'] ?? 'N/A')),
                      DataCell(Text(rel['mobileNumber'] ?? 'N/A')),
                      DataCell(Text(rel['nakshatram'] ?? 'N/A')),
                      DataCell(Text(rel['rashi'] ?? 'N/A')),
                      DataCell(Text(rel['paadam'] ?? 'N/A')),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOccasionsTable(List<Map<String, String>> occasions) {
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
                "Occasions Details :",
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
                            Text(occ['occasionName'] ?? 'N/A'),
                          ],
                        ),
                      ),
                      DataCell(Text(occ['occasionDate'] ?? 'N/A')),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // Simple field item without decorative box
  Widget _buildFieldItem(
    String label,
    String value, {
    bool isMultiline = false,
  }) {
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
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: isMultiline ? 3 : 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Color _getRelationColor(String? relation) {
    switch (relation?.toLowerCase()) {
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
}

// ==================== DATA MODELS FOR API INTEGRATION ====================

class JeevanadiProfile {
  final String? fullName;
  final String? jeevanadiId;
  final String? joinedDate;
  final String? role;
  final int? referredCount;
  final String? whatsappNumber;
  final String? dob;
  final String? maritalStatus;
  final String? address;
  final String? mobileNumber;
  final String? email;
  final String? gender;
  final String? profession;
  final String? country;
  final int? profileCompletion;
  final String? gothram;
  final String? nakshatram;
  final String? rashi;
  final String? paadam;
  final String? communication;
  final String? panNumber;
  final String? anniversary;

  JeevanadiProfile({
    this.fullName,
    this.jeevanadiId,
    this.joinedDate,
    this.role,
    this.referredCount,
    this.whatsappNumber,
    this.dob,
    this.maritalStatus,
    this.address,
    this.mobileNumber,
    this.email,
    this.gender,
    this.profession,
    this.country,
    this.profileCompletion,
    this.gothram,
    this.nakshatram,
    this.rashi,
    this.paadam,
    this.communication,
    this.panNumber,
    this.anniversary,
  });

  factory JeevanadiProfile.fromJson(Map<String, dynamic> json) {
    return JeevanadiProfile(
      fullName: json['fullName'],
      jeevanadiId: json['jeevanadiId'],
      joinedDate: json['joinedDate'],
      role: json['role'],
      referredCount: json['referredCount'] as int?,
      whatsappNumber: json['whatsappNumber'],
      dob: json['dob'],
      maritalStatus: json['maritalStatus'],
      address: json['address'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      gender: json['gender'],
      profession: json['profession'],
      country: json['country'],
      profileCompletion: json['profileCompletion'] as int?,
      gothram: json['gothram'],
      nakshatram: json['nakshatram'],
      rashi: json['rashi'],
      paadam: json['paadam'],
      communication: json['communication'],
      panNumber: json['panNumber'],
      anniversary: json['anniversary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'jeevanadiId': jeevanadiId,
      'joinedDate': joinedDate,
      'role': role,
      'referredCount': referredCount,
      'whatsappNumber': whatsappNumber,
      'dob': dob,
      'maritalStatus': maritalStatus,
      'address': address,
      'mobileNumber': mobileNumber,
      'email': email,
      'gender': gender,
      'profession': profession,
      'country': country,
      'profileCompletion': profileCompletion,
      'gothram': gothram,
      'nakshatram': nakshatram,
      'rashi': rashi,
      'paadam': paadam,
      'communication': communication,
      'panNumber': panNumber,
      'anniversary': anniversary,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }
}

class JeevanadiRelationship {
  final String? name;
  final String? relation;
  final String? dob;
  final String? mobileNumber;
  final String? nakshatram;
  final String? rashi;
  final String? paadam;

  JeevanadiRelationship({
    this.name,
    this.relation,
    this.dob,
    this.mobileNumber,
    this.nakshatram,
    this.rashi,
    this.paadam,
  });

  factory JeevanadiRelationship.fromJson(Map<String, dynamic> json) {
    return JeevanadiRelationship(
      name: json['name'],
      relation: json['relation'],
      dob: json['dob'],
      mobileNumber: json['mobileNumber'],
      nakshatram: json['nakshatram'],
      rashi: json['rashi'],
      paadam: json['paadam'],
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name ?? '',
      'relation': relation ?? '',
      'dob': dob ?? '',
      'mobileNumber': mobileNumber ?? '',
      'nakshatram': nakshatram ?? '',
      'rashi': rashi ?? '',
      'paadam': paadam ?? '',
    };
  }
}

class JeevanadiOccasion {
  final String? occasionName;
  final String? occasionDate;

  JeevanadiOccasion({this.occasionName, this.occasionDate});

  factory JeevanadiOccasion.fromJson(Map<String, dynamic> json) {
    return JeevanadiOccasion(
      occasionName: json['occasionName'],
      occasionDate: json['occasionDate'],
    );
  }

  Map<String, String> toMap() {
    return {
      'occasionName': occasionName ?? '',
      'occasionDate': occasionDate ?? '',
    };
  }
}
