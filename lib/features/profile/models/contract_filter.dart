/// Represents filtering options for contracts
class ContractFilter {
  /// The status to filter contracts by (e.g., 'active', 'pending', 'completed')
  final String? status;
  
  /// The type of contract to filter by
  final String contractType;
  
  /// The category of contract to filter by
  final String? category;
  
  /// The date range to filter contracts by
  final DateTimeRange? dateRange;
  
  /// Additional custom filters as key-value pairs
  final Map<String, dynamic>? additionalFilters;

  /// Creates a new ContractFilter instance
  const ContractFilter({
    this.status,
    required this.contractType,
    this.category,
    this.dateRange,
    this.additionalFilters,
  });

  /// Creates a copy of this filter with some fields replaced
  ContractFilter copyWith({
    String? status,
    String? contractType,
    String? category,
    DateTimeRange? dateRange,
    Map<String, dynamic>? additionalFilters,
  }) {
    return ContractFilter(
      status: status ?? this.status,
      contractType: contractType ?? this.contractType,
      category: category ?? this.category,
      dateRange: dateRange ?? this.dateRange,
      additionalFilters: additionalFilters ?? this.additionalFilters,
    );
  }
}

/// Represents a date range for filtering
class DateTimeRange {
  /// The start date of the range
  final DateTime start;
  
  /// The end date of the range
  final DateTime end;

  /// Creates a new DateTimeRange instance
  const DateTimeRange({
    required this.start,
    required this.end,
  });
}
