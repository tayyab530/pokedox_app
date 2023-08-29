import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pokedex/features/auth/domain/repositories/user_repo.dart';
import 'package:pokedex/features/home/domain/entities/pokemon.dart';
import 'package:pokedex/features/home/domain/repositories/pokemon_repo.dart';

import '../../../../injector_container.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _pokemonRepo = Injector.get<PokemonRepository>();
  final _userRepo = Injector.get<UserRepository>();

  HomeBloc() : super(HomeInitial()) {
    // on<ClickOnLikedButton>((event, emit) async{
    //   emit(PokemonLikedState());
    // });

    on<InitialEvent>((event, emit) async{
      emit(LoadingState());
      var result = await _pokemonRepo.fetchPokemons(_userRepo.getUser.uid!);
      emit(LoadedState(result));
    });

    on<ClickOnLikedButton>((event, emit) async{
      emit(LoadingState());
      if(!event.pokemonEntity.isFavorite){
        var poke = PokemonEntity(name: event.pokemonEntity.name,isFavorite: true);
        await _pokemonRepo.addPokemon(
            _userRepo.getUser.uid!, poke);
        _pokemonRepo.updatePokemon(poke);
      }
      else{
        var poke = PokemonEntity(name: event.pokemonEntity.name,isFavorite: false);
        _pokemonRepo.updatePokemon(poke);
        await _pokemonRepo.deletePokemon(
            _userRepo.getUser.uid!, event.pokemonEntity);
      }

      var list = await _pokemonRepo.getPokemons();

      emit(LoadedState(list));
    });

    on<FilterPokemons>((event, emit) async{
      var result = await _pokemonRepo.getPokemons().where((element) => element.name.contains(event.query)).toList();
      emit(LoadedState(result));
    });
  }
}
