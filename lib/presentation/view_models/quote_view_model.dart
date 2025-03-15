// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dailoz/data/models/quote.dart';
import 'package:dailoz/domain/usecases/quote_usecase.dart';

class QuoteState {
  final List<Quote> quotes;
  final bool isLoading;
  final String? errorMessage;

  QuoteState({
    required this.quotes,
    this.isLoading = false,
    this.errorMessage,
  });

  QuoteState copyWith({
    List<Quote>? quotes,
    bool? isLoading,
    String? errorMessage,
  }) {
    return QuoteState(
      quotes: quotes ?? this.quotes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class QuoteNotifier extends StateNotifier<QuoteState> {
  final QuoteUseCase _quoteUseCase;

  QuoteNotifier({
    required QuoteUseCase quoteUseCase,
  })  : _quoteUseCase = quoteUseCase,
        super(
          QuoteState(
            quotes: [],
          ),
        );

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _quoteUseCase.getQuotes();
      state = state.copyWith(quotes: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load quotes: ${e.toString()}',
      );
    }
  }
}
