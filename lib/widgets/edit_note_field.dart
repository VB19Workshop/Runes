import 'package:flutter/material.dart';

class EditNoteField extends StatefulWidget {
  final String initialText;
  final bool isChecklist;
  final List<bool> initialChecks;
  final void Function(String, List<bool>) onSave;
  final VoidCallback onCancel;

  const EditNoteField({
    super.key,
    required this.initialText,
    required this.isChecklist,
    required this.initialChecks,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<EditNoteField> createState() => _EditNoteFieldState();
}

class _EditNoteFieldState extends State<EditNoteField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final TextEditingController _singleController;
  late List<bool> _checks;

  @override
  void initState() {
    super.initState();
    if (widget.isChecklist) {
      final lines = widget.initialText.isEmpty
          ? ['']
          : widget.initialText.split('\n');
      _controllers = lines
          .map((line) => TextEditingController(text: line))
          .toList();
      _focusNodes = List.generate(_controllers.length, (_) => FocusNode());
      _checks = List<bool>.from(widget.initialChecks);
      if (_checks.length < _controllers.length) {
        _checks.addAll(
          List<bool>.filled(_controllers.length - _checks.length, false),
        );
      } else if (_checks.length > _controllers.length) {
        _checks = _checks.sublist(0, _controllers.length);
      }
    } else {
      _controllers = [];
      _focusNodes = [];
      _singleController = TextEditingController(text: widget.initialText);
      _checks = <bool>[];
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    if (!widget.isChecklist) {
      _singleController.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (widget.isChecklist) {
      final keptText = <String>[];
      final keptChecks = <bool>[];
      for (var i = 0; i < _controllers.length; i++) {
        final line = _controllers[i].text.trim();
        if (line.isNotEmpty) {
          keptText.add(line);
          keptChecks.add(_checks[i]);
        }
      }
      widget.onSave(keptText.join('\n'), keptChecks);
      return;
    }

    widget.onSave(_singleController.text, _checks);
  }

  void _handleChecklistLineChanged(int itemIndex, String value) {
    if (!value.contains('\n')) {
      return;
    }

    final parts = value.split('\n');
    final firstLine = parts.first;
    final newLines = parts.sublist(1);

    final controller = _controllers[itemIndex];
    controller.text = firstLine;
    controller.selection = TextSelection.collapsed(offset: firstLine.length);

    final newControllers = newLines
        .map((line) => TextEditingController(text: line))
        .toList();
    final newFocusNodes = List<FocusNode>.generate(
      newControllers.length,
      (_) => FocusNode(),
    );

    setState(() {
      _controllers.insertAll(itemIndex + 1, newControllers);
      _focusNodes.insertAll(itemIndex + 1, newFocusNodes);
      _checks.insertAll(
        itemIndex + 1,
        List<bool>.filled(newControllers.length, false),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final nextIndex = itemIndex + 1;
      if (nextIndex < _focusNodes.length) {
        _focusNodes[nextIndex].requestFocus();
        _controllers[nextIndex].selection = TextSelection.collapsed(
          offset: _controllers[nextIndex].text.length,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isChecklist)
          Column(
            children: _controllers.asMap().entries.map((entry) {
              final itemIndex = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _checks[itemIndex],
                      onChanged: (value) {
                        setState(() {
                          _checks[itemIndex] = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF9F8FE9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: _focusNodes[itemIndex],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFF4ECFF),
                          fontFamily: 'Georgia',
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: const Color(0xFFD9C4FF),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        minLines: 1,
                        maxLines: 3,
                        onChanged: (value) =>
                            _handleChecklistLineChanged(itemIndex, value),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        else
          TextField(
            controller: _singleController,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFF4ECFF),
              fontFamily: 'Georgia',
            ),
            cursorColor: const Color(0xFFD9C4FF),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            minLines: 1,
            maxLines: 6,
          ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              onPressed: _save,
              icon: const Icon(Icons.save, color: Color(0xFFEDE8FF)),
            ),
            IconButton(
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              onPressed: widget.onCancel,
              icon: const Icon(Icons.close, color: Color(0xFFEDE8FF)),
            ),
          ],
        ),
      ],
    );
  }
}
