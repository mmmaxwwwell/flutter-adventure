import 'package:adminclient/util/Modal/ModalAction.dart';
import 'package:adminclient/util/Modal/ModalForm.dart';
import 'package:flutter/material.dart';

class AlertModal<T> {
  ModalForm<ModalAction<T>> _widget;
  Function _callback;
  BuildContext _context;

  AlertModal(BuildContext context, ModalForm<ModalAction<T>> widget,
      Function callback) {
    _widget = widget;
    _callback = callback;
    _context = context;
    show();
  }

  void show() {
    showDialog(
      barrierDismissible: false,
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_widget.title),
          content: Container(width: double.maxFinite, child: _widget),
          actions: [
            if (_widget.showCancel)
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            if (_widget.showDelete)
              FlatButton(
                onPressed: () => confirmDelete(context),
                child: Text('Delete'),
              ),
            FlatButton(
              child: Text(_widget.acceptText),
              onPressed: () {
                // Navigator.pop(context);
                ok(context);
              },
            ),
          ],
        );
      },
    );
  }

  void ok(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Validating"),
          content:
              AspectRatio(aspectRatio: 1, child: CircularProgressIndicator()),
          actions: [],
        );
      },
    );
    var validationErrors = await _widget.validationErrors(_widget.data());
    Navigator.pop(context);

    if (validationErrors.isEmpty) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Processing"),
            content:
                AspectRatio(aspectRatio: 1, child: CircularProgressIndicator()),
            actions: [],
          );
        },
      );
      var processed = await _widget.postProcess(_widget.data());
      Navigator.pop(context);
      _callback(processed);
      Navigator.pop(context);
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("The following validation errors occured:"),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [for (var error in validationErrors) Text(error)]),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void delete(BuildContext context) {
    _callback(_widget.data(true));
    Navigator.pop(context);
  }

  void confirmDelete(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete '${_widget.initialName()}'?"),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.pop(context);
                delete(context);
              },
            ),
          ],
        );
      },
    );
  }
}
