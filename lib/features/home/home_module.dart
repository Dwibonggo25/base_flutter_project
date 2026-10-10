import 'package:base_project/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:base_project/features/home/presentation/ui/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/home_remote_datasoureces.dart';
import 'data/repositories/home_repositoriy_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecase/home_usecase.dart';


class HomeModule extends Module {
  @override
  List<Bind> get binds => [
    // datasource
    Bind.lazySingleton(
          (i) => HomeRemoteDatasource(i()),
    ),

    // repository
    Bind.lazySingleton<HomeRepository>(
          (i) => HomeRepositoryImpl(i()),
    ),

    // usecase
    Bind.lazySingleton(
          (i) => HomeUsecase(i()),
    ),

    Bind.factory((i) => HomeBloc(i())),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(
      '/',
      child: (_, __) => const HomePage(),
    ),
  ];
}