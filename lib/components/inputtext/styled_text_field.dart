import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledTextField {
  static Widget get(
    {
      TextEditingController? controller,
      ValueChanged<String>? onChanged,
      String? labelText,
      bool readOnly = false,
      double width = 30,
      double height = 40,
      Widget? suffixIcon,
      TextFormatting textFormatting = TextFormatting.NONE,
    }
  ) {
    List<TextInputFormatter>? specificInputFormatters;
    switch (textFormatting) {
      case TextFormatting.NATURAL_NUMBERS :
        specificInputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ];
        break;
      case TextFormatting.INTEGERS:
        specificInputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
        ];
        break;
      case TextFormatting.DECIMALS:
        specificInputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
        ];
        break;
      case TextFormatting.NONE:
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        inputFormatters: specificInputFormatters,
        maxLines: 1,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          constraints: BoxConstraints.tight(Size(width, height)),
          suffixIcon: suffixIcon,
          isDense: true
        ),
      ),
    );
  }
}

enum TextFormatting {
  NONE, INTEGERS, NATURAL_NUMBERS, DECIMALS,
}