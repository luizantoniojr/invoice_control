import 'package:inject/inject.dart';
import 'dependency_injector.inject.dart' as g;
import '../app.dart';
import 'main_module.dart';

@Injector(const [MainModule])
abstract class DependencyInjector {
  @provide
  App get app;

  static final create = g.DependencyInjector$Injector.create;
}
