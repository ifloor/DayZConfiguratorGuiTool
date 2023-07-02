import 'package:flutter/material.dart';

class StyledTextField {
  static Widget get(
    {
      TextEditingController? controller,
      ValueChanged<String>? onChanged,
      String? labelText,
      bool readOnly = false,
      double width = 30,
      double height = 40,
    }
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          constraints: BoxConstraints.tight(Size(width, height)),
        ),
      ),
    );
  }
}