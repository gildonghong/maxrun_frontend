import 'package:rxdart/rxdart.dart';

extension StreamExt<T> on Stream<T> {
  BehaviorSubject<T> asSubject() {
    final sbj = BehaviorSubject<T>();
    return BehaviorSubject<T>()..addStream(this);
  }
}
