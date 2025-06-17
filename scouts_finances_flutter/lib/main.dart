import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouts_finances_flutter/events/home.dart';
import 'package:scouts_finances_flutter/parents/home.dart';
import 'package:scouts_finances_flutter/payments/home.dart';
import 'package:scouts_finances_flutter/popups.dart';
import 'package:scouts_finances_flutter/services/account_type_service.dart';
import 'package:scouts_finances_flutter/services/scout_groups_service.dart';
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

  final accountTypeService = AccountTypeService();

  runApp(MyApp(
    themeService: themeService,
    scoutGroupsService: scoutGroupsService,
    accountTypeService: accountTypeService,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;
  final ScoutGroupsService scoutGroupsService;
  final AccountTypeService accountTypeService;

  const MyApp({
    super.key,
    required this.themeService,
    required this.scoutGroupsService,
    required this.accountTypeService,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeService),
        ChangeNotifierProvider.value(value: scoutGroupsService),
        ChangeNotifierProvider.value(value: accountTypeService),
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
    ParentHome(),
  ];
  static final List<String> pageTitles = [
    'Events',
    'Income',
    'People',
  ];

  final selectScoutGroup = Consumer<ScoutGroupsService>(
      builder: (context, scoutGroupsService, child) {
    final currentGroup = scoutGroupsService.currentScoutGroup;
    return PopupMenuButton<ScoutGroup>(
        itemBuilder: (_) {
          return scoutGroupsService.scoutGroups
              .map((group) => PopupMenuItem(
                    value: group,
                    // enabled: group.id != currentGroup.id,
                    child: Text(group.name,
                        style: TextStyle(
                          fontWeight: group.id == currentGroup.id
                              ? FontWeight.w900
                              : FontWeight.normal,
                        )),
                  ))
              .toList()
            ..add(PopupMenuItem(
                value: ScoutGroup(name: '', colour: GroupColour.black),
                child: Text('+ Add New Group')));
        },
        onSelected: (group) {
          if (group == currentGroup) return;
          // Horrible, horrible workaround because if selection is null, onSelected isn't called.
          // Instead, onCancelled is called... which is also called when the user taps outside the menu.
          // MenuAnchor is preferred over PopupMenuButton ... but it is not animated and thus is inconsistent
          /// with the options next to this button. There are ways to animate it, but they're more pain than
          /// they're worth. There's a PR to animate MenuAnchor but it hasn't been merged yet.
          /// Pain.
          if (group.id == null) {
            scoutGroupsService.showCreateScoutGroupPopup(context);
            return;
          }
          scoutGroupsService.setCurrentScoutGroup(context, group);
        },
        icon: Icon(Icons.groups));
  });

  Widget _buildHomePage(
      BuildContext context, AccountTypeService accountTypeService) {
    final accountType = accountTypeService.accountType;

    final List<Widget> destinations = [
      GestureDetector(
        child: NavigationDestination(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity == null ||
              details.primaryVelocity!.abs() < 2000) {
            return;
          }
          accountTypeService.setAccountType(
            accountType == AccountType.treasurer
                ? AccountType.leader
                : AccountType.treasurer,
          );
        },
      ),
      const NavigationDestination(
        icon: Icon(Icons.currency_pound),
        label: 'Income',
      ),
      const NavigationDestination(
        icon: Icon(Icons.supervisor_account),
        label: 'People',
      ),
    ];

    final filteredDests = List<Widget>.from(destinations);
    final filteredPages = List<Widget>.from(pages);
    final filteredTitles = List<String>.from(pageTitles);
    if (accountType == AccountType.leader) {
      filteredDests.removeAt(1); // Remove Payments tab for leaders
      filteredPages.removeAt(1); // Remove Payments tab for leaders
      filteredTitles.removeAt(1); // Remove Payments title for leaders
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          filteredTitles[currentPageIndex],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          if (accountType == AccountType.leader)
            selectScoutGroup
          else
            OptionsMenu(selectedIndex: currentPageIndex)
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: filteredDests,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: filteredPages[currentPageIndex],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountTypeService>(
      builder: (context, accountTypeService, child) {
        return _buildHomePage(context, accountTypeService);
      },
    );
  }
}
