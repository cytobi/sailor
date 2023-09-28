import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const SailorApp());
}

class SailorApp extends StatelessWidget {
  const SailorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SailorAppState(),
      child: MaterialApp(
        title: 'sailor',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
          useMaterial3: true,
        ),
        home: SailorMainPage(),
      ),
    );
  }
}

class SailorAppState extends ChangeNotifier {
  var todos = <TodoTask>[];

  void addTask(TodoTask task) {
    todos.add(task);
    notifyListeners();
  }

  void finishTask(TodoTask task) {
    task.isDone = true;
    notifyListeners();
  }

  void changeTaskImportance(TodoTask task, bool isImportant) {
    task.isImportant = isImportant;
    notifyListeners();
  }
}

class SailorMainPage extends StatefulWidget {
  @override
  State<SailorMainPage> createState() => _SailorMainPageState();
}

class _SailorMainPageState extends State<SailorMainPage> {
  var selectedIndex = 0;

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = TodoPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: page,
        appBar: AppBar(
          title: Text(
              page.runtimeType.toString()), //actually put page name here later
        ),
        drawer: NavigationDrawer(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            _closeDrawer();
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'sailor',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.check_circle_outline),
              label: Text('To-Do'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.more),
              label: Text('More'),
            ),
          ],
        ),
      );
    });
  }
}

class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SailorAppState>();
    var todos = appState.todos;

    var uncompletedTodos = todos.where((todo) => !todo.isDone).toList();

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
            content: const SizedBox(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  appState.addTask(TodoTask(title: 'test'));
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

    return GestureDetector(
      onTap: () {
        appState.finishTask(task);
      },
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < 0) {
          // slide left
          // edit task
        } else {
          // slide right
          appState.changeTaskImportance(task, !task.isImportant);
        }
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
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              //show details
            },
          ),
        ),
      ),
    );
  }
}
