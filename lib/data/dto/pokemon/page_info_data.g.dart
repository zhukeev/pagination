// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_info_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageInfoData _$PageInfoDataFromJson(Map<String, dynamic> json) => PageInfoData(
      count: json['count'] as int,
      next: json['next'] as String,
      previous: json['previous'] as String,
      results: (json['results'] as List<dynamic>)
          .map((e) => PokemonData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PageInfoDataToJson(PageInfoData instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
