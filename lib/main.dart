import 'package:flutter/material.dart';
import 'src/di/dependency_injector.dart';
//import 'src/di/main_module.dart';

void main() async {
  var container = await DependencyInjector.create();
  runApp(container.app);
}
