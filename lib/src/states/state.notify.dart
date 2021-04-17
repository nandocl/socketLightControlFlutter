import 'dart:async';

final _controller = StreamController<bool>.broadcast();

Function(bool) get updateSocketState {
  return _controller.sink.add;
}

Stream<bool> get stream => _controller.stream;

void dispose() {
  _controller.close();
}
