import 'dart:math';

import 'package:emojis/emoji.dart';

class EmojiService {
  static String randomEmoji() {
    List<String> emojis = Emoji.all().map((e) => e.toString()).toList();
    return emojis[Random().nextInt(emojis.length)];
  }
}