import 'package:flutter/material.dart';

import 'liquid_glass.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.autofocus = false,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      radius: 22,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          hintText: hint,
          prefixIcon: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}
