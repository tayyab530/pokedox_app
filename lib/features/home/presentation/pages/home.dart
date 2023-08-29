import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/auth/domain/repositories/user_repo.dart';
import 'package:pokedex/features/auth/presentation/pages/login.dart';
import 'package:pokedex/features/home/domain/repositories/pokemon_repo.dart';
import 'package:pokedex/features/home/presentation/pages/favorite.dart';
import 'package:pokedex/features/home/presentation/widgets/pokemon_card.dart';
import 'package:pokedex/injector_container.dart';

import '../../../auth/domain/entities/user.entity.dart';
import '../blocs/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserRepository _userRepository = Injector.get<UserRepository>();
  bool showSearchBar = false;
  final bloc = HomeBloc();
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserEntity _currentUser = _userRepository.getUser;

    return SafeArea(
      child: BlocProvider(
        create: (context) => bloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Pokedex'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {
                  setState(() {
                    showSearchBar = !showSearchBar;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border_rounded),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return FavoriteScreen();
                  })).then((value) => setState(() {}));
                },
              ),
            ],
            backgroundColor: Theme.of(context).primaryColor,
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        child: Icon(
                          Icons.person_rounded,
                          size: 30,
                        ),
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _currentUser.displayName ?? "User Name",
                        // Display user's name here
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _currentUser.email ?? "---",
                        // Display user's email here
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    _userRepository.logOut();
                    // Navigate to the login screen
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (_) {
                      return LoginScreen();
                    }));
                  },
                ),
              ],
            ),
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight,
              child: Column(
                children: [
                  if (showSearchBar)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: TextField(
                        controller: _searchTextController,
                        onChanged: (query) {
                          bloc.add(FilterPokemons(query));
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF999999),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF999999),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF999999),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          suffixIconColor: Colors.teal,
                          isDense: true,
                          hintText: 'Search',
                          suffixIcon: IconButton(
                            onPressed: () {
                              bloc.add(FilterPokemons(''));
                              _searchTextController.clear();
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.teal,
                            ),
                          ), // Replace with your hint text
                        ),
                      ),
                    ),
                  Expanded(
                    child: PokemonGridView(),
                  ),
                ],
              ),
            );
          }), // Display grid view of Pokemon cards
        ),
      ),
    );
  }
}

class PokemonGridView extends StatefulWidget {
  @override
  State<PokemonGridView> createState() => _PokemonGridViewState();
}

class _PokemonGridViewState extends State<PokemonGridView> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is ActionState,
      buildWhen: (previous, current) => current is! ActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        } else if (state is LoadedState) {
          final data = state.listOfPokemons;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var poke = data[index];
              return PokemonCard(poke);
            },
          );
        } else {
          return const Center(
            child: Text("No Pokemons"),
          );
        }
      },
    );
  }
}
