import 'package:pokedex/features/home/domain/entities/pokemon.dart';
import 'package:pokedex/utils/sqflite.helper.dart';

class PokemonModel extends PokemonEntity{

  PokemonModel({required name,required isFavorite}):super(name: name,isFavorite: isFavorite);

  PokemonModel copyWith({String? name, bool? isFavorite}) {
    return PokemonModel(
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      PokemonDatabaseHelper.columnName: name,
      PokemonDatabaseHelper.columnIsFavorite: isFavorite ? 1:0,
    };
  }

  factory PokemonModel.fromMap(Map<String, dynamic> map) {
    return PokemonModel(
      name: map['name'],
      isFavorite: map['isFavorite']  == 1? true: false,
    );
  }
}