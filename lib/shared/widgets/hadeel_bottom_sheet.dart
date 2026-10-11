import 'package:flutter/material.dart';

import 'liquid_glass.dart';

/// Opens a modal bottom sheet with Hadeel defaults (drag handle, safe area,
/// keyboard-aware, height capped at 90% of the screen).
Future<T?> showHadeelBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool expand = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    showDragHandle: false,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.9,
    ),
    builder: (context) => LiquidGlass(
      radius: 32,
      blur: 10,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: expand
            ? SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.85,
                child: builder(context),
              )
            : builder(context),
      ),
    ),
  );
}
