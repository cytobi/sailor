import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo.dart';

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

  void deleteTask(TodoTask task) {
    todos.remove(task);
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
