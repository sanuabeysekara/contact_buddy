final String tableContact = 'contacts';

class ContactFields{

  static final List<String> values = [
    /// Add all fields
    id, firstName, lastName, phone, email, createdTime, photo
  ];

  static final String id= '_id';
  static final String firstName= 'firstName';
  static final String lastName= 'lastName';
  static final String phone= 'phone';
  static final String email= 'email';
  static final String createdTime= 'createdTime';
  static final String photo='photo';

}

class Contact{
  final int? id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String photo;
  final DateTime createdTime;

  const Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.createdTime,
    required this.photo,
  });

  Contact copy({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    DateTime? createdTime,
    String? photo,
  }) =>
      Contact(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        createdTime: createdTime ?? this.createdTime,
        photo: photo ?? this.photo,
      );

  static Contact fromJson(Map<String, Object?> json) => Contact(
    id: json[ContactFields.id] as int?,
    firstName: json[ContactFields.firstName] as String,
    lastName: json[ContactFields.lastName] as String,
    phone: json[ContactFields.phone] as String,
    email: json[ContactFields.email] as String,
    createdTime: DateTime.parse(json[ContactFields.createdTime] as String),
    photo: json[ContactFields.photo] as String,
  );

  Map<String, Object?> toJson() => {
    ContactFields.id: id,
    ContactFields.firstName: firstName,
    ContactFields.lastName: lastName,
    ContactFields.phone: phone,
    ContactFields.email: email,
    ContactFields.createdTime: createdTime.toIso8601String(),
    ContactFields.photo: photo,
  };
}