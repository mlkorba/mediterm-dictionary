class Definition {
  final String term;
  final String definition;

  Definition({required this.term, required this.definition});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      term: json['term'] ?? '',
      definition: json['definition'] ?? '',
    );
  }
}
