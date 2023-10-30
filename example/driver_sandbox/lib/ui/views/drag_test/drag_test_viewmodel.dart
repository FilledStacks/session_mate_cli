import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:stacked/stacked.dart';

class DragTestViewModel extends BaseViewModel {
  String _dragState = 'No drag detected';
  String get dragState => _dragState;

  Offset? _dragStartPosition;
  Offset? _dragEndPosition;

  Offset get dragStartPosition => _dragStartPosition ?? Offset.zero;
  Offset get dragEndPosition => _dragEndPosition ?? Offset.zero;

  void dragDetected(DragUpdateDetails details) {
    _dragState = 'Drag detected 👇⏭️👇';
    print('Drag update: ${details.globalPosition}');
    _dragEndPosition = details.globalPosition;
    notifyListeners();

    Timer(const Duration(seconds: 1), () {
      _dragState = 'No drag detected';
      _dragEndPosition = null;
      _dragStartPosition = null;
      notifyListeners();
    });
  }

  void onPanStart(DragStartDetails details) {
    _dragStartPosition = details.globalPosition;
    print('Drag start: ${details.globalPosition}');
    notifyListeners();
  }
}
