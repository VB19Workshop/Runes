import 'package:flutter/material.dart';

class WhatsNewScreen extends StatelessWidget {
  final VoidCallback onClose;

  const WhatsNewScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(220, 20, 15, 30),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 67, 55, 83),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBFAFD4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome to Runes!",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFF4ECFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "This app was built as a passion project since all the good note apps had...ads.But NOT RUNES! This app will remain FREE!\nBefore you go on here are some cool features I'm working on adding:\n-EDIT PLUS functions so you can make checkboxes, bulletpoints, page dividers; and create headers!\n-THEMES! Handfuls of new color themes so you can enjoy writing your way!\n-RUNE POOLS! This is a feature that'll let you create groups of runes so you can truly write on your terms!",
                style: TextStyle(color: Color(0xFFBFAFD4)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onClose,
                child: const Text("Close"),
              )
            ],
          ),
        ),
      ),
    );
  }
}