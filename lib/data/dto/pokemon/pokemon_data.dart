import 'package:json_annotation/json_annotation.dart';

part 'pokemon_data.g.dart';

/// DTO for pokemon.
@JsonSerializable()
class PokemonData {
  PokemonData({
    required this.name,
    required this.url,
  });

  String name;
  String url;

  factory PokemonData.fromJson(Map<String, dynamic> json) => _$PokemonDataFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonDataToJson(this);
}
