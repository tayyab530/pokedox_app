import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/features/auth/domain/repositories/user_repo.dart';
import 'package:pokedex/features/home/domain/repositories/pokemon_repo.dart';
import 'package:pokedex/features/home/presentation/blocs/home_bloc.dart';

import '../../../../injector_container.dart';
import '../../domain/entities/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final PokemonEntity _pokemonEntity;

  PokemonCard(this._pokemonEntity);

  @override
  Widget build(BuildContext context) {
    final PokemonRepository _pokemonRepository =
        Injector.get<PokemonRepository>();
    final UserRepository _userRepo = Injector.get<UserRepository>();
    final bloc = BlocProvider.of<HomeBloc>(context);

    return LayoutBuilder(
      builder: (context,cons) {
        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10,bottom: 10),
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: Image.asset(
                    "assets/images/pokemon.png",
                    fit: BoxFit.scaleDown,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    capitalizeFirstLetter(_pokemonEntity.name),
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Icon(
                          _pokemonEntity.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: Colors.teal,
                        ),
                        onTap: () async {
                          bloc.add(ClickOnLikedButton(_pokemonEntity));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }

    return input[0].toUpperCase() + input.substring(1);
  }
}
