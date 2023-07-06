import 'package:dayz_configurator_gui_tool/components/labelable_object.dart';
import 'package:flutter/widgets.dart';

class LabelableString implements LabelableObject {
  String string;

  LabelableString(this.string);

  @override
  String getLabel() {
    return string;
  }

  @override
  Widget getPrettyLabel() {
    return Text(string);
  }

}