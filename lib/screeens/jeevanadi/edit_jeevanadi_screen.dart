import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_bloc.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_event.dart';
import 'package:vikas_app/bloc_management/jeevanadi/jeevanadi_state.dart';
import 'package:vikas_app/screeens/common/DropdownService.dart';
import 'package:vikas_app/screeens/common/referred_by_dropdown.dart';
import 'package:vikas_app/screeens/models/request/JeevanaadiFullProfile.dart';
import 'package:vikas_app/views/layouts/layout.dart';
import 'package:vikas_app/screeens/models/response/jeevanadi_member.dart';

class EditJeevanadiScreen extends StatefulWidget {
  final String userId;
  final bool isFromRequest;
  final String? jeevanadiId;

  const EditJeevanadiScreen({
    super.key,
    required this.userId,
    this.isFromRequest = false,
    this.jeevanadiId,
  });

  @override
  State<EditJeevanadiScreen> createState() => _EditJeevanadiScreenState();
}

class _EditJeevanadiScreenState extends State<EditJeevanadiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownService = DropdownService();
  bool _isUpdateInProgress = false;
  bool _isActive = true;
  String _status = 'ACTIVE';

  final TextEditingController _referredBySearchController =
      TextEditingController();
  Map<String, dynamic>? _selectedReferredBy;

  // Controllers
  late final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'dob': TextEditingController(),
    'profession': TextEditingController(),
    'anniversary': TextEditingController(),
    'gothram': TextEditingController(),
    'pan': TextEditingController(),
    'referredBy': TextEditingController(),
    'jeevanadiId': TextEditingController(),
    'doj': TextEditingController(),
    'mobile': TextEditingController(),
    'email': TextEditingController(),
    'whatsapp': TextEditingController(),
    'address': TextEditingController(),
  };

  // Dropdown values
  late final Map<String, dynamic> _dropdownValues = {
    'gender': 'Male',
    'maritalStatus': 'Single',
    'nakshatram': '',
    'rashi': 'Mesha',
    'paadam': 'Paadam 1',
    'communication': 'WhatsApp',
    'role': '',
  };

  bool _sameAsMobile = false;
  List<Map<String, dynamic>> _relationships = [];
  //List<Map<String, dynamic>> _occasions = [];
  List<Map<String, dynamic>> _occasions = <Map<String, dynamic>>[];

  // Getters for controllers
  TextEditingController get _nameCtrl => _controllers['name']!;
  TextEditingController get _dobCtrl => _controllers['dob']!;
  TextEditingController get _professionCtrl => _controllers['profession']!;
  TextEditingController get _anniversaryCtrl => _controllers['anniversary']!;
  TextEditingController get _gothramCtrl => _controllers['gothram']!;
  TextEditingController get _panCtrl => _controllers['pan']!;
  TextEditingController get _referredByCtrl => _controllers['referredBy']!;
  TextEditingController get _jeevanadiIdCtrl => _controllers['jeevanadiId']!;
  TextEditingController get _dojCtrl => _controllers['doj']!;
  TextEditingController get _mobileCtrl => _controllers['mobile']!;
  TextEditingController get _emailCtrl => _controllers['email']!;
  TextEditingController get _whatsappCtrl => _controllers['whatsapp']!;
  TextEditingController get _addressCtrl => _controllers['address']!;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  void _fetchProfileData() {
    if (widget.isFromRequest && widget.jeevanadiId != null) {
      context.read<JeevanaadiBloc>().add(
        FetchJeevanaadiProfileFromRequestEvent(widget.jeevanadiId!),
      );
    } else {
      context.read<JeevanaadiBloc>().add(
        FetchJeevanaadiProfileFullEvent(widget.userId),
      );
    }
  }

  // void _fetchMembersForSuggestions() {
  //   context.read<JeevanaadiBloc>().add(FetchJeevanaadisEvent(0));
  // }

  void _populateControllers(JeevanaadiFullProfile profile) {
    try {
      _nameCtrl.text = profile.profileDetails.fullName;
      _dobCtrl.text = profile.profileDetails.dateOfBirth ?? '';

      _dropdownValues
        ..['gender'] = _dropdownService.getGenderValueFromCode(
          profile.profileDetails.gender,
        )
        ..['maritalStatus'] = _dropdownService.getMaritalStatusValueFromCode(
          profile.profileDetails.maritalStatus,
        )
        ..['nakshatram'] = _dropdownService.getNakshatraValue(
          profile.profileDetails.nakshatram,
        )
        ..['rashi'] = _dropdownService.getRashiNameFromId(
          profile.profileDetails.rashi,
        )
        ..['paadam'] = _dropdownService.getPaadamValueFromNumber(
          profile.profileDetails.paadam,
        )
        ..['communication'] = _dropdownService
            .getCommunicationModeValueFromCode(
              profile.profileDetails.communicationPref,
            );

      _professionCtrl.text = profile.profileDetails.profession ?? '';
      _anniversaryCtrl.text = profile.profileDetails.annivDate ?? '';
      _gothramCtrl.text = profile.profileDetails.gothram ?? '';
      _panCtrl.text = profile.profileDetails.panNumber ?? '';
      _dropdownValues['role'] = profile.profileDetails.userType;

      if (profile.profileDetails.referredByCustom?.isNotEmpty == true) {
        // Case 1: Manual custom entry
        _referredByCtrl.text = profile.profileDetails.referredByCustom ?? '';
        _referredBySearchController.text =
            profile.profileDetails.referredByCustom ?? '';

        _selectedReferredBy = {
          'id': '0',
          'userName': profile.profileDetails.referredByCustom,
          'jeevanaadiNo': '',
          'isManual': true,
        };
      } else if (profile.profileDetails.referredById != null &&
          profile.profileDetails.referredById != 0) {
        _selectedReferredBy = {
          'id': profile.profileDetails.referredById.toString(),
          'userName': profile.profileDetails.referredById
              .toString(), // The member ID
          'jeevanaadiNo': '',
          'isManual': false,
        };
        _referredBySearchController.text = profile.profileDetails.referredById
            .toString();
        _referredByCtrl.text = profile.profileDetails.referredById.toString();
      } else {
        // Case 3: No referral
        _selectedReferredBy = null;
        _referredByCtrl.text = '';
        _referredBySearchController.text = '';
      }

      _jeevanadiIdCtrl.text = profile.basicDetails.id.toString();
      _dojCtrl.text = profile.profileDetails.joinedDate ?? '';

      _mobileCtrl.text = profile.profileDetails.phoneNumber;
      _emailCtrl.text = profile.basicDetails.email;
      _whatsappCtrl.text = profile.profileDetails.whatsappNumber;
      _sameAsMobile = _whatsappCtrl.text == _mobileCtrl.text;

      _addressCtrl.text = profile.profileDetails.address ?? '';

      _relationships = profile.relationDetails.map((rel) {
        return {
          "id": rel.id?.toString() ?? "",
          "relation": rel.relation ?? "",
          "name": rel.name ?? "",
          "mobile": rel.mobilenum ?? "",
          "dob": rel.dob ?? "",
          "nakshatram":
              _dropdownService.getNakshatraValue(rel.nakshatramRel) ?? "",
          "rashi": _dropdownService.getRashiNameFromId(rel.rashiRel) ?? "",
          "paadam":
              _dropdownService.getPaadamValueFromNumber(rel.paadamRel) ?? "",
        };
      }).toList();
      //.cast<Map<String, String>>();

      // _occasions = profile.occupationDetails != null
      //     ? [
      //         {
      //           "id": profile.occupationDetails.id?.toString() ?? "",
      //           "name": profile.occupationDetails.occName ?? "",
      //           "date": profile.occupationDetails.occDate ?? "",
      //         },
      //       ]
      //     : [];
      _occasions = profile.occasionsDetails
          .where((occ) => occ != null)
          .map(
            (occ) => <String, dynamic>{
              "id": occ!.id.toString(),
              "name": occ.occName,
              "date": occ.occDate,
              "uniqueId": occ.id.toString(),
            },
          )
          .toList();
      _isActive = profile.basicDetails.isActive;
      _status = _isActive ? 'ACTIVE' : 'INACTIVE';

      print('Data loaded successfully');
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      controller.text = DateFormat("yyyy-MM-dd").format(date);
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUpdateInProgress = true);

    int referredById = 0;
    String? referredByCustom;

    if (_selectedReferredBy != null) {
      if (_selectedReferredBy!['isManual'] == true) {
        referredByCustom = _selectedReferredBy!['userName'] ?? '';
      } else {
        referredById =
            int.tryParse(_selectedReferredBy!['id']?.toString() ?? '0') ?? 0;
        referredByCustom = "";
      }
    }

    final requestData = {
      "fullName": _nameCtrl.text,

      "dob": _dobCtrl.text.isEmpty ? null : _dobCtrl.text,
      "gender": _dropdownService.getGenderCodeFromValue(
        _dropdownValues['gender'],
      ),

      "materialStatus":
          _dropdownService
                  .getMaritalStatusCodeFromValue(
                    _dropdownValues['materialStatus'],
                  )
                  ?.isEmpty ==
              true
          ? ""
          : _dropdownService.getMaritalStatusCodeFromValue(
              _dropdownValues['materialStatus'],
            ),
      "profession": _professionCtrl.text.isEmpty ? "" : _professionCtrl.text,

      "anvDate": _anniversaryCtrl.text.isEmpty ? null : _anniversaryCtrl.text,
      "joinDate": _dojCtrl.text.isEmpty ? null : _dojCtrl.text,
      "gotram": _gothramCtrl.text.isEmpty ? "" : _gothramCtrl.text,
      "nakshatram": _dropdownValues['nakshatram']?.isEmpty == true
          ? ""
          : _dropdownValues['nakshatram'],

      "rashi":
          _dropdownValues['rashi'] == null ||
              _dropdownValues['rashi'].toString().isEmpty
          ? null
          : _dropdownService.getRashiIdFromName(_dropdownValues['rashi']) ??
                null,
      "padam":
          _dropdownValues['paadam'] == null ||
              _dropdownValues['paadam'].toString().isEmpty
          ? null
          : _dropdownService.getPaadamNumberFromValue(
              _dropdownValues['paadam'],
            ),
      "communicationpreference":
          _dropdownService
                  .getCommunicationModeCodeFromValue(
                    _dropdownValues['communication'],
                  )
                  ?.isEmpty ==
              true
          ? ""
          : _dropdownService.getCommunicationModeCodeFromValue(
              _dropdownValues['communication'],
            ),
      "panNumber": _panCtrl.text.isEmpty ? null : _panCtrl.text,
      "referredBy": referredById == 0 ? null : referredById,
      "mobileNumber": _mobileCtrl.text.isEmpty ? null : _mobileCtrl.text,
      "email": _emailCtrl.text.isEmpty ? "" : _emailCtrl.text,
      "whatsAppNumber": _whatsappCtrl.text.isEmpty ? "" : _whatsappCtrl.text,
      "address": _addressCtrl.text.isEmpty ? "" : _addressCtrl.text,
      "referredByCustome": referredByCustom,
      "relations": _getFormattedRelations(),
      "occassions": _getFormattedOccasions(),
      "status": _status,
    };

    print('📤 Sending payload with ALL nulls:');
    print(jsonEncode(requestData));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.brown)),
    );

    if (widget.jeevanadiId != null || widget.userId != null) {
      context.read<JeevanaadiBloc>().add(
        UpdateJeevanaadiProfileEvent(
          userid: widget.jeevanadiId ?? widget.userId,
          updateData: requestData,
        ),
      );
    }
  }

  List<Map<String, dynamic>> _getFormattedRelations() {
    return _relationships
        .where(
          (rel) =>
              rel["relation"]?.isNotEmpty == true ||
              rel["name"]?.isNotEmpty == true,
        )
        .map((rel) {
          final bool hasValidId =
              rel.containsKey("id") &&
              rel["id"] != null &&
              rel["id"].toString().isNotEmpty &&
              rel["id"].toString() != "0";

          return {
            "relationId": hasValidId
                ? int.tryParse(rel["id"].toString())
                : null,
            "relation": rel["relation"] ?? "",
            "name": rel["name"] ?? "",
            "mobileNumber": rel["mobile"]?.toString().isEmpty == true
                ? null
                : rel["mobile"],
            "dob": rel["dob"]?.toString().isEmpty == true ? null : rel["dob"],
            "nakshatram": rel["nakshatram"] ?? "",
            "rashi": rel["rashi"] == null || rel["rashi"].toString().isEmpty
                ? null
                : _dropdownService.getRashiIdFromName(rel["rashi"]),

            "padam": rel["paadam"] == null || rel["paadam"].toString().isEmpty
                ? null
                : _dropdownService.getPaadamNumberFromValue(rel["paadam"]),

            "status": "ACTIVE",
          };
        })
        .toList();
  }

  // List<Map<String, dynamic>> _getFormattedOccasions() {
  //   return _occasions
  //       .where((occ) => occ["name"]?.isNotEmpty == true)
  //       .map(
  //         (occ) => {
  //           "occassionId": occ["id"] != null && occ["id"].toString().isNotEmpty
  //               ? int.tryParse(occ["id"].toString())
  //               : null,
  //           "occName": occ["name"] ?? "",
  //           "occDate": occ["date"]?.isEmpty == true ? null : occ["date"],
  //           "status": "ACTIVE",
  //         },
  //       )
  //       .toList();
  // }
  List<Map<String, dynamic>> _getFormattedOccasions() {
  return _occasions
      .where((occ) => occ["name"]?.isNotEmpty == true)
      .map((occ) {
        final idValue = occ["id"]?.toString();

        final bool isExisting =
            idValue != null &&
            idValue.isNotEmpty &&
            idValue != "0";

        return {
          "occassionId": isExisting
              ? int.tryParse(idValue)
              : null, // ✅ new → null
          "occName": occ["name"] ?? "",
          "occDate": occ["date"]?.isEmpty == true ? null : occ["date"],
          "status": "ACTIVE",
        };
      })
      .toList();
}

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _referredBySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: BlocConsumer<JeevanaadiBloc, JeevanaadiState>(
        listenWhen: (previous, current) =>
            previous.profileLoading != current.profileLoading ||
            previous.profileErrorMsg != current.profileErrorMsg ||
            previous.jeevanaadiProfileFull != current.jeevanaadiProfileFull ||
            previous.isUpdateLoading != current.isUpdateLoading ||
            previous.updateSuccessMsg != current.updateSuccessMsg ||
            previous.updateErrorMsg != current.updateErrorMsg,

        listener: (context, state) {
          // Check if we have profile data (either from regular or request)
          if (!(state.profileLoading ?? false) &&
              state.jeevanaadiProfileFull != null) {
            _populateControllers(state.jeevanaadiProfileFull!);
          }

          // Handle update response
          if (!(state.isUpdateLoading ?? true) && _isUpdateInProgress) {
            setState(() => _isUpdateInProgress = false);
            Navigator.of(context).popUntil((route) => route.isFirst);

            final message = state.updateSuccessMsg ?? state.updateErrorMsg;
            if (message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: state.updateSuccessMsg != null
                      ? Colors.green
                      : Colors.red,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }

            if (state.updateSuccessMsg != null) {
              Future.delayed(const Duration(milliseconds: 500), () {
                // if (Navigator.canPop(context)) Navigator.pop(context, true);
                Get.offAllNamed('/jeevanadi');
              });
            }
          }
        },

        builder: (context, state) {
          // Show loading state
          if (state.profileLoading ?? false) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.brown),
                  SizedBox(height: 16),
                  Text('Loading profile data...'),
                ],
              ),
            );
          }

          // Show error state
          if (state.profileErrorMsg != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text('Error: ${state.profileErrorMsg}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchProfileData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show form when data is available
          if (state.jeevanaadiProfileFull == null) {
            return const Center(child: Text('No profile data available'));
          }

          return _buildForm(state.jeevanaadiProfileFull!);
        },
      ),
    );
  }

  Widget _buildForm(JeevanaadiFullProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(profile),
            const SizedBox(height: 12),
            _buildPersonalDetails(),
            _buildJeevanadiInfo(),
            _buildContactDetails(),
            _buildAddressDetails(),
            _buildRelationships(),
            _buildOccasions(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(JeevanaadiFullProfile profile) {
    final displayPercentage =
        profile.jeevanaadiDemoGraphicDetails.profileCompletionPercentage > 0
        ? profile.jeevanaadiDemoGraphicDetails.profileCompletionPercentage
        : profile.profileDetails.fillPercentage.toDouble();

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 4),
        const Text(
          "EDIT DETAILS",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(width: 66),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _isActive = !_isActive;
                _status = _isActive ? 'ACTIVE' : 'INACTIVE';
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Toggle icon
                  Icon(
                    _isActive ? Icons.toggle_on : Icons.toggle_off,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 66),

        // Profile percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "profile:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 150,
              height: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: displayPercentage / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.brown),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${displayPercentage.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalDetails() {
    return _buildSection(
      title: 'Personal Details',
      children: [
        _twoFieldRow(
          _textField("Full Name *", _nameCtrl),
          _dateField("Date of Birth *", _dobCtrl),
        ),
        _twoFieldRow(
          _dropdownField(
            "Gender *",
            'gender',
            _dropdownService.getGenderValues(),
          ),
          _dropdownField(
            "Material Status",
            'materialStatus',
            _dropdownService.getMaritalStatusValues(),
          ),
        ),
        _twoFieldRow(
          _textField("Profession", _professionCtrl),
          _dateField("Anniversary Date", _anniversaryCtrl),
        ),
        _twoFieldRow(
          _textField("Gothram", _gothramCtrl),
          _dropdownField(
            "Nakshatram",
            'nakshatram',
            _dropdownService.getAllNakshatras(),
          ),
        ),
        _twoFieldRow(
          _dropdownField("Rashi", 'rashi', _dropdownService.getRashiNames()),
          _dropdownField(
            "Paadam",
            'paadam',
            _dropdownService.getPaadamValues(),
          ),
        ),
        _twoFieldRow(
          _dropdownField(
            "Communication Preference *",
            'communication',
            _dropdownService.getCommunicationModeValues(),
          ),
          _textField("PAN Number", _panCtrl),
        ),
        _twoFieldRow(
          _dropdownField("Role & Permission *", 'role', [
            "Donor",
            "Admin",
            "Member",
            "Volunteer",
          ]),
          _buildReferredByField(),
        ),
      ],
    );
  }

  Widget _buildReferredByField() {
    return ReferredByDropdown(
      controller: _referredBySearchController,
      initialValue: _selectedReferredBy,
      onSelected: (value) {
        setState(() {
          _selectedReferredBy = value;
          _referredByCtrl.text = value?['userName'] ?? '';
        });
      },
    );
  }

  Widget _buildJeevanadiInfo() {
    return _buildSection(
      title: 'Jeevanadi Info',
      children: [
        _twoFieldRow(
          _textField("Jeevanadi Id", _jeevanadiIdCtrl),
          _dateField("Date of Joining", _dojCtrl),
        ),
      ],
    );
  }

  Widget _buildContactDetails() {
    return _buildSection(
      title: 'Contact Details',
      children: [
        _twoFieldRow(
          _textField("Mobile Number", _mobileCtrl),
          _textField("Email *", _emailCtrl),
        ),
        Row(
          children: [
            Checkbox(
              value: _sameAsMobile,
              onChanged: (v) => setState(() {
                _sameAsMobile = v ?? true;
                if (_sameAsMobile) _whatsappCtrl.text = _mobileCtrl.text;
              }),
            ),
            const Text("Same number for WhatsApp"),
          ],
        ),
        if (!_sameAsMobile) _textField("WhatsApp Number", _whatsappCtrl),
      ],
    );
  }

  Widget _buildAddressDetails() {
    return _buildSection(
      title: 'Address Details',
      children: [_bigAddressField("Address *", _addressCtrl)],
    );
  }

  Widget _buildRelationships() {
    return _buildSection(
      title: 'Your Relationships',
      showAddButton: true,
      onAdd: () {
        setState(() {
          _relationships.add(
            {
                  "id": "",
                  "relation": "",
                  "name": "",
                  "mobile": "",
                  "dob": "",
                  "nakshatram": "",
                  "rashi": "",
                  "paadam": "",
                }
                as Map<String, dynamic>,
          );
        });
      },
      children: [
        if (_relationships.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('No relationships added yet'),
          ),
        ..._relationships.asMap().entries.map((entry) {
          return _buildRelationshipInline(entry.key, entry.value);
        }).toList(),
      ],
    );
  }

  Widget _buildOccasions() {
    return _buildSection(
      title: 'Occasions Details',
      showAddButton: true,
      onAdd: () {
        setState(() {
          _occasions.add(<String, dynamic>{
            "id": "",
            "name": "",
            "date": "",
            "uniqueId": DateTime.now().millisecondsSinceEpoch.toString(),
          });
          print('Added occasion, total: ${_occasions.length}');
        });
      },
      children: [
        if (_occasions.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('No occasions added yet'),
          ),
        ...List.generate(_occasions.length, (index) {
          return _buildOccasionInline(index, _occasions[index]);
        }),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widgets
  Widget _buildSection({
    required String title,
    required List<Widget> children,
    bool showAddButton = false,
    VoidCallback? onAdd,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showAddButton)
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                  onPressed: onAdd,
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _twoFieldRow(Widget left, Widget right) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    ),
  );

  Widget _textField(String label, TextEditingController controller) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: _inputDecoration(label),
    ),
  );

  Widget _bigAddressField(String label, TextEditingController controller) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          maxLines: 4,
          minLines: 3,
          decoration: _inputDecoration(label).copyWith(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
        ),
      );

  Widget _dateField(String label, TextEditingController controller) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickDate(controller),
      decoration: _inputDecoration(
        label,
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
      ),
    ),
  );

  Widget _dropdownField(String label, String key, List<String> items) {
    // Safely get the current value as String
    String? currentValue;

    if (_dropdownValues.containsKey(key)) {
      var value = _dropdownValues[key];
      if (value is String) {
        currentValue = items.contains(value) ? value : null;
      } else if (value != null) {
        // Convert to String if it's not already
        String stringValue = value.toString();
        currentValue = items.contains(stringValue) ? stringValue : null;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text("Select", style: TextStyle(color: Colors.grey)),
          ),
          ...items.map(
            (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
          ),
        ],
        onChanged: (v) {
          setState(() {
            _dropdownValues[key] = v ?? '';
          });
        },
        decoration: _inputDecoration(label),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        style: const TextStyle(color: Colors.black, fontSize: 14),
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildRelationshipInline(int index, Map<String, dynamic> rel) {
    rel['id'] = rel['id'] ?? '';
    rel['relation'] = rel['relation'] ?? '';
    rel['name'] = rel['name'] ?? '';
    rel['mobile'] = rel['mobile'] ?? '';
    rel['dob'] = rel['dob'] ?? '';
    rel['nakshatram'] = rel['nakshatram'] ?? '';
    rel['rashi'] = rel['rashi'] ?? '';
    rel['paadam'] = rel['paadam'] ?? '';

    final key = rel['id'].toString().isNotEmpty && rel['id'] != '0'
        ? ValueKey('relation_${rel['id']}')
        : UniqueKey();

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _relationField(rel, index)),
              const SizedBox(width: 12),
              Expanded(child: _nameField(rel, index)),
              const SizedBox(width: 12),
              Expanded(child: _mobileField(rel, index)),
              const SizedBox(width: 12),
              Expanded(child: _relDobField(rel, index)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _relNakshatramField(rel, index)),
              const SizedBox(width: 12),
              Expanded(child: _relRashiField(rel, index)),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _relPaadamField(rel, index)),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _relationships.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOccasionInline(int index, Map<String, dynamic> occ) {
    final key = ValueKey('occasion_${index}_${occ['uniqueId']}');
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0) const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    initialValue: occ['name'] ?? '',
                    style: const TextStyle(fontSize: 14),
                    decoration: _inputDecoration("Occasion Name"),
                    onChanged: (value) {
                      _occasions[index]['name'] = value;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child:
                      // TextFormField(
                      //   initialValue: occ['date'] ?? '',
                      //   readOnly: true,
                      //   onTap: () async {
                      //     final date = await showDatePicker(
                      //       context: context,
                      //       firstDate: DateTime(1900),
                      //       lastDate: DateTime(2100),
                      //       initialDate: DateTime.now(),
                      //     );
                      //     if (date != null) {
                      //       final formattedDate = DateFormat(
                      //         "yyyy-MM-dd",
                      //       ).format(date);
                      //       setState(() {
                      //         _occasions[index]['date'] = formattedDate;
                      //       });
                      //     }
                      //   },
                      //   decoration: _inputDecoration(
                      //     "Occasion Date",
                      //     suffixIcon: const Icon(
                      //       Icons.calendar_today,
                      //       color: Colors.grey,
                      //     ),
                      //   ),
                      // ),
                      TextFormField(
                        key: ValueKey('occasion_date_${occ['uniqueId']}'),
                        controller: TextEditingController(
                          text: occ['date'] ?? '',
                        ),
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: DateTime.now(),
                          );
                          if (date != null) {
                            final formattedDate = DateFormat(
                              "yyyy-MM-dd",
                            ).format(date);
                            setState(() {
                              _occasions[index]['date'] = formattedDate;
                            });
                          }
                        },
                        decoration: _inputDecoration(
                          "Occasion Date",
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                ),
              ),
              if (_occasions.length > 1)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 12),
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => setState(() => _occasions.removeAt(index)),
                  ),
                ),
            ],
          ),
        ),
        if (index < _occasions.length - 1)
          const Divider(height: 16, color: Colors.grey),
      ],
    );
  }

  Widget _relationField(Map<String, dynamic> rel, int index) =>
      _buildRelDropdown(
        rel,
        index,
        "relation",
        "Relation",
        _dropdownService.getAllRelations(),
      );

  Widget _relNakshatramField(Map<String, dynamic> rel, int index) =>
      _buildRelDropdown(
        rel,
        index,
        "nakshatram",
        "Nakshatram",
        _dropdownService.getAllNakshatras(),
      );

  Widget _relRashiField(Map<String, dynamic> rel, int index) =>
      _buildRelDropdown(
        rel,
        index,
        "rashi",
        "Rashi",
        _dropdownService.getRashiNames(),
      );

  Widget _relPaadamField(Map<String, dynamic> rel, int index) =>
      _buildRelDropdown(
        rel,
        index,
        "paadam",
        "Paadam",
        _dropdownService.getPaadamValues(),
      );

  Widget _buildRelDropdown(
    Map<String, dynamic> rel,
    int index,
    String key,
    String label,
    List<String> items,
  ) {
    String? currentValue;
    if (rel.containsKey(key) && rel[key] != null) {
      currentValue = rel[key].toString();
      if (!items.contains(currentValue)) {
        currentValue = null;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              "Select $label",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ...items.map(
            (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
          ),
        ],
        onChanged: (v) {
          setState(() {
            rel[key] = v ?? '';
          });
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        style: const TextStyle(color: Colors.black, fontSize: 14),
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _nameField(Map<String, dynamic> rel, int index) =>
      _buildRelTextField(rel, index, "name", "Name");

  Widget _mobileField(Map<String, dynamic> rel, int index) =>
      _buildRelTextField(rel, index, "mobile", "Mobile Number", isPhone: true);

  Widget _buildRelTextField(
    Map<String, dynamic> rel,
    int index,
    String key,
    String label, {
    bool isPhone = false,
  }) {
    // Get the current value safely
    String currentValue = rel[key]?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: currentValue,
        style: const TextStyle(fontSize: 14),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: (v) {
          setState(() {
            _relationships[index][key] = v ?? '';
          });
        },
      ),
    );
  }

  Widget _relDobField(Map<String, dynamic> rel, int index) {
    String dateValue = '';
    if (rel.containsKey("dob") && rel["dob"] != null) {
      dateValue = rel["dob"].toString();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: TextEditingController(text: dateValue),
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            initialDate: DateTime.now(),
          );
          if (date != null) {
            setState(() {
              rel["dob"] = DateFormat("yyyy-MM-dd").format(date);
            });
          }
        },
        decoration: _inputDecoration(
          "Date of Birth",
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
