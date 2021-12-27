import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:pagination/domain/pokemon.dart';
import 'package:pagination/ui/res/pokemon_strings.dart';
import 'package:pagination/ui/screen/pokemon_list_screen/pokemon_list_screen.dart';
import 'package:pagination/ui/screen/pokemon_list_screen/pokemon_list_screen_model.dart';
import 'package:pagination/utils/constants.dart';
import 'package:pagination/utils/controller/message_controller.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

/// Factory for [PokemonListScreenWidgetModel]
PokemonListScreenWidgetModel pokemonListScreenWidgetModelFactory(
  BuildContext context,
) {
  final model = context.read<PokemonListScreenModel>();
  final theme = context.read<ThemeWrapper>();
  final messageController = MessageController.from(context);

  return PokemonListScreenWidgetModel(
    model,
    themeWrapper: theme,
    messageController: messageController,
  );
}

/// Widget Model for [PokemonListScreen]
class PokemonListScreenWidgetModel extends WidgetModel<PokemonListScreen, PokemonListScreenModel>
    implements IPokemonListWidgetModel {
  final ThemeWrapper _themeWrapper;
  final MessageController _messageController;
  late TextStyle _pokemonTextStyle;

  final _pokemonListState = EntityStateNotifier<List<Pokemon>>();

  PokemonListScreenWidgetModel(
    PokemonListScreenModel model, {
    required ThemeWrapper themeWrapper,
    required MessageController messageController,
  })  : _themeWrapper = themeWrapper,
        _messageController = messageController,
        super(model);

  @override
  ListenableState<EntityState<List<Pokemon>>> get pokemonListState => _pokemonListState;

  @override
  TextStyle get pokemonNameStyle => _pokemonTextStyle;

  bool _isLastPage = false;

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    _downloadPokemonList();
    _pokemonTextStyle = _themeWrapper.getTextTheme(context).headline4!;
  }

  @override
  void onPokemonItemBuilt(int index) {
    final list = _pokemonListState.value?.data ?? <Pokemon>[];

    if (!_isLastPage && list.length - 1 == index) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) => _downloadPokemonList(),
      );
    }
  }

  Future<void> _downloadPokemonList() async {
    final previousData = _pokemonListState.value?.data ?? <Pokemon>[];

    _pokemonListState.loading(previousData);

    try {
      final res = await model.loadPokemons(
        previousData.length + AppConsts.pageOffset,
        AppConsts.pageLimit,
      );

      if (res.length < AppConsts.pageLimit) {
        _isLastPage = true;
      }
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
      _messageController.showSnackbar(PokemonString.connectionError);
    }
  }
}

/// Interface of [PokemonListScreenWidgetModel]
abstract class IPokemonListWidgetModel extends IWidgetModel {
  ListenableState<EntityState<List<Pokemon>>> get pokemonListState;

  TextStyle get pokemonNameStyle;

  void onPokemonItemBuilt(int index) {}
}
