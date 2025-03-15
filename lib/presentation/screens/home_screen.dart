import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dailoz/core/di/dependency_injection.dart';
import 'package:dailoz/presentation/screens/quote_screen.dart';
import 'package:dailoz/presentation/screens/task_editing_screen.dart';
import 'package:dailoz/presentation/screens/task_list_screen.dart';
import 'package:dailoz/presentation/widgets/task_list_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(taskNotifierProvider.notifier).getTodayTasks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Today Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TaskListScreen(),
                ),
              );
            },
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuoteScreen(),
                ),
              );
            },
            icon: Icon(Icons.format_quote),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.todayTasks.isEmpty
                    ? const Center(
                        child: Text('There is no task for today.'),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: state.todayTasks.length,
                        itemBuilder: (context, index) {
                          final task = state.todayTasks[index];
                          return TaskListCard(
                            task: task,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskEditingScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
