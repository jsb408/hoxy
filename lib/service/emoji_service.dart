import 'dart:math';

// ignore: import_of_legacy_library_into_null_safe
import 'package:emojis/emoji.dart';

class EmojiService {
  static String randomEmoji() {
    List<String> emojis = Emoji.all().map((e) => e.toString()).toList();
    return emojis[Random().nextInt(emojis.length)];
  }
}