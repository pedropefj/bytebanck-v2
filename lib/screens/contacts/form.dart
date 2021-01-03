import 'package:bytebank_v2/models/contact.dart';
import 'package:flutter/material.dart';

final _titleAppBar = 'New contact';
final _labelTextName = 'Full Name';
final _labelTextAccountNumber = 'Account Number';
final _labelButtonCreate = 'Create';

class ContactsForm extends StatefulWidget {

  @override
  _ContactsFormState createState() => _ContactsFormState();
}

class _ContactsFormState extends State<ContactsForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: _labelTextName,
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                  controller: _nameController,
              ), Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: _labelTextAccountNumber,
                  ),
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                  keyboardType: TextInputType.number,
                  controller: _accountNumberController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text(_labelButtonCreate),
                    onPressed: () {
                      final String name = _nameController.text;
                      final int accountNumber = int.tryParse(_accountNumberController.text);

                      if(_validContact(name, accountNumber)){
                        final Contact newContact = Contact(0 ,name, accountNumber);
                        Navigator.pop(context, newContact);
                      }

                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _validContact(name, accountNumber){
    bool _valid = name != null && accountNumber != null;
    return _valid;
  }
}
