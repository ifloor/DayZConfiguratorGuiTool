
import 'package:flutter/widgets.dart';

abstract class ChildrenMenuWidget extends Widget {
  const ChildrenMenuWidget({super.key});

  Future<bool> isChildrenReadyToLeave();
}