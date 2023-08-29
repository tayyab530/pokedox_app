import 'package:pokedex/features/home/domain/entities/pokemon.dart';

abstract class PokemonRepository {
  Future<List<PokemonEntity>> fetchPokemons(String uid);
  List<PokemonEntity> getPokemons();
  Future<List<PokemonEntity>>getFavorites(String userId);
  Future<void> addPokemon(String userId,PokemonEntity pokemon);
  Future<void> deletePokemon(String userId,PokemonEntity pokemon);
  void updatePokemon(PokemonEntity pokemonEntity);
}
