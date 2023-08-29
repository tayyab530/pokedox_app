import 'package:http/http.dart' as http;
import 'package:pokedex/features/home/data/data_sources/interface.dart';
import 'package:pokedex/features/home/data/models/pokemon_model.dart';
import 'package:pokedex/features/home/domain/entities/pokemon.dart';
import 'dart:convert';

import 'package:pokedex/features/home/domain/repositories/pokemon_repo.dart';


class PokemonRepositoryImpl implements PokemonRepository {
  final String _baseUrl = 'https://pokeapi.co'; // Replace with your API URL
  final PokemonDataSource _pokemonDataSource;
  List<PokemonModel> listOfPokemons = [];

  PokemonRepositoryImpl(this._pokemonDataSource);

  @override
  Future<List<PokemonModel>> fetchPokemons(String uid) async {
    final response = await http.get(Uri.parse('$_baseUrl/api/v2/pokemon/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)["results"];
      var allPokemons = jsonData.map((data) => PokemonModel.fromMap(data)).toList();
      var listOfPokemonsNames = (await _pokemonDataSource.getPokemonsByUserId(uid)).map((e) => e.name).toList();
      allPokemons = allPokemons.map((e) {
        var isFavorite = listOfPokemonsNames.contains(e.name) ? true:false;
        return PokemonModel(name: e.name, isFavorite: isFavorite);
      }).toList();
      listOfPokemons = allPokemons;
      return allPokemons;
    } else {
      throw Exception('Failed to load Pokémon data');
    }
  }

  @override
  Future<void> addPokemon(String userId,PokemonEntity pokemon) async {
    final pokemonModel = PokemonModel(name: pokemon.name, isFavorite: pokemon.isFavorite);
    await _pokemonDataSource.addPokemon(userId, pokemonModel);
  }

  @override
  Future<void> deletePokemon(String userId,PokemonEntity pokemon) async {
    _pokemonDataSource.deletePokemon(userId, pokemon.name);
  }

  @override
  Future<List<PokemonEntity>> getFavorites(String uid) async{
    var favoritePoke = await _pokemonDataSource.getPokemonsByUserId(uid);
    return favoritePoke;
  }

  @override
  List<PokemonEntity> getPokemons() {
    return listOfPokemons;
  }

  @override
  void updatePokemon(PokemonEntity pokemonEntity){
    var index = listOfPokemons.indexWhere((element) => element.name == pokemonEntity.name);
    listOfPokemons[index] = PokemonModel(name: pokemonEntity.name, isFavorite: pokemonEntity.isFavorite);
  }
}
