import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:pagination/domain/pokemon.dart';
import 'package:pagination/ui/screen/pokemon_list_screen/pokemon_list_screen.dart';
import 'package:pagination/ui/screen/pokemon_list_screen/pokemon_list_screen_model.dart';
import 'package:pagination/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

/// Factory for [PokemonListScreenWidgetModel]
PokemonListScreenWidgetModel pokemonListScreenWidgetModelFactory(
  BuildContext context,
) {
  final model = context.read<PokemonListScreenModel>();
  final theme = context.read<ThemeWrapper>();
  return PokemonListScreenWidgetModel(model, theme);
}

/// Widget Model for [PokemonListScreen]
class PokemonListScreenWidgetModel extends WidgetModel<PokemonListScreen, PokemonListScreenModel>
    implements IPokemonListWidgetModel {
  final ThemeWrapper _themeWrapper;
  late TextStyle _pokemonTextStyle;

  final _pokemonListState = EntityStateNotifier<Iterable<Pokemon>>();
  final _scrollController = ScrollController();

  PokemonListScreenWidgetModel(PokemonListScreenModel model, this._themeWrapper) : super(model);

  @override
  ListenableState<EntityState<Iterable<Pokemon>>> get pokemonListState => _pokemonListState;

  @override
  TextStyle get pokemonNameStyle => _pokemonTextStyle;

  @override
  ScrollController get scrollController => _scrollController;

  double get _screenHeight => MediaQuery.of(context).size.height;

  double get _screenHeight10thPart => _screenHeight * 0.1;

  bool get _hasError => pokemonListState.value?.hasError ?? false;

  bool get _isLoading => pokemonListState.value?.isLoading ?? false;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _scrollController.addListener(_scrollListener);

    _loadPokemonList();
    _pokemonTextStyle = _themeWrapper.getTextTheme(context).headline4!;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading &&
        !_hasError &&
        _scrollController.position.extentAfter < _screenHeight10thPart) {
      _loadPokemonList();
    }
  }

  Future<void> _loadPokemonList() async {
    final previousData = _pokemonListState.value?.data ?? <Pokemon>[];

    _pokemonListState.loading(previousData);

    try {
      final res = await model.loadCountries(
        previousData.length + AppConsts.pageOffset,
        AppConsts.pageLimit,
      );
      _pokemonListState.content([...previousData, ...res]);
    } on Exception catch (e) {
      _pokemonListState.error(e, previousData);
    }
  }

  @override
  void onErrorHandle(Object error) {
    super.onErrorHandle(error);

    if (error is DioError &&
        (error.type == DioErrorType.connectTimeout || error.type == DioErrorType.receiveTimeout)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Connection troubles')));
    }
  }
}

/// Interface of [PokemonListScreenWidgetModel]
abstract class IPokemonListWidgetModel extends IWidgetModel {
  ListenableState<EntityState<Iterable<Pokemon>>> get pokemonListState;

  ScrollController get scrollController;

  TextStyle get pokemonNameStyle;
}
