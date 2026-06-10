import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:runes/models/note.dart';

class RunesData extends ChangeNotifier {
  static const _storageKey = 'runes_saved_notes';

  bool _showWhatsNew = false;
  bool get showWhatsNew => _showWhatsNew;

  // Name of save file
  final List<Note> _notes = [];

  // DAILY MESSAGE

  late final String _sessionMessage;
  RunesData() { // Runs when the app is loaded
    _initVersionCheck();
    
    final messages = [
      "Seek the wisdom of your words.",
      "Every word carved is a memory saved.",
      "Let your thoughts flow like currents.",
      "The stars guide your ink today.",
      "Today, you are the fates.",
      "Write your story, one rune at a time.",
      "In the silence, your thoughts speak.",
      "Sip a brew and let your mind wander.",
      "Each rune is a step on your journey.",
      "The runes reveal what the heart whispers.",
      "Don't let the day pass without leaving a mark.",
      "Your thoughts are the true magic.",
      "May your day be filled with inspiration and clarity.",
      "Your story awaits!",
      "Stay creative, stay curious.",
      "Embrace the journey of self-discovery.",
      "Curiosity is the key to unlocking new paths.",
      "Fortune favors the bold, write your fortune today.",
      "Runes hold the secrets of your soul, what will they reveal?",
      "Runes are the language of the universe, speak your truth.",
      "Embrace the past and forge your future!",
    ];

    final now = DateTime.now();
    final seed = now.year * 1000 + now.dayOfYear;

    _sessionMessage = messages[seed % messages.length];

    generatePrompt();

    _loadNotes();
  }

  // WRITE PROMPTS
  final List<String> _prompts = [
    "What's on your mind?",
    "Write something small.",
    "Capture a thought before it's gone.",
    "Start with one idea.",
    "What needs your attention?",
    "Got any stories?",
    "Turn a thought into story.",
    "Begin anywhere and end somewhere.",
    "What's worth remembering?",
    "Put it into words.",
    "Let it be messy.",
    "One sentence is enough.",
    "Write the thing you're avoiding.",
    "Start with a fragment.",
    "What's been repeating in your head?",
    "Put your thoughts somewhere real.",
    "Write without editing.",
    "Just begin.",
    "What matters right now?",
    "Leave a trace of today.",
  ];

  String _currentPrompt = "";
  String get currentPrompt => _currentPrompt;
  
  final _random = Random();

  void generatePrompt() {
    _currentPrompt = _prompts[_random.nextInt(_prompts.length)];

    notifyListeners(); // Informs UI data is changed and needs to be rebuilt
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

    generatePrompt();

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

  Future<void> _initVersionCheck() async {
  final prefs = await SharedPreferences.getInstance();
  final lastVersion = prefs.getString("last_seen_version");

  final info = await PackageInfo.fromPlatform();
  final currentVersion = info.version;

  if (lastVersion != currentVersion) {
    _showWhatsNew = true; // or similar flag
  }

  await prefs.setString("last_seen_version", currentVersion);
  }

  void dismissWhatsNew() async {
    _showWhatsNew = false;

    final prefs = await SharedPreferences.getInstance();
    final info = await PackageInfo.fromPlatform();

    await prefs.setString("last_seen_version", info.version);

    notifyListeners();

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
