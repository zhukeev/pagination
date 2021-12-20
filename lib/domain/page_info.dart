import 'package:pagination/domain/pokemon.dart';

class PageInfo {
  PageInfo({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String next;
  String previous;
  List<Pokemon> results;
}
