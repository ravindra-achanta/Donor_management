import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vikas_app/screeens/jeevanadi/view_jeevanadi_screen.dart';
import 'package:vikas_app/views/layouts/layout.dart';

class EditJeevanadiScreen extends StatefulWidget {
  const EditJeevanadiScreen({super.key, JeevanadiProfile? profile});

  @override
  State<EditJeevanadiScreen> createState() => _EditJeevanadiScreenState();
}

class _EditJeevanadiScreenState extends State<EditJeevanadiScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- PERSONAL DETAILS ---
  final nameCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  String gender = "Male";
  String maritalStatus = "";
  final professionCtrl = TextEditingController();
  final anniversaryCtrl = TextEditingController();
  final gothramCtrl = TextEditingController();
  String nakshatram = "";
  String rashi = "";
  String paadam = "";
  String communication = "WhatsApp";
  final panCtrl = TextEditingController();
  String role = "";
  final referredByCtrl = TextEditingController();

  // --- JEEVANADI INFO ---
  final jeevanadiIdCtrl = TextEditingController();
  final dojCtrl = TextEditingController();

  // --- CONTACT DETAILS ---
  final mobileCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  bool sameAsMobile = true;

  // --- ADDRESS DETAILS ---
  final addressCtrl = TextEditingController(text: "Hyderabad");

  // --- RELATIONSHIPS MULTI-ENTRY ---
  List<Map<String, dynamic>> relationships = [];

  // --- OCCASIONS MULTI-ENTRY ---
  List<Map<String, dynamic>> occasions = [];

  @override
  void initState() {
    super.initState();
    // Initial single entry for both relationships and occasions
    relationships.add({
      "relation": "",
      "name": "",
      "mobile": "",
      "dob": "",
      "nakshatram": "",
      "rashi": "",
      "paadam": "",
    });
    occasions.add({"name": "", "date": ""});
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (d != null) {
      ctrl.text = DateFormat("dd-MM-yyyy").format(d);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 22),
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => const ViewJeevanadiScreen(),
                      //   ),
                      // );
                    },
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "EDIT DETAILS",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "profile:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 150,
                          height: 12,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: 0.75,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.brown,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "75/100",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ----------------- PERSONAL DETAILS -----------------
              _buildContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Personal Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _twoFieldRow(
                      _textField("Full Name *", nameCtrl),
                      _dateField("Date of Birth *", dobCtrl),
                    ),
                    _twoFieldRow(
                      _dropdownField("Gender *", gender, [
                        "Male",
                        "Female",
                        "others",
                      ], (v) => setState(() => gender = v)),
                      _dropdownField(
                        "Marital Status",
                        maritalStatus,
                        ["Single", "Married", "Divorced", "Widow", "Other"],
                        (v) => setState(() => maritalStatus = v),
                      ),
                    ),
                    _twoFieldRow(
                      _textField("Profession", professionCtrl),
                      _dateField("Anniversary Date", anniversaryCtrl),
                    ),
                    _twoFieldRow(
                      _textField("Gothram", gothramCtrl),
                      _dropdownField(
                        "Nakshatram",
                        nakshatram,
                        ["Ashwini", "Bharani", "Krittika", "Rohini"],
                        (v) => setState(() => nakshatram = v),
                      ),
                    ),
                    _twoFieldRow(
                      _dropdownField("Rashi", rashi, [
                        "Mesha",
                        "Vrishabha",
                        "Mithuna",
                        "Karka",
                      ], (v) => setState(() => rashi = v)),
                      _dropdownField("Paadam", paadam, [
                        "1",
                        "2",
                        "3",
                        "4",
                      ], (v) => setState(() => paadam = v)),
                    ),
                    _twoFieldRow(
                      _dropdownField(
                        "Communication Preference *",
                        communication,
                        ["WhatsApp", "SMS", "Email"],
                        (v) => setState(() => communication = v),
                      ),
                      _textField("PAN Number", panCtrl),
                    ),
                    _twoFieldRow(
                      _dropdownField("Role & Permission *", role, [
                        "Donor",
                        "Admin",
                        "Member",
                      ], (v) => setState(() => role = v)),
                      _textField("Referred By", referredByCtrl),
                    ),
                  ],
                ),
              ),

              // ----------------- JEEVANADI INFO -----------------
              _buildContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jeevanadi Info",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _twoFieldRow(
                      _textField("Jeevanadi Id", jeevanadiIdCtrl),
                      _textField("Date of Joining", dojCtrl),
                    ),
                  ],
                ),
              ),

              // ----------------- CONTACT DETAILS -----------------
              _buildContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Contact Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _twoFieldRow(
                      _textField("Mobile Number", mobileCtrl),
                      _textField("Email *", emailCtrl),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: sameAsMobile,
                          onChanged: (v) {
                            setState(() {
                              sameAsMobile = v ?? true;
                              if (sameAsMobile)
                                whatsappCtrl.text = mobileCtrl.text;
                            });
                          },
                        ),
                        const Text("Same number for WhatsApp"),
                      ],
                    ),
                    if (!sameAsMobile)
                      _textField("WhatsApp Number", whatsappCtrl),
                  ],
                ),
              ),

              // ----------------- ADDRESS DETAILS -----------------
              _buildContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Address Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _bigAddressField("Address *", addressCtrl),
                  ],
                ),
              ),

              // ----------------- RELATIONSHIPS MULTI-ENTRY -----------------
              _buildContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your Relationships",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              relationships.add({
                                "relation": "",
                                "name": "",
                                "mobile": "",
                                "dob": "",
                                "nakshatram": "",
                                "rashi": "",
                                "paadam": "",
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Relationships list - inline without cards
                    ...relationships.asMap().entries.map((entry) {
                      final index = entry.key;
                      final rel = entry.value;
                      return _buildRelationshipInline(index, rel);
                    }).toList(),
                  ],
                ),
              ),

              // ----------------- OCCASIONS MULTI-ENTRY -----------------
              _buildContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Occasions Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              occasions.add({"name": "", "date": ""});
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Occasions list - inline without cards
                    ...occasions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final occ = entry.value;
                      return _buildOccasionInline(index, occ);
                    }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // ----------------- ACTION BUTTONS -----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // Cancel Button
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: OutlinedButton(
                              onPressed: () {
                                // Cancel action
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[400]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Submit Button
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Updated Successfully"),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- RELATIONSHIP INLINE -----------------
  Widget _buildRelationshipInline(int index, Map<String, dynamic> rel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0) const SizedBox(height: 16),
        // Row 1: 4 fields
        Row(
          children: [
            Expanded(child: _relationField(rel)),
            const SizedBox(width: 12),
            Expanded(child: _nameField(rel)),
            const SizedBox(width: 12),
            Expanded(child: _mobileField(rel)),
            const SizedBox(width: 12),
            Expanded(child: _dobField(rel)),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: 3 fields with delete button
        Row(
          children: [
            Expanded(child: _nakshatramField(rel)),
            const SizedBox(width: 12),
            Expanded(child: _rashiField(rel)),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _paadamField(rel)),
                  if (relationships.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => relationships.removeAt(index)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (index < relationships.length - 1)
          const Divider(height: 24, color: Colors.grey),
      ],
    );
  }

  Widget _relationField(Map<String, dynamic> rel) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      value: rel["relation"].isEmpty ? null : rel["relation"],
      style: const TextStyle(color: Colors.black, fontSize: 14),
      items: [
        DropdownMenuItem<String>(
          value: "",
          child: Text(
            "Select Relation",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ...[
          "Father",
          "Mother",
          "Spouse",
          "Son",
          "Daughter",
          "Other",
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ],
      onChanged: (v) => setState(() => rel["relation"] = v ?? ""),
      decoration: InputDecoration(
        labelText: "Relation",
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      dropdownColor: Colors.white,
    ),
  );

  Widget _nameField(Map<String, dynamic> rel) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      initialValue: rel["name"],
      style: const TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        labelText: "Name",
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      onChanged: (v) => rel["name"] = v,
    ),
  );

  Widget _mobileField(Map<String, dynamic> rel) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      initialValue: rel["mobile"],
      style: const TextStyle(color: Colors.black, fontSize: 14),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Mobile Number",
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      onChanged: (v) => rel["mobile"] = v,
    ),
  );

  Widget _dobField(Map<String, dynamic> rel) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: TextEditingController(text: rel["dob"]),
      readOnly: true,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
        );
        if (d != null) {
          setState(() {
            rel["dob"] = DateFormat("dd-MM-yyyy").format(d);
          });
        }
      },
      decoration: InputDecoration(
        labelText: "Date of Birth",
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    ),
  );

  Widget _nakshatramField(Map<String, dynamic> rel) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      value: rel["nakshatram"].isEmpty ? null : rel["nakshatram"],
      style: const TextStyle(color: Colors.black, fontSize: 14),
      items: [
        DropdownMenuItem<String>(
          value: "",
          child: Text(
            "Select Nakshatram",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ...[
          "Ashwini",
          "Bharani",
          "Krittika",
          "Rohini",
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ],
      onChanged: (v) => setState(() => rel["nakshatram"] = v ?? ""),
      decoration: InputDecoration(
        labelText: "Nakshatram",
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      dropdownColor: Colors.white,
    ),
  );

  Widget _rashiField(Map<String, dynamic> rel) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      value: rel["rashi"].isEmpty ? null : rel["rashi"],
      style: const TextStyle(color: Colors.black, fontSize: 14),
      items: [
        DropdownMenuItem<String>(
          value: "",
          child: Text(
            "Select Rashi",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ...[
          "Mesha",
          "Vrishabha",
          "Mithuna",
          "Karka",
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ],
      onChanged: (v) => setState(() => rel["rashi"] = v ?? ""),
      decoration: InputDecoration(
        labelText: "Rashi",
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      dropdownColor: Colors.white,
    ),
  );

  Widget _paadamField(Map<String, dynamic> rel) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      value: rel["paadam"].isEmpty ? null : rel["paadam"],
      style: const TextStyle(color: Colors.black, fontSize: 14),
      items: [
        DropdownMenuItem<String>(
          value: "",
          child: Text(
            "Select Paadam",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ...[
          "1",
          "2",
          "3",
          "4",
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ],
      onChanged: (v) => setState(() => rel["paadam"] = v ?? ""),
      decoration: InputDecoration(
        labelText: "Paadam",
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      dropdownColor: Colors.white,
    ),
  );

  // ----------------- OCCASION INLINE -----------------
  Widget _buildOccasionInline(int index, Map<String, dynamic> occ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0) const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  initialValue: occ["name"],
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: "Occasion Name",
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  onChanged: (v) => occ["name"] = v,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: TextEditingController(text: occ["date"]),
                  readOnly: true,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );
                    if (d != null) {
                      setState(() {
                        occ["date"] = DateFormat("dd-MM-yyyy").format(d);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Occasion Date",
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (occasions.length > 1)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 12),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => setState(() => occasions.removeAt(index)),
                ),
              ),
          ],
        ),
        if (index < occasions.length - 1)
          const Divider(height: 16, color: Colors.grey),
      ],
    );
  }

  // ----------------- ORIGINAL HELPERS -----------------
  Widget _buildContainer(Widget child) => Container(
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
    child: child,
  );

  Widget _twoFieldRow(Widget left, Widget right) => Row(
    children: [
      Expanded(child: left),
      const SizedBox(width: 16),
      Expanded(child: right),
    ],
  );

  Widget _textField(String label, TextEditingController ctrl) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: ctrl,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    ),
  );

  Widget _bigAddressField(String label, TextEditingController ctrl) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: ctrl,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      maxLines: 4,
      minLines: 3,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
      ),
    ),
  );

  Widget _dateField(String label, TextEditingController ctrl) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: ctrl,
      readOnly: true,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      onTap: () => _pickDate(ctrl),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    ),
  );

  Widget _dropdownField(
    String label,
    String value,
    List<String> items,
    Function(String) onChange,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChange(v);
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      dropdownColor: Colors.white,
    ),
  );
}
