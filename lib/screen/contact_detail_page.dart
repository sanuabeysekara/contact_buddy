import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/helper/db_helper.dart';
import 'package:untitled/model/contact.dart';
import 'package:untitled/screen/edit_contact_page.dart';

import '../Utility/image_utility.dart';

class ContactDetailPage extends StatefulWidget {
  final int noteId;

  const ContactDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  late Contact contact;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.contact = await DBHelper.instance.readContact(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                  Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: contact.photo.isEmpty ? AssetImage('assets/images/icon_user.png') : Image.memory(Utility.dataFromBase64String(contact.photo)).image ,
                        fit: BoxFit.fitHeight),
                  ),),
                    SizedBox(height: 16),


                    Center(
                      child:   Text(
                        contact.firstName+" "+contact.lastName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ),
                    SizedBox(height: 8),

                    Center(
                      child:Text(
                        DateFormat.yMMMd().format(contact.createdTime),
                        style: TextStyle(color: Colors.white38),
                      ),

                    ),

                    SizedBox(height: 32),

                    Center(
                      child: Row(
                          children: <Widget>[
                            IconTheme(
                              data: new IconThemeData(
                                  color: Colors.white70, size: 28),
                              child: new Icon(Icons.phone),
                            ),
                            SizedBox(width: 16),
                            Text(contact.phone,
                              style: TextStyle(color: Colors.white70, fontSize: 22),
                            )

                          ]
                      ),
                    ),

                    SizedBox(height: 16),
                    Center(
                      child: Row(
                          children: <Widget>[
                            IconTheme(
                              data: new IconThemeData(
                                  color: Colors.white70, size: 28),
                              child: new Icon(Icons.email),
                            ),
                            SizedBox(width: 16),
                            Text(contact.email,
                              style: TextStyle(color: Colors.white70, fontSize: 22),
                            )

                          ]
                      ),
                    ),
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditContactPage(contact: this.contact),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await DBHelper.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}
