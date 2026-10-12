String formatVariationsByAttribute(List<dynamic>? variations) {
  if (variations == null || variations.isEmpty) return '';

  final Map<String, List<String>> grouped = {};

  for (var v in variations) {
    final attribute = v.attributeName ?? '';
    final name = v.name ?? '';

    if (attribute.isEmpty || name.isEmpty) continue;

    grouped.putIfAbsent(attribute, () => []);
    grouped[attribute]!.add(name);
  }

  return grouped.entries
      .map((e) => "${e.key}: ${e.value.join(', ')}")
      .join('\n');
}
