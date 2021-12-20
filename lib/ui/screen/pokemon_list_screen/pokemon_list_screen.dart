import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:pagination/domain/pokemon.dart';
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
        title: const Text('Pokemon List'),
      ),
      body: EntityStateNotifierBuilder<Iterable<Pokemon>>(
        listenableEntityState: wm.pokemonListState,
        loadingBuilder: (_, __) => const _LoadingWidget(),
        errorBuilder: (_, __, ___) => const _ErrorWidget(),
        builder: (_, pokemons) => _PokemonList(
          pokemons: pokemons,
          nameStyle: wm.pokemonNameStyle,
          controller: wm.scrollController,
        ),
      ),
    );
  }
}

class _PokemonList extends StatelessWidget {
  final Iterable<Pokemon>? pokemons;
  final TextStyle nameStyle;

  final ScrollController controller;
  const _PokemonList({
    Key? key,
    required this.pokemons,
    required this.nameStyle,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pokemons?.isEmpty ?? true) {
      return const _EmptyList();
    }

    return ListView.separated(
      controller: controller,
      itemBuilder: (_, index) => _PokemonWidget(
        pokemon: pokemons!.elementAt(index),
        style: nameStyle,
        index: index,
      ),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: pokemons!.length,
      cacheExtent: 800,
    );
  }
}

class _PokemonWidget extends StatelessWidget {
  final Pokemon pokemon;
  final int index;
  final TextStyle style;
  const _PokemonWidget({
    Key? key,
    required this.pokemon,
    required this.index,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$index ${pokemon.name}',
        style: style,
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('loading'),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Error'),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Empty list'),
    );
  }
}
