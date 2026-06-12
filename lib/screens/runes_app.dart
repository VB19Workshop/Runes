import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:runes/state/runes_data.dart';
import 'package:runes/models/runes_theme.dart';
import 'package:runes/widgets/edit_note_field.dart';
import 'package:runes/screens/whats_new.dart';

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
    final runeData = Provider.of<RunesData>(context);
    final notes = runeData.notes;
    final isEditingAnyNote = notes.any((n) => n.isEditing);
    final theme = context.watch<RunesData>().currentTheme;
    
    // UI Visuals
    return Scaffold(
      backgroundColor: theme.background,

      appBar: AppBar(
        toolbarHeight: 132,
        backgroundColor: theme.background,
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    theme.runeIcon, 
                    height: 24,
                    key: ValueKey(theme.runeIcon)
                    ),
                  const SizedBox(width: 8),
                  Text(
                    'Runes',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: theme.text,
                    ),
                  )
                ]
              ),
              const SizedBox(height: 4),
              Text(
                runeData.randomMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.backgroundText,
                ),
              ),
            ],
          ),
        ),
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.translucent,

        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;

          if (velocity > 0) {
            runeData.nextTheme();
          } else if (velocity < 0) {
            runeData.previousTheme();
          }
        },

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Column(
              children: [

            if (runeData.showWhatsNew)
              WhatsNewScreen(
                onClose: () {
                  runeData.dismissWhatsNew();
                },
              ),

              Expanded(
                child: notes.isEmpty
                    ?  Center(
                        child: Text(
                          'Get inspired and carve your ideas!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.backgroundText,
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
                              color: theme.noteBox,
                              border: Border.all(
                                color: theme.border,
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
                                    : () => runeData.toggleExpansion(index),

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
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: theme.text,
                                          ),
                                        )

                                      else if (note.isEditing)
                                        EditNoteField(
                                          initialText: note.text,
                                          isChecklist: note.isChecklist,
                                          initialChecks: note.checks,
                                          onSave: (newText, updatedChecks) =>
                                              runeData.updateNote(
                                                index,
                                                newText,
                                                updatedChecks,
                                              ),
                                          onCancel: () =>
                                              runeData.toggleEditing(index),
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
                                                          runeData.toggleCheck(index, itemIndex),
                                                      activeColor: theme.noteBox,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        itemText.isEmpty
                                                            ? '(empty item)'
                                                            : itemText,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: theme.text,
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
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: theme.text,
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
                                                      ? () => runeData.moveNote(index, index - 1)
                                                      : null,
                                                  icon: Icon(
                                                    Icons.arrow_upward,
                                                    color: index > 0
                                                        ? theme.text
                                                        : const Color(0x20F4ECFF),
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Move Down',
                                                  onPressed: index < notes.length - 1
                                                      ? () => runeData.moveNote(index, index + 1)
                                                      : null,
                                                  icon: Icon(
                                                    Icons.arrow_downward,
                                                    color: index < notes.length - 1
                                                        ? theme.text
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
                                                      runeData.toggleEditing(index),
                                                  icon: const Icon(Icons.edit,
                                                      color: Color(0xFFF4ECFF)),
                                                ),
                                                IconButton(
                                                  tooltip: 'Delete',
                                                  onPressed: () =>
                                                      runeData.removeNote(index),
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
                        style: TextStyle(
                          color: theme.text,
                        ),
                        decoration: InputDecoration(
                          hintText: runeData.currentPrompt,
                          hintStyle: TextStyle(
                            color: theme.placeholderText,
                          ),
                          filled: true,
                          fillColor: theme.promptBox,
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
                          runeData.addNote(_controller.text);
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
      )
    );
  }
}