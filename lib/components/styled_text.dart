import 'package:dayz_configurator_gui_tool/defines/style_colors.dart';
import 'package:flutter/cupertino.dart';

class StyledText extends Text {

  const StyledText(
      String data,
      {
        super.key,
        TextStyle? style = const TextStyle(color: StyleColors.primaryText)
      }
  ) : super(
      data,
      style: style
  );
}