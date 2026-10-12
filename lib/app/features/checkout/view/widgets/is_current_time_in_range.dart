bool isCurrentTimeInRange({required String fromTime, required String toTime}) {
  if (fromTime.isEmpty && toTime.isEmpty) {
    return false;
  }
  final now = DateTime.now();

  final fromParts = fromTime.split(":");
  final toParts = toTime.split(":");

  final from = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(fromParts[0]),
    int.parse(fromParts[1]),
  );

  final to = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(toParts[0]),
    int.parse(toParts[1]),
  );

  return now.isAfter(from) && now.isBefore(to);
}
