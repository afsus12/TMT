class userLogin {
  String email;
  String password;

  userLogin({required this.email, required this.password});
}

class userRegistration {
  String email;
  String firstname;
  String lastname;
  String password;

  userRegistration(
      {required this.email,
      required this.firstname,
      required this.lastname,
      required this.password});
}

class organisation {
  String? guid;
  String? name;

  organisation({this.guid, this.name});
}

class appUser {
  String? guid;
  String? token;
  String? email;
  bool? isvalidated = true;
  String? organisation;

  appUser(
      {this.email, this.guid, this.token, this.isvalidated, this.organisation});
}
