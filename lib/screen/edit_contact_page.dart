import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:untitled/helper/db_helper.dart';
import 'package:untitled/model/contact.dart';
import 'package:untitled/widgets/contact_form_widget.dart';

class AddEditContactPage extends StatefulWidget {
  final Contact? contact;

  const AddEditContactPage({
    Key? key,
    this.contact,
  }) : super(key: key);
  @override
  _AddEditContactPageState createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String telephone;
  late String email;
  late String photo;

  @override
  void initState() {
    super.initState();

    firstName = widget.contact?.firstName ?? '';
    lastName = widget.contact?.lastName ?? '';
    telephone = widget.contact?.phone ?? '';
    email = widget.contact?.email ?? '';
    photo = widget.contact?.photo ?? '';

  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: ContactFormWidget(
            firstName: firstName,
            lastName: lastName,
            phone: telephone,
            email: email,
            photo: photo,
            onChangedFirstName: (firstName) => setState(() {
              this.firstName = firstName;
            }),
            onChangedLastName: (lastName) => setState(() {
              this.lastName = lastName;
            }),
            onChangedEmail: (email) => setState(() {
              this.email = email;
            }),
            onChangedPhone: (phone) => setState(() {
              this.telephone = phone;
            }),
            onChangedPhoto: (photo) => setState(() {
              this.photo = photo;
            }),
            // onChangedImportant: (isImportant) =>
            //     setState(() => this.isImportant = isImportant),
            // onChangedNumber: (number) => setState(() => this.number = number),
            // onChangedTitle: (title) => setState(() => this.title = title),
            // onChangedDescription: (description) =>
            //     setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = firstName.isNotEmpty && lastName.isNotEmpty && telephone.isNotEmpty && email.isNotEmpty && photo.isNotEmpty ;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.contact != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final contact = widget.contact!.copy(
      firstName: firstName,
      lastName: lastName,
      phone: telephone,
      email: email,
      photo: photo,
    );

    await DBHelper.instance.update(contact);
  }

  Future addNote() async {
    final contact = Contact(
      firstName: firstName,
      lastName: lastName,
      phone: telephone,
      email: email,
      photo: photo,
      createdTime: DateTime.now(),
    );
    print(contact.toJson());
    await DBHelper.instance.create(contact);
  }
}
