class Definition {
  final String term;
  final String definition;

  Definition._({required this.term, required this.definition});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition._(
      term: json['term'] ?? '',
      definition: json['definition'] ?? '',
    );
  }
}
