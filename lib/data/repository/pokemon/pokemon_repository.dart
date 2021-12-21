import 'package:pagination/data/api/pokemon/pokemon_client.dart';
import 'package:pagination/data/repository/pokemon/pokemon_mappers.dart';
import 'package:pagination/domain/pokemon.dart';

/// Pokemon repository
class PokemonRepository {
  final PokemonClient _client;

  PokemonRepository(this._client);

  /// Return pokemons
  Future<Iterable<Pokemon>> getPokemons(int offset, int limit) =>
      _client.getPokemons(offset, limit).then(
            (value) => value.results.map(mapPokemon),
          );
}
