class VoiceCollection {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String createdAt;
  final String? usageRights;
  final String? culturalContext;
  final List<String>? voiceCharacteristics;
  final List<String>? potentialApplications;
  final String? estimatedValue;

  const VoiceCollection({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.usageRights,
    this.culturalContext,
    this.voiceCharacteristics,
    this.potentialApplications,
    this.estimatedValue,
  });

  factory VoiceCollection.fromJson(Map<String, dynamic> json) {
    return VoiceCollection(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      usageRights: json['usageRights'] as String?,
      culturalContext: json['culturalContext'] as String?,
      voiceCharacteristics: json['voiceCharacteristics'] as List<String>?,
      potentialApplications: json['potentialApplications'] as List<String>?,
      estimatedValue: json['estimatedValue'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': createdAt,
      'usageRights': usageRights,
      'culturalContext': culturalContext,
      'voiceCharacteristics': voiceCharacteristics,
      'potentialApplications': potentialApplications,
      'estimatedValue': estimatedValue,
    };
  }

  VoiceCollection copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? status,
    String? createdAt,
    String? usageRights,
    String? culturalContext,
    List<String>? voiceCharacteristics,
    List<String>? potentialApplications,
    String? estimatedValue,
  }) {
    return VoiceCollection(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      usageRights: usageRights ?? this.usageRights,
      culturalContext: culturalContext ?? this.culturalContext,
      voiceCharacteristics: voiceCharacteristics ?? this.voiceCharacteristics,
      potentialApplications: potentialApplications ?? this.potentialApplications,
      estimatedValue: estimatedValue ?? this.estimatedValue,
    );
  }
}
