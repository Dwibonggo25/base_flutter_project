import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../libraries/core/config/app_config.dart';
import '../app_module.dart';
import '../app_widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  AppConfig.init(Flavor.prod);

  runApp(
    ModularApp(
      module: AppModule(prefs),
      child: const AppWidget(),
    ),
  );
}