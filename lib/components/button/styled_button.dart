import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StyledButton {
  static Widget get(
    {
      final VoidCallback? onPressed,
      final Widget? child,
    }
  ) {
    return OutlinedButton(
      style: const ButtonStyle(
          padding: MaterialStatePropertyAll(EdgeInsetsDirectional.zero)
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}