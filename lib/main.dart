import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

final speakers = [
  {"name": "Kamal Vaid", "claps": 0},
  {"name": "Pawan Kumar", "claps": 0},
  {"name": "Dhrumil Shah", "claps": 0},
  {"name": "Suraj Kumar", "claps": 0},
  {"name": "Tushar Shrivastav", "claps": 0},
  {"name": "Pooja Guleria", "claps": 0},
  {"name": "Shiv Prakash", "claps": 0},
  {"name": "Sonakshi Shukla", "claps": 0},
  {"name": "Varsha Jaiswal", "claps": 0},
  {"name": "Vrijraj Singh", "claps": 0}
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speakers List',
      home: ListViewApp(),
    );
  }
}

class ListViewApp extends StatefulWidget {
  @override
  _ListViewAppState createState() => _ListViewAppState();
}

class _ListViewAppState extends State<ListViewApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speaker List"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("speakers").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        });
    // return _buildList(context, speakers);
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
        key: ValueKey(record.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0)),
            child: ListTile(
                title: Text(record.name),
                trailing: Text(record.claps.toString()),
                onTap: () =>
                    record.reference.updateData({'claps': record.claps + 1}))));
  }
}

class Record {
  final String name;
  final int claps;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['claps'] != null),
        name = map['name'],
        claps = map['claps'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$claps>";
}
