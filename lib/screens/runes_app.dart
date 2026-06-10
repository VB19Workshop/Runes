import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runes/state/note_data.dart';
import 'package:runes/widgets/edit_note_field.dart';

// This is the screen controller widget
class RunesApp extends StatefulWidget {
  const RunesApp({super.key});

  @override
  State<RunesApp> createState() => _RunesAppState();
}

class _RunesAppState extends State<RunesApp> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteData = Provider.of<NoteData>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF3D3A5B),
      appBar: AppBar(
        toolbarHeight: 132,
        backgroundColor: const Color(0xFF3D3A5B),
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Runes',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Transcribe your way',
                style: TextStyle(fontSize: 14, color: Color(0xFFEDE8FF)),
              ),
              const SizedBox(height: 4),
              Text(
                noteData.randomMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD9C4FF),
                  shadows: [
                    Shadow(color: Color(0x80B59CFF), blurRadius: 10),
                    Shadow(color: Color(0x40B59CFF), blurRadius: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            children: [
              Expanded(
                child: noteData.notes.isEmpty
                    ? Center(
                        child: const Text(
                          'Get inspired and carve your ideas!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFEDE8FF)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: noteData.notes.length,
                        itemBuilder: (context, index) {
                          final note = noteData.notes[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3D3A5B),
                              border: Border.all(
                                color: const Color(0xFF716F8F),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: note.isEditing
                                    ? null
                                    : () => noteData.toggleExpansion(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (!note.isExpanded)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Text(
                                            note.previewLine,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFFF4ECFF),
                                              fontFamily: 'Georgia',
                                            ),
                                          ),
                                        )
                                      else if (note.isEditing)
                                        EditNoteField(
                                          initialText: note.text,
                                          isChecklist: note.isChecklist,
                                          initialChecks: note.checks,
                                          onSave: (newText, updatedChecks) =>
                                              noteData.updateNote(
                                                index,
                                                newText,
                                                updatedChecks,
                                              ),
                                          onCancel: () =>
                                              noteData.toggleEditing(index),
                                        )
                                      else ...[
                                        if (note.isChecklist)
                                          Column(
                                            children: note.lines.asMap().entries.map((
                                              entry,
                                            ) {
                                              final itemIndex = entry.key;
                                              final itemText = entry.value;
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                    ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Checkbox(
                                                      value: note
                                                          .checks[itemIndex],
                                                      onChanged: (_) =>
                                                          noteData.toggleCheck(
                                                            index,
                                                            itemIndex,
                                                          ),
                                                      activeColor: const Color(
                                                        0xFF9F8FE9,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        itemText.isEmpty
                                                            ? '(empty item)'
                                                            : itemText,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Color(
                                                            0xFFF4ECFF,
                                                          ),
                                                          fontFamily: 'Georgia',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        else
                                          Text(
                                            note.text,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFFF4ECFF),
                                              fontFamily: 'Georgia',
                                            ),
                                          ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                tooltip: 'Edit',
                                                onPressed: () => noteData
                                                    .toggleEditing(index),
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Color(0xFFF4ECFF),
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Delete',
                                                onPressed: () =>
                                                    noteData.removeNote(index),
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Color(0xFFF4ECFF),
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Toggle mode',
                                                onPressed: () => noteData
                                                    .toggleChecklistMode(index),
                                                icon: Icon(
                                                  note.isChecklist
                                                      ? Icons.view_agenda
                                                      : Icons
                                                            .check_box_outline_blank,
                                                  color: const Color(
                                                    0xFFF4ECFF,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Color(0xFFF4ECFF)),
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: const TextStyle(color: Color(0xFFD9C4FF)),
                        filled: true,
                        fillColor: const Color(0xFF302F50),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF716F8F),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF716F8F),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF716F8F),
                            width: 2,
                          ),
                        ),
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 52,
                    width: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        noteData.addNote(_controller.text, asChecklist: false);
                        _controller.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D3A5B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: Color(0xFF716F8F)),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.send, color: Color(0xFFEDE8FF)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
