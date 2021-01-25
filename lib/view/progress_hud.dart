import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';

class ProgressHUD extends ModalProgressHUD {
  ProgressHUD(
      {@required this.inAsyncCall,
      @required this.child,
      this.progressIndicator =
          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor))})
      : super(inAsyncCall: inAsyncCall, child: child, progressIndicator: progressIndicator);

  final bool inAsyncCall;
  final Widget child;
  final Widget progressIndicator;
}