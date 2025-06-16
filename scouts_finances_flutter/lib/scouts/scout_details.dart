import 'package:flutter/material.dart';
import 'package:scouts_finances_client/scouts_finances_client.dart';
import 'package:scouts_finances_flutter/extensions/name.dart';
import 'package:scouts_finances_flutter/main.dart';
import 'package:scouts_finances_flutter/parents/parent_details.dart';
import 'package:scouts_finances_flutter/scouts/events_table.dart';

class ScoutDetailsView extends StatefulWidget {
  final int scoutId;
  const ScoutDetailsView({super.key, required this.scoutId});

  @override
  State<StatefulWidget> createState() => _ScoutDetailsViewState();
}

class _ScoutDetailsViewState extends State<ScoutDetailsView> {
  late Child scout;
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getChild();
  }

  void _getChild() async {
    try {
      final result = await client.scouts.getChildById(widget.scoutId);
      setState(() {
        if (result == null) {
          errorMessage = "Scout not found.";
        } else {
          scout = result;
        }
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load scout details.";
        loading = false;
      });
    }
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
          child: Text(errorMessage!),
        ),
      );
    }

    final body = ListView(children: [
      Text('Scout Details:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Table(
              columnWidths: {
                0: IntrinsicColumnWidth(),
              },
              children: [
                TableRow(children: [
                  Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(scout.fullName),
                ]),
                TableRow(children: [
                  Text("Parent", style: TextStyle(fontWeight: FontWeight.bold)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ParentDetails(parentId: scout.parentId);
                        })),
                      },
                      child: Text(scout.parent!.fullName),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Text("Group", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(scout.scoutGroup?.name ?? "N/A"),
                ]),
              ],
            ),
          ),
          const Icon(Icons.account_circle, size: 75, color: Colors.blue),
          const SizedBox(width: 16),
        ],
      ),
      const SizedBox(height: 16),
      Text(
        "Subscribed Events:",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      ChildEventsTable(child: scout),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? 'Loading Scout...' : scout.fullName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: body,
      ),
    );
  }
}
