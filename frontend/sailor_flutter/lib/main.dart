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
      create: (context) => MyAppState(),
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

class MyAppState extends ChangeNotifier {}

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
            NavigationDrawerDestination(
              icon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.favorite),
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
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('Todo 1'),
          ),
          ListTile(
            title: Text('Todo 2'),
          ),
          ListTile(
            title: Text('Todo 3'),
          ),
        ],
      ),
    );
  }
}
