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
      Function(String typedOption)? onChanged,
    }
  ) {
    Function(String typedOption)? mutatedOnChange;
    if (onChanged != null) {
      mutatedOnChange = _wrapOnChanged(onChanged, options);
    }

    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      onSelected: onSelected,
      optionsBuilder: (TextEditingValue textEditingValue) {
        return _getOptions(textEditingValue, options);
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        textEditingController.text = initialValue;
        return _getAutocompleteFieldBuilder(context, textEditingController, focusNode, () { },
            labelText: labelText, width: width, height: height, hintText: hintText, icon: icon, validator: (newValue) {return _validator(newValue, options);},
            onChange: mutatedOnChange,
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
      required double height,
      String? hintText,
      Widget? icon,
      FormFieldValidator<String>? validator,
      Function(String)? onChange,
    }
  ) {
    return _wrapInCol(_wrapInRow(
      TextFormField(
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textEditingController,
        focusNode: focusNode,
        onChanged: onChange,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          icon: icon,
          constraints: BoxConstraints.tight(Size(width, height)),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      )
    ));
  }

  static Widget _wrapInCol(Widget widget) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 8),
          widget,
        ]
    );
  }

  static Widget _wrapInRow(Widget widget) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(width: 2),
          widget,
        ]
    );
  }

  static String? _validator(String? value, List<String> options) {
    if (options.contains(value)) {
      return null;
    } else {
      return "Invalid option";
    }
  }

  static Function(String typedOption) _wrapOnChanged(Function(String typedOption) originalOnChange, List<String> options) {
    return (String typedText) {
      if (options.contains(typedText)) {
        originalOnChange(typedText);
      }
    };
  }
}