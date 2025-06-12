import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:flutter/material.dart';
import 'package:scouts_finances_flutter/admin_home_page.dart';
import 'package:scouts_finances_flutter/parent_home_page.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

typedef SetPageFunc = void Function(int index);

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPageIndex = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AdminHomepage(
        setPageFunc: (index) => setState(() {
          currentPageIndex = index;
        }),
      ),
      ParentHomepage(
        setPageFunc: (index) => setState(() {
          currentPageIndex = index;
        }),
      ),
    ];

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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            cardTheme: const CardThemeData(elevation: 1.0),
            searchBarTheme: const SearchBarThemeData(
                elevation: WidgetStatePropertyAll(0.0))),
        home: pages[currentPageIndex]);
  }
}
