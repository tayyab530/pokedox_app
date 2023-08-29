part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class ActionState extends HomeState{}

class HomeInitial extends HomeState {}

class LoadingState extends HomeState {}

class LoadedState extends HomeState {
  final List<PokemonEntity> listOfPokemons;

  LoadedState(this.listOfPokemons);
}

class PokemonLikedState extends HomeState{

}
