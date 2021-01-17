import 'package:bytebank_v2/components/container.dart';
import 'package:bytebank_v2/components/error.dart';
import 'package:bytebank_v2/components/progress.dart';
import 'package:bytebank_v2/database/dao/contact_dao.dart';
import 'package:bytebank_v2/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _titleAppBar = 'New contact';
final _labelTextName = 'Full Name';
final _labelTextAccountNumber = 'Account Number';
final _labelButtonCreate = 'Create';

@immutable
abstract class ContactFormState {
  const ContactFormState();
}

@immutable
class SendingState extends ContactFormState {
  const SendingState();
}

@immutable
class SentState extends ContactFormState {
  const SentState();
}

@immutable
class FatalErrorFormState extends ContactFormState {
  final String _message;

  const FatalErrorFormState(this._message);
}

@immutable
class ShowFormState extends ContactFormState {
  const ShowFormState();
}

class ContactFormCubit extends Cubit<ContactFormState> {
  ContactFormCubit() : super(ShowFormState());

  void save(Contact contactCreated, BuildContext context) async {
    emit(SendingState());
    await _send(
      contactCreated,
      context,
    );
  }

  _send(Contact contactCreated, BuildContext context) async {
    await ContactDao()
        .save(contactCreated)
        .then((contactId) => emit(SentState()))
        .catchError((e) {
      emit(FatalErrorFormState('Fail sava contact'));
    }, test: (e) => e is Exception);
  }
}

class ContactFormContainer extends BlocContainer {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactFormCubit>(
        create: (BuildContext context) {
          return ContactFormCubit();
        },
        child: BlocListener<ContactFormCubit, ContactFormState>(
          listener: (context, state) {
            if (state is SentState) {
              Navigator.pop(context);
            }
          },
          child: ContactFormStateless(),
        ));
  }
}

class ContactFormStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactFormCubit, ContactFormState>(
        builder: (context, state) {
      if (state is ShowFormState) {
        return _BasicForm();
      }
      if (state is SendingState || state is SentState) {
        return ProgressView();
      }
      if (state is FatalErrorFormState) {
        return ErrorView(state._message);
      }
      return ErrorView("Unknown error");
    });
  }
}

class _BasicForm extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

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
              ),
              Padding(
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
                      final int accountNumber =
                          int.tryParse(_accountNumberController.text);

                      if (_validContact(name, accountNumber)) {
                        final Contact newContact =
                            Contact(name: name, accountNumber: accountNumber);
                        BlocProvider.of<ContactFormCubit>(context)
                            .save(
                            newContact, context);
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

  _validContact(name, accountNumber) {
    bool _valid = name != null && accountNumber != null;
    return _valid;
  }
}
