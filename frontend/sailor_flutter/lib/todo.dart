import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SailorAppState>();
    var todos = appState.todos;

    var uncompletedTodos = todos.where((todo) => !todo.isDone).toList();

    var titleController = TextEditingController();

    return Scaffold(
      body: ListView(
        children: [
          for (var todo in uncompletedTodos) TodoCard(task: todo),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Enter task title'),
            content: SizedBox(
              width: 250,
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
                onSubmitted: (value) {
                  appState.addTask(TodoTask(title: value));
                  Navigator.pop(context, 'OK');
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  appState.addTask(TodoTask(title: titleController.text));
                  Navigator.pop(context, 'OK');
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  final TodoTask task;

  const TodoCard({required this.task});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SailorAppState>();

    var cardColor = Theme.of(context).colorScheme.surface;
    if (task.isImportant) {
      cardColor = Theme.of(context).colorScheme.inversePrimary;
    }

    var dragged = Offset.zero;

    return GestureDetector(
      onTap: () {
        appState.finishTask(task);
      },
      onPanUpdate: (details) {
        dragged += details.delta;
      },
      onPanEnd: (details) {
        if (dragged.dx < 0) {
          // slide left
          // edit task
        } else {
          // slide right
          appState.changeTaskImportance(task, !task.isImportant);
        }
        dragged = Offset.zero;
      },
      child: Card(
        color: cardColor,
        child: ListTile(
          title: Text(task.title),
          leading: Checkbox(
            value: task.isDone,
            onChanged: (value) {
              appState.finishTask(task);
            },
          ),
          trailing: TaskMenu(task: task),
        ),
      ),
    );
  }
}

class TaskMenu extends StatelessWidget {
  final TodoTask task;

  const TaskMenu({required this.task});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SailorAppState>();

    var importanceText =
        task.isImportant ? 'Unmark important' : 'Mark important';

    return MenuAnchor(
        menuChildren: [
          MenuItemButton(
            child: Text('Complete'),
            onPressed: () {
              appState.finishTask(task);
            },
          ),
          MenuItemButton(
            child: Text('Edit'),
            onPressed: () {
              // edit task
            },
          ),
          MenuItemButton(
            child: Text(importanceText),
            onPressed: () {
              appState.changeTaskImportance(task, !task.isImportant);
            },
          ),
          MenuItemButton(
            child: Text('Delete'),
            onPressed: () {
              appState.deleteTask(task);
            },
          ),
        ],
        builder: (context, controller, child) {
          return IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
          );
        });
  }
}

class TodoTask {
  String title;
  String description;
  bool isDone;
  bool isImportant;

  TodoTask({
    required this.title,
    this.description = '',
    this.isDone = false,
    this.isImportant = false,
  });
}
