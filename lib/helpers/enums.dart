enum SortType {
  none(label: 'None'),
  minYear(label: 'Min year'),
  maxYear(label: 'Max year');

  final String label;

  const SortType({required this.label});
}