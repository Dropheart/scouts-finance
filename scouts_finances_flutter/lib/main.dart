import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_flutter/events/home.dart';
import 'package:scouts_finances_flutter/parents/home.dart';
import 'package:scouts_finances_flutter/payments/home.dart';
import 'package:scouts_finances_flutter/popups.dart';
import 'package:scouts_finances_flutter/scouts/home.dart';
import 'package:scouts_finances_flutter/services/scout_groups_service.dart';
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

  final scoutGroupsService = ScoutGroupsService();
  await scoutGroupsService.getScoutGroups();

  runApp(MyApp(
    themeService: themeService,
    scoutGroupsService: scoutGroupsService,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;
  final ScoutGroupsService scoutGroupsService;

  const MyApp(
      {super.key,
      required this.themeService,
      required this.scoutGroupsService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeService),
        ChangeNotifierProvider.value(value: scoutGroupsService)
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Scout Finance Manager',
            theme: themeService.themeData,
            home: const HomePage(title: 'Scout Finance Manager'),
          );
        },
      ),
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
    ParentHome(),
    SettingsHome()
  ];
  static final List<String> pageTitles = [
    'Events',
    'Income',
    'Scouts',
    'Parents',
  ];

  static final List<NavigationDestination> destinations = [
    const NavigationDestination(
      icon: Icon(Icons.event),
      label: 'Events',
    ),
    const NavigationDestination(
      icon: Icon(Icons.currency_pound),
      label: 'Income',
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
        actions: [OptionsMenu(selectedIndex: currentPageIndex)],
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
