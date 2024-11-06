import '../../../core/models/contract_details.dart';

class VoiceContract {
  final String id;
  final String category;
  final String title;
  final String clientName;
  DateTime startDate;
  DateTime? endDate; // Removed final since it's modified in terminate() and renew()
  final double rate;
  final String rateType;
  bool isActive;
  final Map<String, dynamic> terms;
  final String contractType;
  final String usageScope;
  final List<String> platforms;
  final Map<String, dynamic> royaltyTerms;
  final Map<String, dynamic> culturalMetadata;
  final Map<String, dynamic> rightsManagement;
  final List<String> territories;
  DateTime? renewalDate;
  String status;
  final Map<String, dynamic> paymentSchedule;
  final Map<String, dynamic> usageRestrictions;
  final Map<String, dynamic> intellectualProperty;

  VoiceContract({
    required this.id,
    required this.category,
    required this.title,
    required this.clientName,
    required this.startDate,
    this.endDate,
    required this.rate,
    required this.rateType,
    this.isActive = true,
    required this.terms,
    required this.contractType,
    required this.usageScope,
    required this.platforms,
    required this.royaltyTerms,
    required this.culturalMetadata,
    required this.rightsManagement,
    required this.territories,
    this.renewalDate,
    required this.status,
    required this.paymentSchedule,
    required this.usageRestrictions,
    required this.intellectualProperty, required String description,
  });

  factory VoiceContract.fromJson(Map<String, dynamic> json) {
    return VoiceContract(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      clientName: json['clientName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      rate: (json['rate'] as num).toDouble(),
      rateType: json['rateType'] as String,
      isActive: json['isActive'] as bool,
      terms: json['terms'] as Map<String, dynamic>,
      contractType: json['contractType'] as String,
      usageScope: json['usageScope'] as String,
      platforms: List<String>.from(json['platforms'] as List),
      royaltyTerms: json['royaltyTerms'] as Map<String, dynamic>,
      culturalMetadata: json['culturalMetadata'] as Map<String, dynamic>,
      rightsManagement: json['rightsManagement'] as Map<String, dynamic>,
      territories: List<String>.from(json['territories'] as List),
      renewalDate: json['renewalDate'] != null ? DateTime.parse(json['renewalDate'] as String) : null,
      status: json['status'] as String,
      paymentSchedule: json['paymentSchedule'] as Map<String, dynamic>,
      usageRestrictions: json['usageRestrictions'] as Map<String, dynamic>,
      intellectualProperty: json['intellectualProperty'] as Map<String, dynamic>, description: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'clientName': clientName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'rate': rate,
      'rateType': rateType,
      'isActive': isActive,
      'terms': terms,
      'contractType': contractType,
      'usageScope': usageScope,
      'platforms': platforms,
      'royaltyTerms': royaltyTerms,
      'culturalMetadata': culturalMetadata,
      'rightsManagement': rightsManagement,
      'territories': territories,
      'renewalDate': renewalDate?.toIso8601String(),
      'status': status,
      'paymentSchedule': paymentSchedule,
      'usageRestrictions': usageRestrictions,
      'intellectualProperty': intellectualProperty,
    };
  }

  factory VoiceContract.fromType(String type) {
    final now = DateTime.now();
    return VoiceContract(
      id: '',  // Will be set by the backend
      category: type,
      title: '',
      clientName: '',
      startDate: now,
      rate: 0.0,
      rateType: _getDefaultRateType(type),
      terms: {},
      contractType: type,
      usageScope: 'local',
      platforms: [],
      royaltyTerms: {},
      culturalMetadata: {},
      rightsManagement: {},
      territories: [],
      status: 'draft',
      paymentSchedule: {},
      usageRestrictions: {},
      intellectualProperty: {}, description: '',
    );
  }

  static String _getDefaultRateType(String contractType) {
    switch (contractType) {
      case 'entertainment':
      case 'education':
        return 'royalty';
      case 'corporate':
        return 'project';
      default:
        return 'hourly';
    }
  }

  Future<void> activate() async {
    if (status != 'pending') {
      throw StateError('Contract must be in pending state to activate');
    }
    status = 'active';
    isActive = true;
  }

  Future<void> terminate() async {
    if (status != 'active') {
      throw StateError('Only active contracts can be terminated');
    }
    status = 'terminated';
    isActive = false;
    endDate = DateTime.now();
  }

  Future<void> renew() async {
    if (status != 'active' && status != 'completed') {
      throw StateError('Only active or completed contracts can be renewed');
    }
    final now = DateTime.now();
    renewalDate = now;
    startDate = now;
    endDate = null;
    status = 'active';
    isActive = true;
  }

  VoiceContract copyWith({
    String? id,
    String? category,
    String? title,
    String? clientName,
    DateTime? startDate,
    DateTime? endDate,
    double? rate,
    String? rateType,
    bool? isActive,
    Map<String, dynamic>? terms,
    String? contractType,
    String? usageScope,
    List<String>? platforms,
    Map<String, dynamic>? royaltyTerms,
    Map<String, dynamic>? culturalMetadata,
    Map<String, dynamic>? rightsManagement,
    List<String>? territories,
    DateTime? renewalDate,
    String? status,
    Map<String, dynamic>? paymentSchedule,
    Map<String, dynamic>? usageRestrictions,
    Map<String, dynamic>? intellectualProperty,
  }) {
    return VoiceContract(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      clientName: clientName ?? this.clientName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rate: rate ?? this.rate,
      rateType: rateType ?? this.rateType,
      isActive: isActive ?? this.isActive,
      terms: terms ?? this.terms,
      contractType: contractType ?? this.contractType,
      usageScope: usageScope ?? this.usageScope,
      platforms: platforms ?? this.platforms,
      royaltyTerms: royaltyTerms ?? this.royaltyTerms,
      culturalMetadata: culturalMetadata ?? this.culturalMetadata,
      rightsManagement: rightsManagement ?? this.rightsManagement,
      territories: territories ?? this.territories,
      renewalDate: renewalDate ?? this.renewalDate,
      status: status ?? this.status,
      paymentSchedule: paymentSchedule ?? this.paymentSchedule,
      usageRestrictions: usageRestrictions ?? this.usageRestrictions,
      intellectualProperty: intellectualProperty ?? this.intellectualProperty, description: '',
    );
  }

  static VoiceContract fromContractDetails(ContractDetails details) {
    final now = DateTime.now();
    return VoiceContract(
      id: details.id,
      category: details.type?.toString() ?? 'unknown',
      title: details.title,
      clientName: 'Unknown Client',
      startDate: now,
      rate: 0.0,
      rateType: 'hourly',
      terms: {},
      contractType: details.contractType,
      usageScope: 'standard',
      platforms: [],
      royaltyTerms: {},
      culturalMetadata: details.culturalMetadata ?? {},
      rightsManagement: {},
      territories: [],
      status: details.status,
      paymentSchedule: {},
      usageRestrictions: {},
      intellectualProperty: {},
      description: details.description,
    );
  }
}
