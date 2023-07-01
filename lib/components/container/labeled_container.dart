import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabeledContainer extends StatelessWidget {
  late Widget highLevelWidget;

  LabeledContainer({super.key,
    Widget? child,
    String? label,
    LabeledContainerStyle marginStyle = LabeledContainerStyle.NORMAL
  }) {
    assert(child != null);

    EdgeInsets margin;
    EdgeInsets contentPadding;
    switch (marginStyle) {
      case LabeledContainerStyle.NORMAL:
        margin = EdgeInsets.fromLTRB(0, 8, 0, 8);
        contentPadding = EdgeInsets.all(8.0);
        break;

      case LabeledContainerStyle.SLIM:
        margin = EdgeInsets.zero;
        contentPadding = EdgeInsets.fromLTRB(8, 0, 0, 0);
        break;
    }

    highLevelWidget = Container(
      margin: margin,
      color: Colors.transparent,
      alignment: Alignment.center,
      child: InputDecorator(
          decoration: InputDecoration(

            // contentPadding: EdgeInsets.all(17.0),
              contentPadding: contentPadding,
              labelText: label,

              // enabledBorder: OutlineInputBorder(
              // borderSide: BorderSide(color: Colors.yellow),
              // ),
              border: const OutlineInputBorder(
                // borderSide: BorderSide(color: Colors.blueGrey)
              )
          ),
          child: child!
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return highLevelWidget;
  }
}

enum LabeledContainerStyle{
  NORMAL, SLIM
}