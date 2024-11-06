import '../../features/discover/screens/discover_screen.dart';

class ContractDetails {
  final String id;
  final String title;
  final String description;
  final String status;
  final String contractType;
  final String language;
  final Map<String, dynamic>? culturalMetadata;
  final String? clientName;
  final ContractType? type;

  ContractDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.contractType,
    required this.language,
    this.culturalMetadata,
    this.clientName,
    this.type,
  });

  factory ContractDetails.fromJson(Map<String, dynamic> json) {
    return ContractDetails(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      contractType: json['contractType'] as String,
      language: json['language'] as String,
      culturalMetadata: json['culturalMetadata'] as Map<String, dynamic>?,
      clientName: json['clientName'] as String?,
      type: json['type'] != null ? ContractType.values[json['type'] as int] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'contractType': contractType,
      'language': language,
      'culturalMetadata': culturalMetadata,
      'clientName': clientName,
      'type': type?.index,
    };
  }
}
