import 'package:flutter/';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(ContactPro());

class ContactPro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ContactPro")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Text("Bienvenu")),
            RaisedButton(
              child: Text("Créé une suavegarde"),
              color: Colors.orange[900],
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactListdemo()));
              },
            ),
            RaisedButton(
              child: Text("Liste des contacts"),
              color: Colors.orange[900],
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactList()));
              },
            ),
          ],
        ));
  }
}

class ContactListdemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text("ContactPro")),
            body: ListView(
              children: [
                Card(child: ListTile(title: Text('One-line ListTile'))),
                Card(
                  child: ListTile(
                    leading: FlutterLogo(size: 50.0),
                    title: Text('First Name and Last Name'),
                    subtitle: Text('77 78 51 35'),
                  ),
                ),
              ],
            )));
  }
}

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  Map<int, bool> countToValue = <int, bool>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Three-line list'),
      ),
      body: ListView(
        children: [
          for (int count in List.generate(9, (index) => index + 1))
            Card(
              child: ListTile(
                onTap: () {
                  print("hello");
                },
                title: Text('List item $count'),
                subtitle: Text('Secondary text'),
                leading: FlutterLogo(size: 50.0),
                selected: countToValue[count] ?? false,
                trailing: Checkbox(
                  value: countToValue[count] ?? false,
                  onChanged: (bool value) {
                    setState(() {
                      countToValue[count] = value;
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
