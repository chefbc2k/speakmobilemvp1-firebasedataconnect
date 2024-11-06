enum VoiceContractCategory {
  entertainment,
  advertising,
  education,
  technology,
  corporate,
  healthcare,
  government,
  transportation,
  hospitality,
  retail,
  religious,
  realEstate,
  events,
  podcasts,
  legal,
  finance,
}

class VoiceContractType {
  final String id;
  final VoiceContractCategory category;
  final String subcategory;
  final String title;
  final String description;
  final Map<String, dynamic> paymentStructure;
  final Map<String, dynamic>? metadata;

  const VoiceContractType({
    required this.id,
    required this.category,
    required this.subcategory,
    required this.title,
    required this.description,
    required this.paymentStructure,
    this.metadata,
  });

  static List<String> getSubcategories(VoiceContractCategory category) {
    switch (category) {
      case VoiceContractCategory.entertainment:
        return ['Animation', 'Film and Television', 'Radio', 'Video Games', 'Audiobooks'];
      case VoiceContractCategory.advertising:
        return ['TV Commercials', 'Radio Ads', 'Online Ads', 'Corporate Videos'];
      case VoiceContractCategory.education:
        return ['Online Courses', 'Training Videos', 'Educational Apps'];
      // Add other categories...
      default:
        return [];
    }
  }

  static String categoryToString(VoiceContractCategory category) {
    return category.toString().split('.').last
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
        )
        .trim()
        .replaceFirstMapped(
          RegExp(r'^.'),
          (match) => match.group(0)?.toUpperCase() ?? '',
        );
  }
} 