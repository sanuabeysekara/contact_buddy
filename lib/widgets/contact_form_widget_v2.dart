
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../Utility/image_utility.dart';

class UserImageNotifier extends ChangeNotifier {
  var _image = Image.asset('assets/images/add_image_2.png');
  get image => _image;
  String _imageText = "Add Photo";
  String get imageText => _imageText;

  void CustomRefresh(String? imageString) {
    if(imageString!.isEmpty) {
      _image = Image.asset('assets/images/add_image_2.png');
      _imageText = "Add Photo";
    }
    else{
      _image = Image.memory(Utility.dataFromBase64String(imageString));
      _imageText = "Change Photo";
    }
    notifyListeners();


  }

  void UpdateImage(String imageString) {
    //_value++;
    //print(file);

    _image = Image.memory(Utility.dataFromBase64String(imageString));
    _imageText = "Change Photo";
    notifyListeners();


  }
  void changePhotoText(){
  }

}

final userImageProvider = ChangeNotifierProvider((ref) => UserImageNotifier());


class ContactFormWidget extends ConsumerWidget {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? photo;
  final ValueChanged<String> onChangedFirstName;
  final ValueChanged<String> onChangedLastName;
  final ValueChanged<String> onChangedPhone;
  final ValueChanged<String> onChangedEmail;
  final ValueChanged<String> onChangedPhoto;

  const ContactFormWidget(
      {Key? key,
        this.firstName = '',
        this.lastName = '',
        this.phone = '',
        this.email = '',
        this.photo = '',
        required this.onChangedFirstName,
        required this.onChangedLastName,
        required this.onChangedPhone,
        required this.onChangedEmail,
        required this.onChangedPhoto})
      : super(key: key);

  pickImageFromGallery(WidgetRef ref) {

    ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
      //ref.refresh(userImageProvider);

      String imgString = Utility.base64String(await imgFile!.readAsBytes());
      ref.read(userImageProvider).UpdateImage(imgString);
      //ref.refresh(user)
      //print("start of 64 bit");
      //print(imgString);
      //print("end of 64 bit");
      onChangedPhoto(imgString);

    });
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user_image = ref.watch(userImageProvider);
    //ref.read(userImageProvider).CustomRefresh(photo);
    //print("initState Called");



    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                pickImageFromGallery(ref);
                //ref.read(userImageProvider).UpdateImage();
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: user_image.image.image,
                      fit: BoxFit.fill),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(user_image.imageText, style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            ),
            SizedBox(height: 32),

            buildFirstName(),
            SizedBox(height: 16),
            buildLastName(),
            SizedBox(height: 32),
            buildPhone(),
            SizedBox(height: 32),
            buildEmail(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
  Widget buildFirstName() => Container(
    margin: EdgeInsets.only(right: 20),
    child: TextFormField(
      maxLines: 1,
      initialValue: firstName,
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        icon: new IconTheme(
          data: new IconThemeData(
            color: Colors.white70,
            size: 40,
          ),
          child: new Icon(Icons.account_circle_rounded),
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70)),
        border: OutlineInputBorder(),
        hintText: 'First Name',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (title) => title != null && title.isEmpty
          ? 'The First Name cannot be empty'
          : null,
      onChanged: onChangedFirstName,
    ),
  );

  Widget buildLastName() => Container(
    margin: EdgeInsets.only(right: 20,left: 55),
    child: TextFormField(
      maxLines: 1,
      initialValue: lastName,
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        // icon: new IconTheme(
        //   data: new IconThemeData(
        //     color: Colors.white70,
        //     size: 40,
        //   ),
        //   child: new Icon(Icons.account_circle_rounded),
        // ),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70)),
        border: OutlineInputBorder(),
        hintText: ''
            'Last Name',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (title) => title != null && title.isEmpty
          ? 'The First Name cannot be empty'
          : null,
      onChanged: onChangedLastName,
    ),
  );

  Widget buildPhone() => Container(
    margin: EdgeInsets.only(right: 20),
    child: TextFormField(
      maxLines: 1,
      initialValue: phone,
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        icon: new IconTheme(
          data: new IconThemeData(
            color: Colors.white70,
            size: 40,
          ),
          child: new Icon(Icons.phone),
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70)),
        border: OutlineInputBorder(),
        hintText: 'Phone',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (title) => title != null && title.isEmpty
          ? 'The Phone Nubmer cannot be empty'
          : null,
      onChanged: onChangedPhone,
    ),
  );

  Widget buildEmail() => Container(
    margin: EdgeInsets.only(right: 20),
    child: TextFormField(
      maxLines: 1,
      initialValue: email,
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        icon: new IconTheme(
          data: new IconThemeData(
            color: Colors.white70,
            size: 40,
          ),
          child: new Icon(Icons.mail),
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70)),
        border: OutlineInputBorder(),
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (title) => title != null && title.isEmpty
          ? 'The Email cannot be empty'
          : null,
      onChanged: onChangedEmail,
    ),
  );







}



