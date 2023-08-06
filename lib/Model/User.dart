
class User {

  late final String id;
  late final String name;
  late final String email;

  User();
  User.data(this.id,this.name, this.email);

  // User.fromMap(Map<String, dynamic> result)
  //     : id = result["id"],
  //       name = result["name"],
  //       email = result["email"];
  // Map<String, Object> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'email': email,
  //   };
  // }

}