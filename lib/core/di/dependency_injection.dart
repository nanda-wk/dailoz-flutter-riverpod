import 'package:dailoz/data/datasources/local/database_helper.dart';
import 'package:dailoz/data/datasources/remote/quote_api_service.dart';
import 'package:dailoz/data/repositories/quote_repository_impl.dart';
import 'package:dailoz/data/repositories/task_repository_impl.dart';
import 'package:dailoz/domain/repositories/quote_repository.dart';
import 'package:dailoz/domain/repositories/task_repository.dart';
import 'package:dailoz/domain/usecases/quote_usecase.dart';
import 'package:dailoz/domain/usecases/task_usecase.dart';
import 'package:dailoz/presentation/view_models/quote_view_model.dart';
import 'package:dailoz/presentation/view_models/task_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// NOTE - datasources injection
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

final quoteApiServiceProvider = Provider<QuoteApiService>((ref) {
  return QuoteApiService();
});

//NOTE - repositories injection
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final databaseHelper = ref.watch(databaseHelperProvider);
  return TaskRepositoryImpl(databaseHelper: databaseHelper);
});

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  final quoteApiService = ref.watch(quoteApiServiceProvider);
  return QuoteRepositoryImpl(quoteApiService: quoteApiService);
});

//NOTE - use cases injection
final taskUseCasesProvider = Provider<TaskUseCases>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskUseCases(repository);
});

final quoteUseCasesProvider = Provider<QuoteUseCase>((ref) {
  final repository = ref.watch(quoteRepositoryProvider);
  return QuoteUseCase(repository);
});

//NOTE - view models injection
final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final taskUseCases = ref.watch(taskUseCasesProvider);
  return TaskNotifier(taskUseCases: taskUseCases);
});

final quoteNotifierProvider =
    StateNotifierProvider<QuoteNotifier, QuoteState>((ref) {
  final quoteUseCases = ref.watch(quoteUseCasesProvider);
  return QuoteNotifier(quoteUseCase: quoteUseCases);
});
