class UserModel {
  String? id;
  String? fullName;
  String? password;
  String? phoneNumber;
  String? role;
  String? email;

  String deviceId = "";
  String deviceType = "";
  String deviceToken = "";

  UserModel({
    this.id,
    this.fullName,
    this.password,
    this.phoneNumber,
    this.role,
    this.email,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        fullName = json["fullName"],
        password = json["password"],
        phoneNumber = json["phoneNumber"],
        role = json["role"],
        email = json["email"],
        deviceId = json["deviceId"],
        deviceType = json["deviceType"],
        deviceToken = json["deviceToken"];

  @override
  String toString() {
    return 'UserModel{id: $id, fullName: $fullName, password: $password, phoneNumber: $phoneNumber, role: $role, email: $email, deviceId: $deviceId, deviceType: $deviceType, deviceToken: $deviceToken}';
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "password": password,
        "phoneNumber": phoneNumber,
        "role": role,
        "email": email,
        "deviceId": deviceId,
        "deviceType": deviceType,
        "deviceToken": deviceToken,
      };


}
