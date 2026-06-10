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
    final notes = noteData.notes;
    final isEditingAnyNote = notes.any((n) => n.isEditing);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 82, 69, 100),

      appBar: AppBar(
        toolbarHeight: 132,
        backgroundColor: const Color.fromARGB(255, 82, 69, 100),
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
              Text(
                noteData.randomMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 191, 175, 212),
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
                child: notes.isEmpty
                    ? const Center(
                        child: Text(
                          'Get inspired and carve your ideas!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 191, 175, 212),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 67, 55, 83),
                              border: Border.all(
                                color: const Color.fromARGB(207, 191, 175, 212),
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
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [

                                      // ─────────────────────────
                                      // CONTENT AREA (UNIFIED SPACING)
                                      // ─────────────────────────

                                      if (!note.isExpanded)
                                        const SizedBox(height: 8),

                                      if (!note.isExpanded)
                                        Text(
                                          note.previewLine,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFFF4ECFF),
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
                                            children: note.lines.asMap().entries.map((entry) {
                                              final itemIndex = entry.key;
                                              final itemText = entry.value;

                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Checkbox(
                                                      value: note.checks[itemIndex],
                                                      onChanged: (_) =>
                                                          noteData.toggleCheck(index, itemIndex),
                                                      activeColor: const Color(0xFF574571),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        itemText.isEmpty
                                                            ? '(empty item)'
                                                            : itemText,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xFFF4ECFF),
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
                                            ),
                                          ),

                                        const SizedBox(height: 8),

                                        // ─────────────────────────
                                        // BUTTON ROW (FIXED ALIGNMENT SYSTEM)
                                        // ─────────────────────────

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [

                                            // LEFT (MOVE)
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  tooltip: 'Move Up',
                                                  onPressed: index > 0
                                                      ? () => noteData.moveNote(index, index - 1)
                                                      : null,
                                                  icon: Icon(
                                                    Icons.arrow_upward,
                                                    color: index > 0
                                                        ? const Color(0xFFF4ECFF)
                                                        : const Color(0x20F4ECFF),
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Move Down',
                                                  onPressed: index < notes.length - 1
                                                      ? () => noteData.moveNote(index, index + 1)
                                                      : null,
                                                  icon: Icon(
                                                    Icons.arrow_downward,
                                                    color: index < notes.length - 1
                                                        ? const Color(0xFFF4ECFF)
                                                        : const Color(0x20F4ECFF),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // RIGHT (ACTIONS)
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  tooltip: 'Edit',
                                                  onPressed: () =>
                                                      noteData.toggleEditing(index),
                                                  icon: const Icon(Icons.edit,
                                                      color: Color(0xFFF4ECFF)),
                                                ),
                                                IconButton(
                                                  tooltip: 'Delete',
                                                  onPressed: () =>
                                                      noteData.removeNote(index),
                                                  icon: const Icon(Icons.delete,
                                                      color: Color(0xFFF4ECFF)),
                                                ),
                                                /*IconButton(
                                                  tooltip: 'Toggle mode',
                                                  onPressed: () =>
                                                      noteData.toggleChecklistMode(index),
                                                  icon: Icon(
                                                    note.isChecklist
                                                        ? Icons.view_agenda
                                                        : Icons.check_box_outline_blank,
                                                    color: const Color(0xFFF4ECFF),
                                                  ),
                                                ),*/
                                              ],
                                            ),
                                          ],
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

              // ─────────────────────────
              // INPUT BAR (HIDES DURING EDITING)
              // ─────────────────────────

              if (!isEditingAnyNote) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 243, 236, 252),
                        ),
                        decoration: InputDecoration(
                          hintText: "What's on your mind?",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(120, 191, 175, 212),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 38, 33, 44),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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
                          noteData.addNote(_controller.text);
                          _controller.clear();
                        },
                        child: const Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}