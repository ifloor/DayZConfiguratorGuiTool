import 'dart:async';

import 'package:flutter/material.dart';

class StyledAutoComplete {
  static Widget get(
    {
      required List<String> options,
      required String labelText,
      required String initialValue,
      double width = 30,
      double height = 40,
      String? hintText,
      Widget? icon,
      AutocompleteOnSelected<String>? onSelected,
    }
  ) {
    var mutatorHeight = _MutatorHeight(height);
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      onSelected: onSelected,
      optionsBuilder: (TextEditingValue textEditingValue) {
        return _getOptions(textEditingValue, options);
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return _getAutocompleteFieldBuilder(context, textEditingController, focusNode, () { },
            labelText: labelText, width: width, height: mutatorHeight, hintText: hintText, icon: icon, validator: (newValue) {return _validator(newValue, options, mutatorHeight);},
        );
      },
    );
  }

  static FutureOr<Iterable<String>> _getOptions(TextEditingValue textEditingValue, List<String> options) {
    if (textEditingValue.text == '') {
      return const Iterable<String>.empty();
    }
    return options.where((String option) {
      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
    });
  }

  static Widget _getAutocompleteFieldBuilder(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
    {
      required String labelText,
      required double width,
      required _MutatorHeight height,
      String? hintText,
      Widget? icon,
      FormFieldValidator<String>? validator,
    }
  ) {
    return TextFormField(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: textEditingController,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        icon: icon,
        constraints: BoxConstraints.tight(Size(width, height.height)),
        contentPadding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 8),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
    );
  }

  static String? _validator(String? value, List<String> options, _MutatorHeight height) {
    if (options.contains(value)) {
      height.height = 40;
      return null;
    } else {
      height.height = 80;
      return "Invalid option";
    }
  }
}

class _MutatorHeight {
  double height;

  _MutatorHeight(this.height);
}