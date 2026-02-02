import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class AssignMembersPage extends StatefulWidget {
  const AssignMembersPage({super.key});

  @override
  State<AssignMembersPage> createState() => _AssignMembersPageState();
}

class _AssignMembersPageState extends State<AssignMembersPage> {
  // Sample data
  final List<Karyakarta> _karyakartas = [
    Karyakarta(
      id: 'KA-001',
      name: 'Ramesh Sharma',
      mobile: '9876543210',
      status: true,
      assignedMembers: 3,
    ),
    Karyakarta(
      id: 'KA-002',
      name: 'Suresh Reddy',
      mobile: '8765432109',
      status: true,
      assignedMembers: 1,
    ),
    Karyakarta(
      id: 'KA-003',
      name: 'Anil Khan',
      mobile: '7654321098',
      status: true,
      assignedMembers: 0,
    ),
  ];

  final List<JeevanadiMember> _allMembers = [
    JeevanadiMember(
      id: 'JN-1001',
      name: 'Arun Kumar',
      mobile: '9876543210',
      status: true,
      assignedKaryakarta: 'KA-001',
    ),
    JeevanadiMember(
      id: 'JN-1002',
      name: 'Meena Patel',
      mobile: '8765432109',
      status: true,
      assignedKaryakarta: 'KA-001',
    ),
    JeevanadiMember(
      id: 'JN-1003',
      name: 'Suresh Raina',
      mobile: '7654321098',
      status: true,
      assignedKaryakarta: 'KA-001',
    ),
    JeevanadiMember(
      id: 'JN-1004',
      name: 'Priya Singh',
      mobile: '6543210987',
      status: true,
      assignedKaryakarta: '',
    ),
    JeevanadiMember(
      id: 'JN-1005',
      name: 'Rajesh Kumar',
      mobile: '5432109876',
      status: true,
      assignedKaryakarta: '',
    ),
    JeevanadiMember(
      id: 'JN-1006',
      name: 'Anjali Sharma',
      mobile: '4321098765',
      status: true,
      assignedKaryakarta: 'KA-002',
    ),
  ];

  String? _selectedKaryakartaId;
  final Set<String> _selectedMemberIds = {};

  // Get selected karyakarta
  Karyakarta? get _selectedKaryakarta {
    if (_selectedKaryakartaId == null) return null;
    try {
      return _karyakartas.firstWhere((k) => k.id == _selectedKaryakartaId);
    } catch (e) {
      return null;
    }
  }

  // Get available members (not assigned or assigned to selected karyakarta)
  List<JeevanadiMember> get _availableMembers {
    return _allMembers.where((member) {
      return member.assignedKaryakarta.isEmpty || 
             member.assignedKaryakarta == _selectedKaryakartaId;
    }).toList();
  }

  // Get assigned members for selected karyakarta
  List<JeevanadiMember> get _assignedMembers {
    if (_selectedKaryakartaId == null) return [];
    return _allMembers
        .where((member) => member.assignedKaryakarta == _selectedKaryakartaId)
        .toList();
  }

  // Get selected members count
  int get _selectedCount => _selectedMemberIds.length;

