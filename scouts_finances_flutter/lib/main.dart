import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/events/home.dart';
import 'package:scouts_finances_flutter/parents/home.dart';
import 'package:scouts_finances_flutter/payments/home.dart';
import 'package:scouts_finances_flutter/popups.dart';
import 'package:scouts_finances_flutter/scouts/home.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice instead of
/// using a global client object. This is just a simple example.
late final Client client;

late String serverUrl;

void main() {
  // When you are running the app on a physical device, you need to set the
  // server URL to the IP address of your computer. You can find the IP
  // address by running `ipconfig` on Windows or `ifconfig` on Mac/Linux.
  // You can set the variable when running or building your app like this:
  // E.g. `flutter run --dart-define=SERVER_URL=https://api.example.com/`
  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl =
      serverUrlFromEnv.isEmpty ? 'http://$localhost:8080/' : serverUrlFromEnv;

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scouts Finances',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          cardTheme: const CardThemeData(elevation: 1.0),
          searchBarTheme:
              const SearchBarThemeData(elevation: WidgetStatePropertyAll(0.0))),
      home: const HomePage(title: 'Scouts Finances Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  static final List<Widget> pages = [
    EventHome(),
    PaymentsHome(),
    ScoutsHome(),
    ParentHome()
  ];
  static final List<String> pageTitles = [
    'Events',
    'Payments',
    'Scouts',
    'Parents',
  ];

  static final List<NavigationDestination> destinations = [
    const NavigationDestination(
      icon: Icon(Icons.event),
      label: 'Events',
    ),
    const NavigationDestination(
      icon: Icon(Icons.attach_money),
      label: 'Payments',
    ),
    const NavigationDestination(
      icon: Icon(Icons.hiking),
      label: 'Scouts',
    ),
    const NavigationDestination(
      icon: Icon(Icons.supervisor_account),
      label: 'Parents',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colours = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitles[currentPageIndex],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colours.onPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: colours.primary,
        actions: [
          OptionsMenu(),
        ],
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
