
import 'package:pokedex/features/home/data/models/pokemon_model.dart';

import '../../../../utils/sqflite.helper.dart';
import 'interface.dart';

class PokemonDatabaseSource implements PokemonDataSource {
  final PokemonDatabaseHelper _databaseHelper;

  PokemonDatabaseSource(this._databaseHelper);

  @override
  Future<void> addPokemon(String userId, PokemonModel pokemon) async {
    final pokemonJson = pokemon.toMap();
    pokemonJson.addAll({PokemonDatabaseHelper.columnUserId: userId});
    await _databaseHelper.addPokemon(userId, pokemonJson);
  }

  @override
  Future<void> deletePokemon(String userId, String name) async {
    await _databaseHelper.deletePokemon(userId, name);
  }

  @override
  Future<List<PokemonModel>> getPokemonsByUserId(String userId) async {
    final List<Map<String, dynamic>> pokemonMaps = await _databaseHelper.getPokemonsByUserId(userId);
    return pokemonMaps.map((pokemonMap) => PokemonModel.fromMap(pokemonMap)).toList();
  }
}
