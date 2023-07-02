import 'dart:async';

import 'package:dayz_configurator_gui_tool/components/dropdown/styled_dropdown.dart';
import 'package:dayz_configurator_gui_tool/components/labelable_string.dart';
import 'package:dayz_configurator_gui_tool/components/styled_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class DialogUtils {
  static void showLoader(BuildContext context) {
    showPlatformDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => PlatformAlertDialog(
        content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              PlatformCircularProgressIndicator(),
            ]

        ),
      ),
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  static void showTextDialog(BuildContext context, String text, List<Widget> actions) {
    double cWidth = MediaQuery.of(context).size.width*0.8;

    showPlatformDialog(
      context: context,
      builder: (BuildContext context) => PlatformAlertDialog(
        actions: actions,
        content: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 0,
                maxWidth: cWidth
            ),
            child: StyledText(text)
        ),
      ),
    );
  }


  static late TextEditingController _textFieldController;
  static Future<String> showInputTextDialog(BuildContext context, String dialogTitle, String textHint, {String predefinedText = ""}) {
    _textFieldController = TextEditingController();
    _textFieldController.text = predefinedText;

    Completer<String> completer = Completer();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(dialogTitle),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: textHint),
            ),
            actions: <Widget>[
              PlatformElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(null);
                },
              ),
              PlatformElevatedButton(
                child: const Text("Confirm"),
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(_textFieldController.text);
                },
              ),
            ],
          );
        });

    return completer.future;
  }

  static Future<bool> showConfirmationDialog(BuildContext context, String confirmationText) {

    Completer<bool> completer = Completer();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Do you confirm?"),
            content: Text(confirmationText),
            actions: <Widget>[
              PlatformElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(false);
                },
              ),
              PlatformElevatedButton(
                child: const Text("Confirm"),
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(true);
                },
              ),
            ],
          );
        });

    return completer.future;
  }

  static Future<Color?> showColorPickerDialog(BuildContext context, Color? startingColor) {
    Color selectedColor = startingColor ?? Colors.white;

    Completer<Color?> completer = Completer();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose a color"),
          content: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (value) {
              selectedColor = value;
            },
          ),
          actions: <Widget>[
            PlatformElevatedButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(null);
              },
            ),
            PlatformElevatedButton(
              child: const Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(selectedColor);
              },
            ),
          ],
        );
      }
    );

    return completer.future;
  }

  static LabelableString _currentSelectedString = LabelableString("");
  static Future<String> showSelectStringOptionDialog(BuildContext context, String dialogTitle, List<String> options) {
    List<LabelableString> labelableStrings = options
        .map((o) => LabelableString(o)).toList(growable: false);

    _currentSelectedString = labelableStrings[0];

    Completer<String> completer = Completer();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text(dialogTitle),
                  content: StyledDropdown<LabelableString?>(
                    style: StyledDropdownStyle.JUST_LABEL,
                    hint: "No device selected",
                    initialValue: _currentSelectedString,
                    options: labelableStrings,
                    onChanged: (LabelableString? newOption) {
                      setState(() {
                        if (newOption != null) {
                          _currentSelectedString = newOption;
                        }
                      });
                    },
                  ),
                  actions: <Widget>[
                    PlatformElevatedButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        completer.complete("");
                      },
                    ),
                    // new FlatButton(
                    PlatformElevatedButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        completer.complete(_currentSelectedString.string);
                      },
                    ),
                  ],
                );
              });
        });

    return completer.future;
  }
}