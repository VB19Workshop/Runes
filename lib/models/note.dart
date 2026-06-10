class Note {
  String text;
  bool isExpanded;
  bool isEditing;
  bool isChecklist;
  List<bool> checks;

  Note(
    // This is the constructor of what's needed when creating a note object
    this.text, {
    this.isExpanded = false,
    this.isEditing = false,
    this.isChecklist = false,

    // This checks for checklist toggle note [THIS WILL BE LEGACY IN V2]
    List<bool>? checks,
  }) : checks =
           checks ??
           (isChecklist
               ? List<bool>.filled(text.split('\n').length, false) // True
               : <bool>[]); // False

  // Dev Notes:
  // : checks is an Initializer List which runs before the constructor body.

  // If line is empty
  List<String> get lines => text.split('\n');

  // The first line is the "Header" of the note
  String get previewLine => lines.isNotEmpty ? lines.first : '';

  // Ensures checklist state always matches number of lines
  void normalizeChecks() {
    if (!isChecklist) {
      checks = <bool>[];
      return;
    }

    final items = lines.length;
    final normalized = List<bool>.from(checks);

    if (normalized.length < items) {
      normalized.addAll(List<bool>.filled(items - normalized.length, false));
    } else if (normalized.length > items) {
      normalized.removeRange(items, normalized.length);
    }

    checks = normalized;
  }

  // Stores note to Json file format
  Map<String, dynamic> toJson() => {
    // Converts object into Json file
    'text': text,
    'isExpanded': isExpanded,
    'isEditing': isEditing,
    'isChecklist': isChecklist,
    'checks': checks,
  };

  // Used for loading object from saved data
  factory Note.fromJson(Map<String, dynamic> json) {
    final checksJson = json['checks'] as List<dynamic>?;
    return Note(
      json['text'] as String? ?? '',
      isExpanded: json['isExpanded'] as bool? ?? false,
      isEditing: json['isEditing'] as bool? ?? false,
      isChecklist: json['isChecklist'] as bool? ?? false,
      checks: checksJson?.whereType<bool>().toList() ?? <bool>[],
    );
  }
}
