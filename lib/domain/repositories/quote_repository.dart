import 'package:dailoz/data/models/quote.dart';

abstract class QuoteRepository {
  Future<List<Quote>> getQuotes();
}
