import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dailoz/core/di/dependency_injection.dart';
import 'package:dailoz/data/models/quote.dart';

class QuoteScreen extends ConsumerStatefulWidget {
  const QuoteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends ConsumerState<QuoteScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(quoteNotifierProvider.notifier).loadData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quoteNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivational Quotes'),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(child: Text('Error: ${state.errorMessage}'))
              : state.quotes.isEmpty
                  ? const Center(child: Text('No quotes available'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref
                            .read(quoteNotifierProvider.notifier)
                            .loadData();
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: state.quotes.length,
                        itemBuilder: (context, index) {
                          final quote = state.quotes[index];
                          return _quoteCard(quote);
                        },
                      ),
                    ),
    );
  }

  Widget _quoteCard(Quote quote) {
    return Card(
      shadowColor: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.format_quote),
            ),
            Text(
              quote.quote,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.format_quote),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '- ${quote.author}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomRefresh extends RefreshIndicator {
  const CustomRefresh(
      {super.key, required super.child, required super.onRefresh});
}
