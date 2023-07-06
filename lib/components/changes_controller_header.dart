import 'package:dayz_configurator_gui_tool/interfaces/changes_controller.dart';
import 'package:dayz_configurator_gui_tool/interfaces/changes_controller_owner.dart';
import 'package:dayz_configurator_gui_tool/utils/dialog_utils.dart';
import 'package:flutter/material.dart';

class ChangesControllerHeader extends StatefulWidget implements ChangesController {

  late _ChangesControllerHeaderState _state;
  final ChangesControllerOwner _changesControllerOwner;

  ChangesControllerHeader(this._changesControllerOwner, {super.key}) {
    _state = _ChangesControllerHeaderState(_changesControllerOwner);
  }

  @override
  State<StatefulWidget> createState() {
    return _state;
  }

  @override
  void changed() {
    _state.changed();
  }
}

class _ChangesControllerHeaderState extends State<ChangesControllerHeader> implements ChangesController {
  final ChangesControllerOwner _changesControllerOwner;
  var _hasChangesToWrite = false;

  _ChangesControllerHeaderState(this._changesControllerOwner);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size.square(40)),
                  minimumSize: MaterialStateProperty.all(const Size.square(40)),
                  padding: MaterialStateProperty.all(const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
                  iconSize: MaterialStateProperty.all(30)
              ),
              onPressed: _hasChangesToWrite ? _didTapSave : null,
              child: const Icon(Icons.save),
            ),
          ]
      )
    );
  }

  @override
  void changed() {
    if (! _hasChangesToWrite) {
      setState(() {
        _hasChangesToWrite = true;
      });
    }
  }

  void _didTapSave() {
    debugPrint("Save pressed");
    // Show dialog
    DialogUtils.showLoader(context);
    _changesControllerOwner.saveToDisk().then((value) => {
      setState(() {
        _hasChangesToWrite = false;
        DialogUtils.hideDialog(context);
      })
    });
  }
}