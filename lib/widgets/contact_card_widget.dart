import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/Utility/image_utility.dart';
import 'package:untitled/model/contact.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class ContactCardWidget extends StatelessWidget {
  ContactCardWidget({
    Key? key,
    required this.contact,
    required this.index,
  }) : super(key: key);

  final Contact contact;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(contact.createdTime);
    final minHeight = 60.00;

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(minHeight: 40),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(width: 2, color: color)
        ),
        child: Row(
          children: [
          //Image.memory(Utility.dataFromBase64String(contact.photo)),
            Container(
              margin: EdgeInsets.all(10),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: contact.photo.isEmpty ? AssetImage('assets/images/icon_user.png') : Image.memory(Utility.dataFromBase64String(contact.photo)).image,
                    //image: Image.memory(Utility.dataFromBase64String(contact.photo)).image,
                    fit: BoxFit.cover
                ),
              ),
            ),
            //Image.asset('assets/images/logo_horizontal.png',height: 50,),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 4),
                Text(
                  contact.firstName+" "+contact.lastName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4,),
                Text(
                  contact.phone,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 100;
      case 2:
        return 100;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
