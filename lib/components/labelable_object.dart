import 'package:flutter/widgets.dart';

abstract class LabelableObject {
  String getLabel();

  Widget getPrettyLabel();
}
