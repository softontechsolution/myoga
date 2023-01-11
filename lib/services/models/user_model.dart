

//Creating User Model

class UserModel {
  final String? id;
  final String? fullname;
  final String? email;
  final String? password;

  const UserModel ({
    this.id,
    this.fullname,
    this.email,
    this.password,
  });

  toJson(){
    return{
      "FullName": fullname,
      "Email": email,
      "Password": password,
    };
  }

}