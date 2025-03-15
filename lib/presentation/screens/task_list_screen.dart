import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dailoz/core/di/dependency_injection.dart';
import 'package:dailoz/presentation/screens/task_editing_screen.dart';
import 'package:dailoz/presentation/widgets/task_list_card.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(taskNotifierProvider.notifier).getAllTasks());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
      ),
      body: Column(
        children: [
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.tasks.isEmpty
                    ? const Center(
                        child: Text('No Task Found.'),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) {
                          final task = state.tasks[index];
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
