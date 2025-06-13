import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_flutter/events/home.dart';
import 'package:scouts_finances_flutter/parents/home.dart';
import 'package:scouts_finances_flutter/payments/home.dart';
import 'package:scouts_finances_flutter/popups.dart';
import 'package:scouts_finances_flutter/scouts/home.dart';
import 'package:scouts_finances_flutter/settings/home.dart';
import 'package:scouts_finances_flutter/services/theme_service.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late final Client client;

late String serverUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
  final serverUrl =
      serverUrlFromEnv.isEmpty ? 'http://$localhost:8080/' : serverUrlFromEnv;

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  final themeService = ThemeService();
  await themeService.loadTheme();

  runApp(MyApp(themeService: themeService));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;

  const MyApp({super.key, required this.themeService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeService,
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Scout Finance Manager',
            theme: themeService.themeData,
            home: const MyHomePage(title: 'Scout Finance Manager'),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
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
    ParentHome(),
    SettingsHome()
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

  Future<void> switchScoutGroup() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Switch Scout Group'),
          content: const Text('This feature is not implemented yet.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitles[currentPageIndex],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          OptionsMenu(selectedIndex: currentPageIndex)
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
