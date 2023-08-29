import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injector_container.dart';
import '../../../auth/domain/repositories/user_repo.dart';
import '../../domain/repositories/pokemon_repo.dart';
import '../blocs/home_bloc.dart';
import '../widgets/pokemon_card.dart';

class FavoriteScreen extends StatelessWidget {
  final UserRepository userRepository = Injector.get<UserRepository>();

  FavoriteScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: PokemonGridView(), // Display grid view of Pokemon cards
      ),
    );
  }
}

class PokemonGridView extends StatelessWidget {
  final pokemonsRepo = Injector.get<PokemonRepository>();
  final UserRepository _userRepository = Injector.get<UserRepository>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is ActionState,
      buildWhen: (previous, current) => current is! ActionState,
      listener: (context, state) {},
      builder: (context, state) {
        return FutureBuilder(
            future: pokemonsRepo.getFavorites(_userRepository.getUser.uid!),
            builder: (context, ss) {
              if (ss.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(),);
              }
              final data = ss.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var poke = data[index];
                  return PokemonCard(poke);
                },
              );
            }
        );
      },
    );
  }
}