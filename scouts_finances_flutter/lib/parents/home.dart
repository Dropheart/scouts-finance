import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/main.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({super.key});

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  String query = '';
  late List<Parent> parents;
  String? errorMessage;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _getParents();
  }

  void _getParents() async {
    try {
      final result = await client.parent.getParents();
      setState(() {
        parents = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        parents = [];
        errorMessage =
            "Failed to fetch parents. Are you connected to the internet?";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      body = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16)),
        ),
      );
    } else {
      SearchBar searchBar = SearchBar(
        hintText: 'Search Parents',
        onChanged: (value) => setState(() {
          query = value;
        }),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Icon(Icons.search),
        ),
      );

      List<Card> parentCards = parents
          .map(
            (e) => Card(
              child: ListTile(
                title: Text("${e.firstName} ${e.lastName}"),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email_rounded, size: 14.0),
                        SizedBox(width: 4.0),
                        Text(e.email),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14.0),
                        SizedBox(width: 4.0),
                        Text(e.phone),
                      ],
                    ),
                  ],
                ),
                trailing: Icon(Icons.info_outline),
                onTap: () => {},
              ),
            ),
          )
          .toList();

      body = Column(
        children: [
          searchBar,
          SizedBox(height: 16.0),
          ...parentCards,
        ],
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(padding: const EdgeInsets.all(16.0), child: body),
      ),
    );
  }
}
