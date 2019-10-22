import 'dependency_injector.dart' as _i1;
import 'dart:async' as _i2;
import '../app.dart' as _i3;

class DependencyInjector$Injector implements _i1.DependencyInjector {
  DependencyInjector$Injector._();

  static _i2.Future<_i1.DependencyInjector> create() async {
    final injector = DependencyInjector$Injector._();

    return injector;
  }

  @override
  _i3.App get app => null;
}
