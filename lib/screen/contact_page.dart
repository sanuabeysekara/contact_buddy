import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:untitled/helper/db_helper.dart';
import 'package:untitled/model/contact.dart';
import 'package:untitled/screen/edit_contact_page.dart';
import '../widgets/contact_card_widget.dart';
import 'contact_detail_page.dart';


class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);
  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late List<Contact> contacts;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshContacts();
  }

  @override
  void dispose() {
    DBHelper.instance.close();

    super.dispose();
  }

  Future refreshContacts() async {
    setState(() => isLoading = true);

    this.contacts = await DBHelper.instance.readAllContacts();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo_horizontal.png',fit: BoxFit.fitHeight,height: 50),
        actions: [
          IconButton(
              icon:Icon(Icons.search),
              onPressed: (){
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
                //print("search");
              },
          ),
          SizedBox(width: 12,),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : contacts.isEmpty
            ? Text(
              "No Contacts",
              style: TextStyle(fontSize: 24,color: Colors.white),
            )
            : buildContacts(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditContactPage()),
          );

          refreshContacts();
        },
      ),
    );

  }

  Widget buildContacts() => StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: contacts.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
    crossAxisCount: 1,
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    itemBuilder: (context, index) {
      final contact = contacts[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ContactDetailPage(noteId: contact.id!),
          ));

          refreshContacts();
        },
        child: ContactCardWidget(contact: contact, index: index),
      );
    },
  );

}


class CustomSearchDelegate extends SearchDelegate {
  late List<Contact> contacts;

  //CustomSearchDelegate(this.contacts);
  Future refreshContacts() async {

    this.contacts = await DBHelper.instance.readAllContacts();
    return contacts.where((element) => element.firstName.toLowerCase().contains(
      query.toLowerCase(),
    )).toList();

  }


  @override
  List<Widget> buildActions(BuildContext context) {
    refreshContacts();





    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if(query.isEmpty){
            close(context, null);
          }
          else{
          query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: refreshContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data.length,
            staggeredTileBuilder: (index) => StaggeredTile.fit(1),
            crossAxisCount: 1,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            itemBuilder: (context, index) {
              final contact = snapshot.data[index];

              return GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ContactDetailPage(noteId: contact.id!),
                  ));

                  //refreshContacts();
                },
                child: ContactCardWidget(contact: contact, index: index),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );




    final searchedContacts = contacts.where((element) => element.firstName.toLowerCase().contains(
    query.toLowerCase(),
  )).toList();
  //print(searchedContacts.toString());
  return StaggeredGridView.countBuilder(
    padding: EdgeInsets.all(8),
    itemCount: searchedContacts.length,
    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
    crossAxisCount: 1,
    mainAxisSpacing: 1,
    crossAxisSpacing: 1,
    itemBuilder: (context, index) {
      final contact = searchedContacts[index];

      return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ContactDetailPage(noteId: contact.id!),
          ));

          //refreshContacts();
        },
        child: ContactCardWidget(contact: contact, index: index),
      );
    },
  );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
  //print(contacts[2].photo);

    return FutureBuilder(
      future: refreshContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data.length,
            staggeredTileBuilder: (index) => StaggeredTile.fit(1),
            crossAxisCount: 1,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            itemBuilder: (context, index) {
              final contact = snapshot.data[index];

              return GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ContactDetailPage(noteId: contact.id!),
                  ));

                  //refreshContacts();
                },
                child: ContactCardWidget(contact: contact, index: index),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }
}