import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PlatformActionSheet extends StatelessWidget {
  PlatformActionSheet({required this.actions, this.cancelButton});

  final List<PlatformActionSheetAction> actions;
  final Widget? cancelButton;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  actions: actions,
                  cancelButton: cancelButton,
                ),
              );
            },
          )
        : PopupMenuButton(
            onSelected: (value) {
              actions.singleWhere((element) => element.value == value).onPressed();
            },
            itemBuilder: (BuildContext context) => [
              for (PlatformActionSheetAction action in actions)
                PopupMenuItem(
                  value: action.value,
                  child: action.child,
                ),
            ],
          );
  }
}

class PlatformActionSheetAction extends StatelessWidget {
  PlatformActionSheetAction(
      {this.isDestructiveAction = false, required this.value, required this.child, required this.onPressed});

  final bool isDestructiveAction;
  final int value;
  final Widget child;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      isDestructiveAction: isDestructiveAction,
      onPressed: () {
        Navigator.pop(context);
        onPressed();
      },
      child: child,
    );
  }
}
