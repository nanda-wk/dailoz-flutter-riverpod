import 'package:dailoz/data/models/quote.dart';
import 'package:dailoz/domain/repositories/quote_repository.dart';

class QuoteUseCase {
  final QuoteRepository _repository;

  QuoteUseCase(this._repository);

  Future<List<Quote>> getQuotes() async {
    return await _repository.getQuotes();
  }
}
