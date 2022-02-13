import 'package:mocktail/mocktail.dart';

class FunctionMock<T> extends Mock {
  T call();
}

class ValueChangedMock<T> extends Mock {
  void call(T arg);
}
