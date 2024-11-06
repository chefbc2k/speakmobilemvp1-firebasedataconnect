enum TimeRange {
  day('24 Hours'),
  week('7 Days'),
  month('30 Days'),
  quarter('90 Days');

  final String label;
  const TimeRange(this.label);
}
