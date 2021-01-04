import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() => runApp(ContactPro());

class ContactPro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: HomePage.pageName, routes: {
      HomePage.pageName: (context) => HomePage(),
      ContactList.pageName: (context) => ContactList(),
    });
  }
}

class HomePage extends StatelessWidget {
  static const pageName = "/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text("ContactPro"))),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Text("Bienvenu")),
            RaisedButton(
              child: Text("Créé une suavegarde"),
              color: Colors.orange[900],
              onPressed: () {
                print('hello');
              },
            ),
            RaisedButton(
              child: Text("Liste des contacts"),
              color: Colors.orange[900],
              onPressed: () async {
                final PermissionStatus permissionStatus =
                    await _getPermission();
                if (permissionStatus == PermissionStatus.granted) {
                  //We can now access our contacts here
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NavBar()));
                } else {
                  //If permissions have been denied show standard cupertino alert dialog
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                            title: Text('Permissions error'),
                            content:
                                Text('Veuillez activer l\'accès aux contacts '
                                    'dans les paramètres système'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text('OK'),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          ));
                }
              },
            ),
          ],
        ));
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}

class ContactList extends StatefulWidget {
  static const pageName = "ContactList";
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  Map<int, bool> countToValue = <int, bool>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

class ContactDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Center(child: Text("ContactPro"))),
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

class NavBar extends StatelessWidget {
  static const pageName = "NavBar";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            //backgroundColor: Color(0xFF1D1B1B),
            bottom: TabBar(
              tabs: [
                Tab(
                  //icon: Icon(Icons.flash_on),
                  text: 'Mes contacts',
                ),
                Tab(
                  //icon: Icon(Icons.sync),
                  text: 'Non modifié',
                ),
                Tab(
                  //icon: Icon(Icons.storage),
                  text: 'Déja modifié',
                ),
              ],
            ),
            title: Center(child: Text('ContactPro')),
          ),
          body: TabBarView(
            children: [
              ContactsPage(),
              ContactList(),
              ContactList(),
            ],
          ),
        ),
      ),
    );
  }
}

class SeeContactsButton extends StatelessWidget {
  static const pageName = "SeeContactsButton";
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        final PermissionStatus permissionStatus = await _getPermission();
        if (permissionStatus == PermissionStatus.granted) {
          //We can now access our contacts here
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ContactList()));
        }
      },
      child: Container(child: Text('See Contacts')),
    );
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact> _contacts;
  Map<String, bool> countToValue = <String, bool>{};
  bool value = false;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts?.elementAt(index);
                return Card(
                    child: ListTile(
                  onTap: () {
                    setState(() {
                      this.value = value;
                    });
                  },
                  leading: (contact.avatar != null && contact.avatar.isNotEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar),
                        )
                      : CircleAvatar(
                          child: Text(contact.initials()),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                  title: Text(contact.displayName ?? ''),
                  subtitle: Text(contact.phones.elementAt(0).value ?? ''),
                  trailing: Checkbox(
                    value: this.value ?? false,
                    onChanged: (bool value) {},
                  ),
                  //This can be further expanded to showing contacts detail
                  // onPressed().
                ));
              },
            )
          : Center(child: const CircularProgressIndicator()),
    );
    // Widget builSingleCheckbox(NotificationSettings notification) =>
    //     buildChec²kbox();
  }
}

class ContactUpdate extends StatefulWidget {
  @override
  _ContactUpState createState() => _ContactUpState();
}

class _ContactUpState extends State<ContactsPage> {
  Iterable<Contact> _contactsUpdate;
  Map<String, bool> countToValue = <String, bool>{};

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contactsUpdate =
        await ContactsService.getContacts();
    setState(() {
      _contactsUpdate = contactsUpdate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contactsUpdate != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              itemCount: _contactsUpdate?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contactsUpdate = _contactsUpdate?.elementAt(index);
                return Card(
                    child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactDetails()));
                  },
                  leading: (contactsUpdate.avatar != null &&
                          contactsUpdate.avatar.isNotEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contactsUpdate.avatar),
                        )
                      : CircleAvatar(
                          child: Text(contactsUpdate.initials()),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                  title: Text(contactsUpdate.displayName ?? ''),
                  subtitle: Text(contactsUpdate.prefix ?? ''),
                  selected: countToValue[contactsUpdate.identifier] ?? false,
                  trailing: Checkbox(
                    value: countToValue[contactsUpdate.identifier] ?? false,
                    onChanged: (bool value) {
                      setState(() {
                        countToValue[contactsUpdate.identifier] = value;
                      });
                    },
                  ),
                  //This can be further expanded to showing contacts detail
                  // onPressed().
                ));
              },
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}
