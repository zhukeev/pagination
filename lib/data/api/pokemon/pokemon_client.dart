import 'package:dio/dio.dart';
import 'package:pagination/data/dto/pokemon/page_info_data.dart';
import 'package:pagination/utils/urls.dart';
import 'package:retrofit/retrofit.dart';

part 'pokemon_client.g.dart';

@RestApi()
abstract class PokemonClient {
  factory PokemonClient(Dio dio, {String baseUrl}) = _PokemonClient;

  @GET(AppUrls.pokemonList)
  Future<PageInfoData> getPokemons(
    @Query('offset') int offset,
    @Query('limit') int limit,
  );
}
