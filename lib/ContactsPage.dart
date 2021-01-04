import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact> _contacts;
  Map<String, bool> countToValue = <String, bool>{};

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactDetails()));
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
                  subtitle: Text(contact.prefix ?? ''),
                  selected: countToValue[contact.identifier] ?? false,
                  trailing: Checkbox(
                    value: countToValue[contact.identifier] ?? false,
                    onChanged: (bool value) {
                      setState(() {
                        countToValue[contact.identifier] = value;
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
