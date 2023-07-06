import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabeledContainer extends StatelessWidget {
  late Widget highLevelWidget;

  LabeledContainer(
    {
      super.key,
      required Widget child,
      required String label,
      LabeledContainerStyle marginStyle = LabeledContainerStyle.normal,
      double width = 30,
      double height = 40,
    }
  ) {
    EdgeInsets margin;
    EdgeInsets contentPadding;
    switch (marginStyle) {
      case LabeledContainerStyle.normal:
        margin = const EdgeInsets.fromLTRB(2, 8, 2, 0);
        contentPadding = const EdgeInsets.fromLTRB(12, 0, 8, 0);
        break;

      case LabeledContainerStyle.slim:
        margin = EdgeInsets.zero;
        contentPadding = const EdgeInsets.fromLTRB(0, 0, 0, 0);
        break;
    }

    highLevelWidget = Container(
      margin: margin,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: InputDecorator(
        decoration: InputDecoration(
          constraints: BoxConstraints.tight(Size(width, height)),
          contentPadding: contentPadding,
          labelText: label,
          border: const OutlineInputBorder()),
        child: child
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return highLevelWidget;
  }
}

enum LabeledContainerStyle{
  normal, slim
}