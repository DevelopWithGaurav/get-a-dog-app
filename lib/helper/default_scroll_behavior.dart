import 'package:flutter/material.dart';

/// using this(DefaultScrollBehaviour) to set BouncingScrollPhysics...
/// as default across...
/// whole application.

class DefaultScrollBehaviour extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      default:
        return super.getScrollPhysics(context);
    }
  }
}
