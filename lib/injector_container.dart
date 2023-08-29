import 'package:get_it/get_it.dart';
import 'package:pokedex/features/auth/data/repositories/user_repo_impl.dart';
import 'package:pokedex/features/auth/domain/repositories/user_repo.dart';
import 'package:pokedex/features/auth/presentation/blocs/auth.cubit.dart';
import 'package:pokedex/features/home/data/data_sources/sqflite_storage_impl.dart';
import 'package:pokedex/features/home/data/repositories/pokemon_repo_implementation.dart';
import 'package:pokedex/features/home/domain/repositories/pokemon_repo.dart';
import 'package:pokedex/utils/sqflite.helper.dart';

import 'features/home/data/data_sources/interface.dart';

class Injector {
  static final _instance = GetIt.instance;

  static setup(){
    _instance.registerFactory(() => AuthenticationCubit());
    _instance.registerFactory<PokemonDatabaseHelper>(()=> PokemonDatabaseHelper());

    _instance.registerFactory<PokemonDataSource>(() => PokemonDatabaseSource(_instance()));

    _instance.registerSingleton<UserRepository>(FirebaseAuthRepository());
    _instance.registerSingleton<PokemonRepository>(PokemonRepositoryImpl(_instance()));
  }

  static GetIt get get => _instance;
}