  // Assign selected members to karyakarta
  void _assignSelectedMembers() {
    if (_selectedKaryakartaId == null || _selectedMemberIds.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select both Karyakarta and at least one Member',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      for (var memberId in _selectedMemberIds) {
        final memberIndex = _allMembers.indexWhere((m) => m.id == memberId);
        if (memberIndex != -1) {
          _allMembers[memberIndex] = _allMembers[memberIndex].copyWith(
            assignedKaryakarta: _selectedKaryakartaId!,
          );
        }
      }
      _selectedMemberIds.clear();
    });

    Get.snackbar(
      'Success',
      '${_selectedCount} member(s) assigned successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Remove member assignment
  void _removeAssignment(String memberId) {
    Get.defaultDialog(
      title: 'Remove Assignment',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: 'Are you sure you want to remove this member?',
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        setState(() {
          final memberIndex = _allMembers.indexWhere((m) => m.id == memberId);
          if (memberIndex != -1) {
            _allMembers[memberIndex] = _allMembers[memberIndex].copyWith(
              assignedKaryakarta: '',
            );
          }
        });
        Get.back();
        Get.snackbar(
          'Success',
          'Member removed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  // Toggle select all available members
  void _toggleSelectAllAvailable() {
    setState(() {
      if (_selectedMemberIds.length == _availableMembers.length) {
        _selectedMemberIds.clear();
      } else {
        _selectedMemberIds.addAll(_availableMembers.map((m) => m.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Assign Members to Karyakarta",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  if (_selectedKaryakarta != null)
                    Chip(
                      label: Text(
                        'Assigned: ${_assignedMembers.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              /// ================= TWO DROPDOWNS IN SAME LINE =================
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ASSIGN MEMBERS TO KARYAKARTHA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Two dropdowns in same line
                      Row(
                        children: [
                          // Karyakarta Dropdown - FIXED TEXT OVERFLOW
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Karyakarta',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dropdownMenuTheme: DropdownMenuThemeData(
                                        inputDecorationTheme: InputDecorationTheme(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      value: _selectedKaryakartaId,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      icon: const Icon(Icons.arrow_drop_down, size: 30, color: Colors.black),
                                      hint: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          '-- Select Karyakarta --',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      dropdownColor: Colors.white,
                                      items: _karyakartas.map((karyakarta) {
                                        return DropdownMenuItem<String>(
                                          value: karyakarta.id,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 12,
                                            ),
                                            child: Text(
                                              karyakarta.name,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      selectedItemBuilder: (BuildContext context) {
                                        return _karyakartas.map<Widget>((karyakarta) {
                                          return Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _selectedKaryakartaId == karyakarta.id
                                                  ? karyakarta.name
                                                  : '',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList();
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedKaryakartaId = value;
                                          _selectedMemberIds.clear();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 20),
                          
                          // Members Dropdown with checkboxes - FIXED TEXT OVERFLOW
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Available Members',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dropdownMenuTheme: DropdownMenuThemeData(
                                        inputDecorationTheme: InputDecorationTheme(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintStyle: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      value: null,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      icon: const Icon(Icons.arrow_drop_down, size: 30, color: Colors.black),
                                      hint: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _selectedCount > 0
                                                    ? '$_selectedCount selected'
                                                    : '-- Select Members --',
                                                style: TextStyle(
                                                  color: _selectedCount > 0
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  fontWeight: _selectedCount > 0
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (_selectedCount > 0)
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[50],
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '$_selectedCount',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      dropdownColor: Colors.white,
                                      items: [
                                        // First item for "Select All"
                                        DropdownMenuItem<String>(
                                          value: 'select_all',
                                          child: SizedBox(
                                            height: 48,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value: _selectedMemberIds.length ==
                                                        _availableMembers.length &&
                                                        _availableMembers.isNotEmpty,
                                                    onChanged: (_) =>
                                                        _toggleSelectAllAvailable(),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Text(
                                                    'Select All',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const DropdownMenuItem<String>(
                                          value: 'divider',
                                          enabled: false,
                                          child: Divider(height: 1, color: Colors.grey),
                                        ),
                                        // Member items
                                        ..._availableMembers.map((member) {
                                          final isSelected =
                                              _selectedMemberIds.contains(member.id);

                                          return DropdownMenuItem<String>(
                                            value: member.id,
                                            child: SizedBox(
                                              height: 48,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      value: isSelected,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (value == true) {
                                                            _selectedMemberIds.add(member.id);
                                                          } else {
                                                            _selectedMemberIds.remove(member.id);
                                                          }
                                                        });
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        member.name,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                      selectedItemBuilder: (BuildContext context) {
                                        return [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _selectedCount > 0
                                                  ? '$_selectedCount selected'
                                                  : '-- Select Members --',
                                              style: TextStyle(
                                                color: _selectedCount > 0
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                fontWeight: _selectedCount > 0
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ];
                                      },
                                      onChanged: (value) {
                                        if (value == 'select_all') {
                                          _toggleSelectAllAvailable();
                                        } else if (value != null && value != 'divider') {
                                          setState(() {
                                            if (_selectedMemberIds.contains(value)) {
                                              _selectedMemberIds.remove(value);
                                            } else {
                                              _selectedMemberIds.add(value);
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Assign Button - Centered below dropdowns
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _selectedCount > 0 && _selectedKaryakartaId != null
                              ? _assignSelectedMembers
                              : null,
                          icon: const Icon(Icons.link, size: 20),
                          label: Text(
                            _selectedCount > 0
                                ? 'ASSIGN $_selectedCount MEMBER(S)'
                                : 'ASSIGN MEMBERS',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              /// ================= ASSIGNED MEMBERS SECTION =================
              if (_selectedKaryakarta != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'MEMBERS ASSIGNED TO: ${_selectedKaryakarta!.name.toUpperCase()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 28, 109, 202),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'COUNT: ${_assignedMembers.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Assigned Members Table with constraints
                        if (_assignedMembers.isNotEmpty)
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.4,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowHeight: 48,
                                  dataRowHeight: 56,
                                  headingRowColor:
                                      MaterialStateProperty.all(Colors.grey.shade200),
                                  columnSpacing: 32,
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        'JN-ID',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'MEMBER NAME',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'MOBILE',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'STATUS',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'ACTIONS',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  rows: _assignedMembers.map((member) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            member.id,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              member.name.toUpperCase(),
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              member.mobile,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: member.status
                                                  ? Colors.green[100]
                                                  : Colors.red[100],
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: member.status
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                            child: Text(
                                              member.status ? 'ACTIVE' : 'INACTIVE',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: member.status
                                                    ? Colors.green[800]
                                                    : Colors.red[800],
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          IconButton(
                                            onPressed: () => _removeAssignment(member.id),
                                            icon: const Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                              size: 24,
                                            ),
                                            tooltip: 'Remove Assignment',
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No members assigned to ${_selectedKaryakarta!.name} yet',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              
              if (_selectedKaryakarta == null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    constraints: BoxConstraints(
                      minHeight: 200,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Select a Karyakarta to begin',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Choose a Karyakarta and members to assign',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 20),

           
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= MODELS =================
class Karyakarta {
  final String id;
  final String name;
  final String mobile;
  final bool status;
  final int assignedMembers;

  Karyakarta({
    required this.id,
    required this.name,
    required this.mobile,
    required this.status,
    required this.assignedMembers,
  });
}

class JeevanadiMember {
  final String id;
  final String name;
  final String mobile;
  final bool status;
  final String assignedKaryakarta;

  JeevanadiMember({
    required this.id,
    required this.name,
    required this.mobile,
    required this.status,
    required this.assignedKaryakarta,
  });

  JeevanadiMember copyWith({
    String? assignedKaryakarta,
  }) {
    return JeevanadiMember(
      id: id,
      name: name,
      mobile: mobile,
      status: status,
      assignedKaryakarta: assignedKaryakarta ?? this.assignedKaryakarta,
    );
  }
}