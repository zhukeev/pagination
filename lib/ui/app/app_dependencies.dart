import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pagination/data/api/pokemon/pokemon_client.dart';
import 'package:pagination/data/repository/pokemon/pokemon_repository.dart';
import 'package:pagination/ui/app/app.dart';
import 'package:pagination/ui/screen/pokemon_list_screen/pokemon_list_screen_model.dart';
import 'package:pagination/utils/error/default_error_handler.dart';
import 'package:pagination/utils/urls.dart';
import 'package:provider/provider.dart';

class AppDependencies extends StatefulWidget {
  final App app;
  const AppDependencies({Key? key, required this.app}) : super(key: key);

  @override
  _AppDependenciesState createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {
  late final Dio _http;
  late final DefaultErrorHandler _defaultErrorHandler;
  late final PokemonClient _pokemonClient;
  late final PokemonRepository _pokemonRepository;
  late final PokemonListScreenModel _pokemonListScreenModel;

  late final ThemeWrapper _themeWrapper;

  @override
  void initState() {
    super.initState();

    _http = Dio(BaseOptions(baseUrl: AppUrls.baseUrl));
    _defaultErrorHandler = DefaultErrorHandler();
    _pokemonClient = PokemonClient(_http);
    _pokemonRepository = PokemonRepository(_pokemonClient);

    _pokemonListScreenModel = PokemonListScreenModel(
      _pokemonRepository,
      _defaultErrorHandler,
    );

    _themeWrapper = ThemeWrapper();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PokemonListScreenModel>(
          create: (_) => _pokemonListScreenModel,
        ),
        Provider<ThemeWrapper>(
          create: (_) => _themeWrapper,
        ),
      ],
      child: widget.app,
    );
  }
}
