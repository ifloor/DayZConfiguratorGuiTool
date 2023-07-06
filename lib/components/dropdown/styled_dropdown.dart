import 'package:dayz_configurator_gui_tool/components/bordering/labeled_container.dart';
import 'package:dayz_configurator_gui_tool/components/labelable_object.dart';
import 'package:flutter/material.dart';

class StyledDropdown<T extends LabelableObject?> extends StatelessWidget {

  late StyledDropdownStyle _style;
  late List<T> _options;
  T? _initialValue;
  late Function(T?) _onChanged;
  String? _hint;
  String? _label;


  StyledDropdown(
      {super.key,
        required Function(T?) onChanged,
        StyledDropdownStyle style = StyledDropdownStyle.JUST_LABEL,
        List<T>? options,
        T? initialValue,
        String? hint,
        String? label,
      }) {
    this._style = style;
    this._options = options ?? [];
    this._initialValue = initialValue;
    this._onChanged = onChanged;
    this._hint = hint;
    this._label = label;
  }

  @override
  Widget build(BuildContext context) {
    return LabeledContainer(
      label: _label ?? "",
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: this._initialValue,
          onChanged: (T? value) {
            this._onChanged(value);
          },
          hint: this._hint != null ? Text(this._hint!) : null,
          items: this._options
              .map<DropdownMenuItem<T>>((T value) {
            Widget child;
            switch(_style) {
              case StyledDropdownStyle.JUST_LABEL:
                child = Text(value?.getLabel() ?? "");
                break;

              case StyledDropdownStyle.PRETTY:
                child = value?.getPrettyLabel() ?? const Text("");
                break;
            }

            return DropdownMenuItem<T>(
              value: value,
              child: child,
            );
          }).toList(),
        ),
      ),
    );
  }
}

enum StyledDropdownStyle {
  PRETTY, JUST_LABEL
}