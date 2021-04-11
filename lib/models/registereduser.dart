// model for users that are already registered with application(patient,doctor,admin)

class RegisteredUser {
  final String uid;
  final String email;
  final String role;

  RegisteredUser({this.uid, this.email, this.role});

  String get roleGet {
    return this.role;
  }

  String get emailGet {
    return this.email;
  }
}
