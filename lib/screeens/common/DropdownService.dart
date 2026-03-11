class DropdownService {
  static final DropdownService _instance = DropdownService._internal();
  
  factory DropdownService() => _instance;
  
  DropdownService._internal();

  // ============ DATA SOURCES ============
  
  List<Map<String, dynamic>> getAllRashis() => const [
    {"id": 1, "tname": "Mesha", "ename": "Aries"},
    {"id": 2, "tname": "Vrishabha", "ename": "Taurus"},
    {"id": 3, "tname": "Mithuna", "ename": "Gemini"},
    {"id": 4, "tname": "Karkataka", "ename": "Cancer"},
    {"id": 5, "tname": "Simha", "ename": "Leo"},
    {"id": 6, "tname": "Kanya", "ename": "Virgo"},
    {"id": 7, "tname": "Tula", "ename": "Libra"},
    {"id": 8, "tname": "Vrischika", "ename": "Scorpio"},
    {"id": 9, "tname": "Dhanu", "ename": "Sagittarius"},
    {"id": 10, "tname": "Makara", "ename": "Capricorn"},
    {"id": 11, "tname": "Kumbha", "ename": "Aquarius"},
    {"id": 12, "tname": "Meena", "ename": "Pisces"},
  ];

  List<String> getAllNakshatras() => const [
    "Ashwini", "Bharani", "Krittika", "Rohini", "Mrigashira", 
    "Arudra", "Punarvasu", "Pushya", "Ashlesha", "Magha", 
    "Purva Phalguni", "Uttara Phalguni", "Hasta", "Chitra", 
    "Swati", "Vishaka", "Anuradha", "Jyeshta", "Mula", 
    "Purva Ashadha", "Uttara Ashadha", "Shravana", "Dhanishta", 
    "Shatabhisha", "Purva Bhadrapada", "Uttara Bhadrapada", "Revati"
  ];

  List<String> getAllRelations() => const [
    "Wife", "Husband", "Father", "Mother", "Son", "Daughter", 
    "Son-in-law", "Daughter-in-law", "Brother", "Sister", 
    "Grand Father", "Grand Mother", "Nephew", "Niece", "Aunt", 
    "Uncle", "Grand Son", "Grand Daughter"
  ];

  Map<String, String> getAllMaritalStatus() => const {
    "S": "Single", "D": "Divorced", "M": "Married", "W": "Widow"
  };

   Map<String, String> getAllCommunicationModes() => const {
    "W": "WhatsApp", 
   
    "E": "Email"
  };

  List<Map<String, dynamic>> getAllGenders() => const [
    {"id": 1, "code": "M", "value": "Male"},
    {"id": 2, "code": "F", "value": "Female"},
    {"id": 3, "code": "O", "value": "Others"},
  ];

  List<Map<String, dynamic>> getAllPaadams() => const [
    {"id": 1, "value": "1", "number": 1},
    {"id": 2, "value": "2", "number": 2},
    {"id": 3, "value": "3", "number": 3},
    {"id": 4, "value": "4", "number": 4},
  ];

  // ============ HELPER GETTERS ============
  
  List<String> getGenderValues() => getAllGenders().map((g) => g['value'] as String).toList();
  List<String> getGenderCodes() => getAllGenders().map((g) => g['code'] as String).toList();
  List<String> getPaadamValues() => getAllPaadams().map((p) => p['value'] as String).toList();
  List<int> getPaadamNumbers() => getAllPaadams().map((p) => p['number'] as int).toList();
  List<String> getMaritalStatusValues() => getAllMaritalStatus().values.toList();
  List<String> getMaritalStatusCodes() => getAllMaritalStatus().keys.toList();
  List<String> getCommunicationModeValues() => getAllCommunicationModes().values.toList();
  List<String> getCommunicationModeCodes() => getAllCommunicationModes().keys.toList();
  List<String> getRashiNames() => getAllRashis().map((r) => r['ename'] as String).toList();
  List<int> getRashiIds() => getAllRashis().map((r) => r['id'] as int).toList();

  // ============ LOOKUP METHODS ============
  
  Map<String, dynamic>? getRashiById(int id) {
    try {
      return getAllRashis().firstWhere((r) => r['id'] == id);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? getGenderByCode(String code) {
    try {
      return getAllGenders().firstWhere((g) => g['code'] == code);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic>? getPaadamByNumber(int number) {
    try {
      return getAllPaadams().firstWhere((p) => p['number'] == number);
    } catch (_) {
      return null;
    }
  }

  // ============ BACKEND TO DISPLAY MAPPING ============
  
  String getRashiNameFromId(dynamic id) {
    if (id == null) return "";
    int rashiId = id is int ? id : int.tryParse(id.toString()) ?? 0;
    if (rashiId < 1 || rashiId > 12) return "";
    return getRashiById(rashiId)?['ename'] ?? "";
  }

  String getPaadamValueFromNumber(dynamic number) {
    if (number == null) return "";
    int paadamNum = number is int ? number : int.tryParse(number.toString()) ?? 0;
    if (paadamNum < 1 || paadamNum > 4) return "";
    return getPaadamByNumber(paadamNum)?['value'] ?? "";
  }

  String getGenderValueFromCode(String? code) {
    if (code?.isEmpty ?? true) return "";
    return getGenderByCode(code!)?['value'] ?? "";
  }

  String getMaritalStatusValueFromCode(String? code) {
    if (code?.isEmpty ?? true) return "";
    return getAllMaritalStatus()[code] ?? "";
  }

  String getCommunicationModeValueFromCode(String? code) {
    if (code?.isEmpty ?? true) return "";
    return getAllCommunicationModes()[code] ?? "";
  }

  String getNakshatraValue(String? nakshatra) {
    if (nakshatra?.isEmpty ?? true) return "";
    return getAllNakshatras().contains(nakshatra) ? nakshatra! : "";
  }

  String getRelationValue(String? relation) {
    if (relation?.isEmpty ?? true) return "";
    return getAllRelations().contains(relation) ? relation! : "";
  }

  // ============ DISPLAY TO BACKEND MAPPING ============
  
  int getRashiIdFromName(String? name) {
    if (name?.isEmpty ?? true) return 0;
    try {
      return getAllRashis().firstWhere(
        (r) => r['ename'] == name || r['tname'] == name
      )['id'] as int;
    } catch (_) {
      return 0;
    }
  }

  int getPaadamNumberFromValue(String? value) {
    if (value?.isEmpty ?? true) return 0;
    try {
      return getAllPaadams().firstWhere((p) => p['value'] == value)['number'] as int;
    } catch (_) {
      int? num = int.tryParse(value!);
      return (num != null && num >= 1 && num <= 4) ? num : 0;
    }
  }

  String getGenderCodeFromValue(String? value) {
    if (value?.isEmpty ?? true) return "";
    try {
      return getAllGenders().firstWhere((g) => g['value'] == value)['code'] as String;
    } catch (_) {
      return "";
    }
  }

  String getMaritalStatusCodeFromValue(String? value) {
    if (value?.isEmpty ?? true) return "";
    return getAllMaritalStatus().entries.firstWhere(
      (e) => e.value == value,
      orElse: () => const MapEntry("", "")
    ).key;
  }

  String getCommunicationModeCodeFromValue(String? value) {
    if (value?.isEmpty ?? true) return "";
    return getAllCommunicationModes().entries.firstWhere(
      (e) => e.value == value,
      orElse: () => const MapEntry("", "")
    ).key;
  }

  // ============ VALIDATION METHODS ============
  
  bool hasGenderValue(String? code) => code?.isNotEmpty ?? false ? getGenderByCode(code!) != null : false;
  bool hasMaritalStatusValue(String? code) => getAllMaritalStatus().containsKey(code ?? '');
  bool hasNakshatraValue(String? nakshatra) => getAllNakshatras().contains(nakshatra ?? '');
  bool hasRashiValue(int? id) => id != null && id > 0 && id <= 12 && getRashiById(id) != null;
  bool hasPaadamValue(int? number) => number != null && number >= 1 && number <= 4 && getPaadamByNumber(number) != null;
  bool hasCommunicationModeValue(String? code) => getAllCommunicationModes().containsKey(code ?? '');
  bool hasRelationValue(String? relation) => getAllRelations().contains(relation ?? '');
}