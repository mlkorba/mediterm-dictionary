// ignore_for_file: unnecessary_null_comparison

class Definition {
  final String id;
  final String term;
  final String definition;
  final List<String> stems;
  final Map<String, dynamic> hwi;
  final List<Map<String, dynamic>> prs;
  final String fl;
  final List<Map<String, dynamic>> def;
  bool isBookmarked;

  Definition({
    required this.id,
    required this.term,
    required this.definition,
    required this.stems,
    required this.hwi,
    required this.prs,
    required this.fl,
    required this.def,
    this.isBookmarked = false, // Provide a default value
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw ArgumentError('json must not be null');
    }

    final meta = json['meta'] as Map<String, dynamic>? ?? {};

    final id = meta['id'] as String? ?? ''; // Use 'id' instead of 'uuid'
    final term = json['hwi']['hw'] as String? ?? '';
    final stems = (meta['stems'] as List<dynamic>?)
            ?.map((stem) => stem as String)
            .toList() ??
        [];
    final hwi = json['hwi'] as Map<String, dynamic>? ?? {};
    final prs = (hwi['prs'] as List<dynamic>?)
            ?.map((prs) => prs as Map<String, dynamic>)
            .toList() ??
        [];
    final fl = json['fl'] as String? ?? '';
    final def = (json['def'] as List<dynamic>?)
            ?.map((d) => d as Map<String, dynamic>)
            .toList() ??
        [];

    return Definition(
      id: id,
      term: term,
      definition:
          '', // You can leave the definition empty or provide another field if needed
      stems: stems,
      hwi: hwi,
      prs: prs,
      fl: fl,
      def: def,
    );
  }
}
