part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class InitialEvent extends HomeEvent{

}

class ClickOnLikedButton extends HomeEvent{
  final PokemonEntity pokemonEntity;

  ClickOnLikedButton(this.pokemonEntity);
}

class FilterPokemons extends HomeEvent{
  final String query;

  FilterPokemons(this.query);
}
