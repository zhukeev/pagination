import 'package:elementary/elementary.dart';
import 'package:pagination/data/repository/pokemon/pokemon_repository.dart';
import 'package:pagination/domain/pokemon.dart';

/// Model for [PokemonListScreen]
class PokemonListScreenModel extends ElementaryModel {
  final PokemonRepository _pokemonRepository;

  PokemonListScreenModel(
    this._pokemonRepository,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  /// Return iterable pokemons.
  Future<Iterable<Pokemon>> loadPokemons(int offset, int limit) async {
    try {
      final res = await _pokemonRepository.getPokemons(offset, limit);
      return res;
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }
}
