enum SortOrder implements Comparable<SortOrder> {
  az(niceName: 'A-Z'),
  za(niceName: 'Z-A'),
  newest(niceName: 'Newest First'),
  oldest(niceName: 'Oldest First');

  const SortOrder({required this.niceName});

  @override
  int compareTo(SortOrder other) => niceName.compareTo(other.niceName);

  final String niceName;
}
