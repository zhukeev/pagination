import 'package:pagination/data/dto/pokemon/pokemon_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_info_data.g.dart';

@JsonSerializable()
class PageInfoData {
  PageInfoData({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<PokemonData> results;

  factory PageInfoData.fromJson(Map<String, dynamic> json) => _$PageInfoDataFromJson(json);

  Map<String, dynamic> toJson() => _$PageInfoDataToJson(this);
}
