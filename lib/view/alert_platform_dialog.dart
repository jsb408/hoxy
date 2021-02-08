import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class AlertPlatformDialog extends StatelessWidget {
  const AlertPlatformDialog({required this.title, required this.content, required this.children});

  final Widget title;
  final Widget content;
  final List<AlertPlatformDialogButton> children;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: title,
            content: content,
            actions: [
              for (AlertPlatformDialogButton child in children)
                CupertinoDialogAction(
                  child: child.child,
                  onPressed: () {
                    child.onPressed();
                  },
                ),
            ],
          )
        : AlertDialog(
            title: title,
            content: content,
            actions: [
              for (AlertPlatformDialogButton child in children)
                TextButton(
                  child: child.child,
                  onPressed: child.onPressed,
                ),
            ],
          );
  }
}

class AlertPlatformDialogButton {
  AlertPlatformDialogButton({required this.child, required this.onPressed});

  final Widget child;
  final void Function() onPressed;
}
