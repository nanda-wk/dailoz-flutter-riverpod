import 'package:dailoz/data/datasources/remote/quote_api_service.dart';
import 'package:dailoz/data/models/quote.dart';
import 'package:dailoz/domain/repositories/quote_repository.dart';

class QuoteRepositoryImpl extends QuoteRepository {
  final QuoteApiService _quoteApiService;

  QuoteRepositoryImpl({QuoteApiService? quoteApiService})
      : _quoteApiService = quoteApiService ?? QuoteApiService();

  @override
  Future<List<Quote>> getQuotes() async {
    return await _quoteApiService.getQuotes();
  }
}
