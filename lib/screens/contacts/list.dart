import 'package:bytebank_v2/screens/contacts/form.dart';
import 'package:flutter/material.dart';

final _titleApp = 'Contacts';

class ContactsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titleApp,
        ),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(
                'Pedro',
                style: TextStyle(fontSize: 24),
              ),
              subtitle: Text(
                '1000',
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => ContactsForm(),
              ))
              .then(
                (newContact) => debugPrint(
                  newContact.toString(),
                ),
              );
        },
      ),
    );
  }
}
