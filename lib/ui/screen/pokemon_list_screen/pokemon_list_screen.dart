import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:pagination/domain/pokemon.dart';
import 'package:pagination/ui/res/pokemon_strings.dart';
import 'package:pagination/ui/screen/pokemon_list_screen/pokemon_list_screen_widget_model.dart';

class PokemonListScreen extends ElementaryWidget<IPokemonListWidgetModel> {
  const PokemonListScreen({
    Key? key,
    WidgetModelFactory wmFactory = pokemonListScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IPokemonListWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PokemonString.pokemonListPageTitle),
      ),
      body: EntityStateNotifierBuilder<List<Pokemon>>(
        listenableEntityState: wm.pokemonListState,
        loadingBuilder: (_, pokemons) => (pokemons?.isEmpty ?? true)
            ? const _LoadingWidget()
            : _PokemonList(
                pokemons: pokemons,
                nameStyle: wm.pokemonNameStyle,
                onItemBuilt: wm.onPokemonItemBuilt,
                isLoading: true,
              ),
        errorBuilder: (_, __, ___) => const _ErrorWidget(),
        builder: (_, pokemons) => _PokemonList(
          pokemons: pokemons,
          nameStyle: wm.pokemonNameStyle,
          onItemBuilt: wm.onPokemonItemBuilt,
        ),
      ),
    );
  }
}

class _PokemonList extends StatelessWidget {
  final List<Pokemon>? pokemons;
  final TextStyle nameStyle;
  final bool isLoading;
  final ValueChanged<int>? onItemBuilt;

  const _PokemonList({
    Key? key,
    required this.pokemons,
    required this.nameStyle,
    this.onItemBuilt,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pokemons?.isEmpty ?? true) {
      return const _EmptyList();
    }

    return ListView.separated(
      itemBuilder: (_, index) => isLoading && index == pokemons!.length - 1
          ? const CircularProgressIndicator.adaptive()
          : _PokemonWidget(
              pokemon: pokemons!.elementAt(index),
              onItemBuilt: () => onItemBuilt?.call(index),
              style: nameStyle,
              index: index,
            ),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: pokemons!.length,
      cacheExtent: 800,
    );
  }
}

class _PokemonWidget extends StatefulWidget {
  final Pokemon pokemon;
  final int index;
  final TextStyle style;
  final VoidCallback onItemBuilt;

  const _PokemonWidget({
    Key? key,
    required this.pokemon,
    required this.index,
    required this.style,
    required this.onItemBuilt,
  }) : super(key: key);

  @override
  State<_PokemonWidget> createState() => _PokemonWidgetState();
}

class _PokemonWidgetState extends State<_PokemonWidget> {
  @override
  void initState() {
    super.initState();
    widget.onItemBuilt();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${widget.index + 1} ${widget.pokemon.name}',
        style: widget.style,
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator.adaptive(),
          SizedBox(height: 16),
          Text(PokemonString.loading),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(PokemonString.error),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(PokemonString.emptyList),
    );
  }
}
