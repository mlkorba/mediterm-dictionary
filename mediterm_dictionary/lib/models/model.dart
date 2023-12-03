class Definition {
  final String term;
  final String definition;

  Definition({
    required this.term,
    required this.definition,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw ArgumentError('json must not be null');
    }

    final hwi = json['hwi'] as Map<String, dynamic>? ?? {};
    final term = hwi['hw'] as String? ?? '';

    return Definition(
      term: term,
      definition:
          '', // You can leave the definition empty or provide another field if needed
    );
  }
}
