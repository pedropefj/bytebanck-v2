import 'package:bytebank_v2/components/container.dart';
import 'package:bytebank_v2/components/progress.dart';
import 'package:bytebank_v2/database/dao/contact_dao.dart';
import 'package:bytebank_v2/models/contact.dart';
import 'package:bytebank_v2/screens/contacts/form.dart';
import 'package:bytebank_v2/screens/transaction/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _titleApp = 'Transfer';

@immutable
abstract class ContactsListState {
  const ContactsListState();
}

@immutable
class LoadingContactsListState extends ContactsListState {
  const LoadingContactsListState();
}

@immutable
class LoadedContactsListState extends ContactsListState {
  final List<Contact> _contacts;

  const LoadedContactsListState(this._contacts);
}

@immutable
class FatalErrorContactsListState extends ContactsListState {
  const FatalErrorContactsListState();
}

class ContactsListCubit extends Cubit<ContactsListState> {
  ContactsListCubit() : super(InitContactsListState());

  void reload(ContactDao contactDao) {
    emit(LoadingContactsListState());
    contactDao
        .findAll()
        .then((contacts) => emit(LoadedContactsListState(contacts)));
  }
}

@immutable
class InitContactsListState extends ContactsListState {
  const InitContactsListState();
}

class ContactsListContainer extends BlocContainer {
  final ContactDao _contactDao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsListCubit>(
      create: (BuildContext context) {
        final cubit = ContactsListCubit();
        cubit.reload(_contactDao);
        return cubit;
      },
      child: ContactsList(_contactDao),
    );
  }
}

class ContactsList extends StatelessWidget {
  final ContactDao _contactDao;

  ContactsList(this._contactDao);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titleApp,
        ),
      ),
      body: BlocBuilder<ContactsListCubit, ContactsListState>(
        builder: (context, state) {
          if (state is InitContactsListState ||
              state is LoadingContactsListState) {
            return Progress();
          }
          if (state is LoadedContactsListState) {
            final List<Contact> contacts = state._contacts;
            return ListView.builder(
              itemBuilder: (context, index) {
                final Contact contact = contacts[index];
                return _ContactItem(
                  contact,
                  onClick: () {
                    push(context, TransactionFormContainer(contact));
                  },
                );
              },
              itemCount: contacts.length,
            );
          }
          return const Text('Unknwn error');
        },
      ),
      floatingActionButton: buildAddContactButton(context),
    );
  }

  FloatingActionButton buildAddContactButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => ContactFormContainer(),
        ));
        _update(context);
      },
    );
  }

  void _update(BuildContext context) {
    context.read<ContactsListCubit>().reload(_contactDao);
  }

}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
