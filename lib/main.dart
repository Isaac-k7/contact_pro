import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() => runApp(ContactPro());
class ContactPro extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: HomePage()
        );
  }
}

class HomePage extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("ContactPro")),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Center(child: Text("Bienvenu")),
                RaisedButton(
                    child: Text("Créé une suavegarde"),
                    color: Colors.orange[900],
                    onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ContactList()));
                    },
                ),
            ],
        )
    );
    }
}

class ContactList extends StatelessWidget{
@override
Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text("ContactPro")),
            body: ListView(
                children: const <Widget>[
                    Card(child: ListTile(title: Text('One-line ListTile'))),

                    Card(
                    child: ListTile(

                        leading: FlutterLogo(size: 50.0),
                        title: Text('First Name and Last Name'),
                        subtitle: Text('77 78 51 35'),
                        trailing: Icon(Icons.more_vert),


                    ),
                    ),
                ],
            )
        )
    );
}

}



