import 'dart:async';

import 'package:flutter/material.dart';

class DebounceHelper {
  Timer? _timer;
  void debounce({
    Duration duration = const Duration(milliseconds: 500),
    required VoidCallback callback,
  }) async {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void cancel() => _timer?.cancel();
}
