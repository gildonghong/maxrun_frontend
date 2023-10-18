import 'package:rxdart/rxdart.dart';

extension StreamExt<T> on Stream<T> {
  BehaviorSubject<T> asSubject({T? seed}) {
    final sbj = seed != null ? BehaviorSubject<T>.seeded(seed) : BehaviorSubject<T>();
    return BehaviorSubject<T>()..addStream(this);
  }
}

