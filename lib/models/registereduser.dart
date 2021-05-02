// model for users that are already registered with application(patient,doctor,admin)

class RegisteredUser {
  // automatically generated uid
  final String uid;
  final String email;
  final String role;
  // user id set by developer on firebase
  final String userid;
  RegisteredUser({this.uid, this.email, this.role, this.userid});

  String get roleGet {
    return this.role;
  }

  String get emailGet {
    return this.email;
  }

  String get userIdGet {
    return this.userid;
  }
}
