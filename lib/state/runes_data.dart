import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:runes/models/note.dart';

class RunesData extends ChangeNotifier {
  static const _storageKey = 'runes_saved_notes';

  // Name of save file
  final List<Note> _notes = [Note("Welcome to Runes!\nThis is a hidden line.")];

  late final String _sessionMessage;

  NoteData() {
    final messages = [
      "Seek the wisdom of the ancients.",
      "Every word carved is a memory saved.",
      "Let your thoughts flow like currents.",
      "The stars guide your ink today.",
    ];

    final now = DateTime.now();
    final seed = now.year * 1000 + now.dayOfYear;

    _sessionMessage = messages[seed % messages.length];

    _loadNotes();
  }

  Future<void> _loadNotes() async {
    // These get the storage file
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    // If there's no storage file or it's empty we just leave
    if (jsonString == null || jsonString.isEmpty) {
      return;
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      _notes
        ..clear()
        ..addAll(decoded.whereType<Map<String, dynamic>>().map(Note.fromJson));

      notifyListeners(); // Informs UI data is changed and needs to be rebuilt
    } catch (_) {}
    // Ignore invalid saved data and keep default note.
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _notes.map((note) => note.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encoded);

    // Doesn't notifyListeners since UI doesn't change
  }

  // This make the private variables public
  String get randomMessage => _sessionMessage;

  // Ensures NoteData isn't modified directly
  List<Note> get notes => List.unmodifiable(_notes);
  

  void addNote(String text, {bool asChecklist = false}) {
    if (text.trim().isEmpty) return;
    _notes.add(
      Note(
        text,
        isChecklist: asChecklist,
        checks: asChecklist
            ? List<bool>.filled(text.split('\n').length, false)
            : null,
      ),
    );

    _saveNotes();
    notifyListeners();
  }

  void removeNote(int index) {
    _notes.removeAt(index);

    _saveNotes();
    notifyListeners();
  }

  void toggleExpansion(int index) {
    final note = _notes[index];
    note.isExpanded = !note.isExpanded;
    note.isEditing = false;

    notifyListeners();
  }

  void toggleEditing(int index) {
    _notes[index].isEditing = !_notes[index].isEditing;

    notifyListeners();
  }

  void toggleChecklistMode(int index) {
    final note = _notes[index];
    note.isChecklist = !note.isChecklist;
    if (note.isChecklist) {
      note.checks = List<bool>.filled(note.lines.length, false);
    } else {
      note.checks = <bool>[];
    }

    _saveNotes();
    notifyListeners();
  }

  void moveNote(int oldIndex, int newIndex) {
    if (newIndex < 0 || newIndex >= _notes.length) return;

    final note = _notes.removeAt(oldIndex);
    _notes.insert(newIndex, note);

    _saveNotes();
    notifyListeners();
  }

  void updateNote(int index, String newText, [List<bool>? updatedChecks]) {
    final note = _notes[index];
    if (newText.trim().isEmpty) {
      // If the note is empty it gets deleted
      _notes.removeAt(index);
    } else {
      // If it's not empty text is set and editing is turned off
      note.text = newText;
      note.isEditing = false;

      if (note.isChecklist) {
        // If it's a checklist note it rebuilds checkboxes to match the lines
        final textLines = note.lines;
        final checks = updatedChecks ?? note.checks;
        final normalized = List<bool>.filled(textLines.length, false);

        for (var i = 0; i < textLines.length && i < checks.length; i++) {
          normalized[i] = checks[i];
        }
        note.checks = normalized;
      } else {
        // If not a checklist note
        note.checks = <bool>[];
      }
    }
    _saveNotes();
    notifyListeners();
  }

  void toggleCheck(int index, int itemIndex) {
    final note = _notes[index];
    if (!note.isChecklist) return;
    if (itemIndex < 0 || itemIndex >= note.checks.length) return;
    note.checks[itemIndex] = !note.checks[itemIndex];
    _saveNotes();
    notifyListeners();
  }
}

// Dev Notes:
// Async means you're not waiting for it but it runs function in background
// Future means the function finishes later
// _variable is a private variable. variable is a public variable.

extension DateHelpers on DateTime {
  int get dayOfYear {
    final start = DateTime(year, 1, 1);
    return difference(start).inDays;
  }
}
