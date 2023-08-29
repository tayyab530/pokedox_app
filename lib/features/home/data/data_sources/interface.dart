import 'package:pokedex/features/home/data/models/pokemon_model.dart';

abstract class PokemonDataSource {
  Future<void> addPokemon(String userId, PokemonModel pokemon);
  Future<void> deletePokemon(String userId, String name);
  Future<List<PokemonModel>> getPokemonsByUserId(String userId);
}
