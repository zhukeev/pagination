import 'package:pagination/data/dto/pokemon/pokemon_data.dart';
import 'package:pagination/domain/pokemon.dart';

/// Map Pokemon from PokemonData
Pokemon mapPokemon(PokemonData data) {
  return Pokemon(
    name: data.name,
    url: data.url,
  );
}
