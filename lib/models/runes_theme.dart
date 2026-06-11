import 'package:flutter/material.dart';

  final List<RunesTheme> themes = [
    tyrianTheme,
    kvasirTheme,
  ];

class RunesTheme{
  final Color background;
  final Color noteBox;
  final Color promptBox;

  final Color border;
  final Color secondaryBorder;

  final Color text;
  final Color backgroundText;
  final Color placeholderText;

  const RunesTheme({required this.background, required this.noteBox, required this.promptBox, 
                     required this.border, required this.secondaryBorder, 
                     required this.text, required this.backgroundText, required this.placeholderText
                   });

}

  const tyrianTheme = RunesTheme(
  // This theme is based on Tyrian Purple
  // Purple was expensive to the Scandavian people
  // So it signified nobility/rank
  // In modern times it's associated with remembering
  // Together it marks this app as a place of remembrance and reflection
  // As well as something premium, something that will leave its mark.

  // Background - Core Runes purple
  background: Color(0xFF524564),

  // Note box - slightly deeper purple for layering
  noteBox: Color(0xFF433753),

  // Prompt box - darkest surface tone (UI depth)
  promptBox: Color(0xFF26212C),

  // Borders - soft rune glow (light lavender)
  border: Color.fromARGB(207, 191, 175, 212),

  // Secondary borders - faded version for subtle UI separation
  secondaryBorder: Color.fromARGB(120, 191, 175, 212),

  // Main text - soft parchment-lavender white
  text: Color(0xFFF4ECFF),

  // Background text - muted rune glow (less emphasis)
  backgroundText: Color.fromARGB(255, 191, 175, 212),

  // Placeholder text - very faded version for input hints
  placeholderText: Color.fromARGB(120, 191, 175, 212),
);
  
  const kvasirTheme = RunesTheme(
    // This theme is based on Kvasir who was a deity of wisdom and poetry
    // It was said his blood mixed with honey created the Mead of Poetry.

  // Background - deep warm red-brown
  background: Color(0xFF3B1F1F),

  // Note box - slightly lifted, warm ember tone
  noteBox: Color(0xFF4A2A2A),

  // Prompt box - darker, like carved wood shadow
  promptBox: Color(0xFF2A1616),

  // Borders - golden mead glow
  border: Color.fromARGB(200, 212, 170, 80),
  secondaryBorder: Color.fromARGB(120, 212, 170, 80),

  // Main text - warm parchment
  text: Color(0xFFFFF3D6),

  // Secondary text - muted gold
  backgroundText: Color(0xFFD4AA50),

  // Placeholder - faded gold
  placeholderText: Color.fromARGB(120, 212, 170, 80),
);

const odinTheme = RunesTheme(
// This theme is based on Odin, the Allfather, the god of the sky and prophecy
// Blue often meant Divine Connection, the sky; and mystery in Norse history.
// And Odin matches all 3 of those meanings.

  // Background - deep charcoal stone
  background: Color(0xFF1E1F24),

  // Note box - slightly lifted slate/ash surface
  noteBox: Color(0xFF2A2C33),

  // Prompt box - darkest carved stone tone
  promptBox: Color(0xFF15161A),

  // Borders - muted lapis glow (not neon, more mineral dust)
  border: Color.fromARGB(200, 90, 140, 190),
  secondaryBorder: Color.fromARGB(120, 90, 140, 190),

  // Main text - soft cold parchment-white
  text: Color(0xFFE6ECF5),

  // Background text - desaturated lapis hint
  backgroundText: Color.fromARGB(255, 120, 160, 200),

  // Placeholder text - faint mineral fog
  placeholderText: Color.fromARGB(120, 120, 160, 200),
);

const solTheme = RunesTheme(
// This theme is based on Sol, the sun god in Norse mythology
// Yellow often represented the sun and life in Norse culture.
// Sol is the deity of the sun and therefore life.

  // Background - warm dusk stone (sun-bleached charcoal)
  background: Color(0xFF2A241C),

  // Note box - sunlit clay / sandstone
  noteBox: Color(0xFF3A2F22),

  // Prompt box - deeper shadowed earth tone
  promptBox: Color(0xFF1E1A14),

  // Borders - golden sunlight edge
  border: Color.fromARGB(210, 240, 180, 70),

  // Secondary borders - faded amber glow
  secondaryBorder: Color.fromARGB(120, 240, 180, 70),

  // Main text - warm parchment light
  text: Color(0xFFFFF1D6),

  // Background text - soft sun-bleached gold
  backgroundText: Color(0xFFE6B85C),

  // Placeholder text - very faded ember tone
  placeholderText: Color.fromARGB(120, 230, 184, 92),
);

const helTheme = RunesTheme(
// This theme is based on Hel, the goddess of the underworld in Norse mythology
// Black and dark colors in any culture have represented death.

  // Background - deep graphite void (not pure black)
  background: Color(0xFF121316),

  // Note box - slightly lifted slate panel
  noteBox: Color(0xFF1B1D22),

  // Prompt box - near-void surface separation
  promptBox: Color(0xFF0E0F12),

  // Borders - subtle cold grey line
  border: Color.fromARGB(180, 160, 160, 160),

  // Secondary borders - almost invisible separation
  secondaryBorder: Color.fromARGB(90, 160, 160, 160),

  // Main text - soft neutral white (not warm)
  text: Color(0xFFE6E6E6),

  // Background text - muted grey hint
  backgroundText: Color.fromARGB(255, 140, 140, 140),

  // Placeholder text - very faint grey fog
  placeholderText: Color.fromARGB(120, 140, 140, 140),
);