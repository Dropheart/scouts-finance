import 'package:flutter/material.dart';
import 'package:scouts_finance/events/home.dart';
import 'package:scouts_finance/payments/home.dart';
import 'package:scouts_finance/scouts/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  static final List<Widget> pages = [
    EventHome(),
    PaymentsHome(),
    ScoutsHome(),
  ];
  static final List<String> pageTitles = [
    'Events',
    'Payments',
    'Scouts',
  ];

  static final List<NavigationDestination> destinations = [
    const NavigationDestination(
      icon: Icon(Icons.event),
      label: 'Events',
    ),
    const NavigationDestination(
      icon: Icon(Icons.payment),
      label: 'Payments',
    ),
    const NavigationDestination(
      icon: Icon(Icons.group),
      label: 'Scouts',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[currentPageIndex]),
        centerTitle: false,
      ),

      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),

      body: pages[currentPageIndex],
    );
  }
}
