import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/scouts/scout_details.dart';

class ScoutsHome extends StatefulWidget {
  const ScoutsHome({super.key});

  @override
  State<ScoutsHome> createState() => _ScoutsHomeState();
}

class _ScoutsHomeState extends State<ScoutsHome> {
  late List<Child> children;
  String? errorMessage;
  bool loading = true;
  String query = '';

  void _getChildren() async {
    try {
      final result = await client.scouts.getChildren();
      setState(() {
        children = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage =
            'Failed to load children. Are you connected to the internet? If this error persists, please contact the developers.';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getChildren();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16)),
        ),
      );
    }

    List<Child> filteredChildren = children.where((child) {
      if (query.isEmpty) return true;
      final searchTerm = query.toLowerCase();
      return "${child.firstName} ${child.lastName}"
          .toLowerCase()
          .contains(searchTerm);
    }).toList();

    List<Card> childCards = filteredChildren.map((child) {
      return Card(
          child: ListTile(
        title: Text('${child.firstName} ${child.lastName}'),
        subtitle: Text('Section, finance overview here'),
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScoutDetailsView(scoutId: child.id!)));
        },
        trailing: const Icon(Icons.arrow_forward),
      ));
    }).toList();

    SearchBar searchBar = SearchBar(
      onChanged: (value) {
        setState(() {
          query = value;
        });
      },
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: const Icon(Icons.search),
      ),
      hintText: 'Search by name...',
    );

    ListView body = ListView(
      children: [
        searchBar,
        SizedBox(height: 16.0),
        ...childCards,
      ],
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16.0),
          child: body,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Child'),
                content: Text('This feature is not implemented yet.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          ).then((_) {
            _getChildren();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
