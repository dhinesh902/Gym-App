import 'dart:io';

class MemberRegisterRequest {
  final String fullname;
  final String email;
  final String password;
  final String phone;
  final String dateofbirth;
  final String gender;
  final String emergency;
  final String address;
  final String height;
  final String weight;
  final String bloodgroup;
  final String fitnessgoal;
  final String assignedtrainer;
  final String membershipplanid;
  final String joiningdate;
  final String status;
  final File? profilephoto;

  MemberRegisterRequest({
    required this.fullname,
    required this.email,
    required this.password,
    required this.phone,
    required this.dateofbirth,
    required this.gender,
    required this.emergency,
    required this.address,
    required this.height,
    required this.weight,
    required this.bloodgroup,
    required this.fitnessgoal,
    required this.assignedtrainer,
    required this.membershipplanid,
    required this.joiningdate,
    required this.status,
    this.profilephoto,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'password': password,
      'phone': phone,
      'dateofbirth': dateofbirth,
      'gender': gender,
      'emergency': emergency,
      'address': address,
      'height': height,
      'weight': weight,
      'bloodgroup': bloodgroup,
      'fitnessgoal': fitnessgoal,
      'assignedtrainer': assignedtrainer,
      'membershipplanid': membershipplanid,
      'joiningdate': joiningdate,
      'status': status,
    };
  }
}

class TrainerRegisterRequest {
  final String fullname;
  final String email;
  final String password;
  final String phone;
  final String dateofbirth;
  final String speciality;
  final String experience;
  final String shifttiming;

  TrainerRegisterRequest({
    required this.fullname,
    required this.email,
    required this.password,
    required this.phone,
    required this.dateofbirth,
    required this.speciality,
    required this.experience,
    required this.shifttiming,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'password': password,
      'phone': phone,
      'dateofbirth': dateofbirth,
      'speciality': speciality,
      'experience': experience,
      'shifttiming': shifttiming,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class AuthUser {
  final int id;
  final String role;
  final String? message;

  AuthUser({
    required this.id,
    required this.role,
    this.message,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] ?? 0,
      role: json['role'] ?? '',
      message: json['message'],
    );
  }
}

class AuthResponse {
  final int status;
  final String? token;
  final AuthUser? user;
  final String? message;

  AuthResponse({
    required this.status,
    this.token,
    this.user,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    
    String? token;
    AuthUser? user;
    String? message;
    
    if (data is Map<String, dynamic>) {
      token = data['token'];
      user = data['user'] != null ? AuthUser.fromJson(data['user']) : null;
      message = data['message'];
    }

    return AuthResponse(
      status: json['status'] ?? 0,
      token: token,
      user: user,
      message: message,
    );
  }
}

class TrainerModel {
  final int id;
  final String fullname;

  TrainerModel({required this.id, required this.fullname});

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    return TrainerModel(
      id: json['id'],
      fullname: json['fullname'] ?? '',
    );
  }
}

class MembershipPlanModel {
  final int id;
  final String name;
  final String? price;

  MembershipPlanModel({required this.id, required this.name, this.price});

  factory MembershipPlanModel.fromJson(Map<String, dynamic> json) {
    return MembershipPlanModel(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price']?.toString(),
    );
  }
}

class TrainerDetailModel {
  final int id;
  final String fullname;
  final String? profilephoto;
  final String email;
  final String phone;
  final String dateofbirth;
  final String speciality;
  final int experience;
  final String shifttiming;
  final String? monthlysalary;
  final String status;

  TrainerDetailModel({
    required this.id,
    required this.fullname,
    this.profilephoto,
    required this.email,
    required this.phone,
    required this.dateofbirth,
    required this.speciality,
    required this.experience,
    required this.shifttiming,
    this.monthlysalary,
    required this.status,
  });

  factory TrainerDetailModel.fromJson(Map<String, dynamic> json) {
    return TrainerDetailModel(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      profilephoto: json['profilephoto'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dateofbirth: json['dateofbirth'] ?? '',
      speciality: json['speciality'] ?? '',
      experience: json['experience'] ?? 0,
      shifttiming: json['shifttiming'] ?? '',
      monthlysalary: json['monthlysalary']?.toString(),
      status: json['status'] ?? 'active',
    );
  }
}

class MemberDetailModel {
  final int id;
  final String fullname;
  final String? profilephoto;
  final String email;
  final String phone;
  final String dateofbirth;
  final String gender;
  final String emergency;
  final String address;
  final double height;
  final double weight;
  final String bloodgroup;
  final String fitnessgoal;
  final int assignedtrainer;
  final int membershipplanid;
  final String joiningdate;
  final String status;
  final TrainerDetailModel? trainer;
  final MembershipPlanModel? membershipPlan;

  MemberDetailModel({
    required this.id,
    required this.fullname,
    this.profilephoto,
    required this.email,
    required this.phone,
    required this.dateofbirth,
    required this.gender,
    required this.emergency,
    required this.address,
    required this.height,
    required this.weight,
    required this.bloodgroup,
    required this.fitnessgoal,
    required this.assignedtrainer,
    required this.membershipplanid,
    required this.joiningdate,
    required this.status,
    this.trainer,
    this.membershipPlan,
  });

  factory MemberDetailModel.fromJson(Map<String, dynamic> json) {
    return MemberDetailModel(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      profilephoto: json['profilephoto'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      dateofbirth: json['dateofbirth'] ?? '',
      gender: json['gender'] ?? '',
      emergency: json['emergency'] ?? '',
      address: json['address'] ?? '',
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      bloodgroup: json['bloodgroup'] ?? '',
      fitnessgoal: json['fitnessgoal'] ?? '',
      assignedtrainer: json['assignedtrainer'] ?? 0,
      membershipplanid: json['membershipplanid'] ?? 0,
      joiningdate: json['joiningdate'] ?? '',
      status: json['status'] ?? 'active',
      trainer: json['Trainer'] != null ? TrainerDetailModel.fromJson(json['Trainer']) : null,
      membershipPlan: json['MembershipPlan'] != null ? MembershipPlanModel.fromJson(json['MembershipPlan']) : null,
    );
  }
}

class MemberUpdateRequest {
  final String fullname;
  final String email;
  final String phone;
  final String dateofbirth;
  final String gender;
  final String emergency;
  final String address;
  final String height;
  final String weight;
  final String bloodgroup;
  final String fitnessgoal;
  final String assignedtrainer;
  final String membershipplanid;
  final String joiningdate;
  final String status;
  final File? profilephoto;

  MemberUpdateRequest({
    required this.fullname,
    required this.email,
    required this.phone,
    required this.dateofbirth,
    required this.gender,
    required this.emergency,
    required this.address,
    required this.height,
    required this.weight,
    required this.bloodgroup,
    required this.fitnessgoal,
    required this.assignedtrainer,
    required this.membershipplanid,
    required this.joiningdate,
    required this.status,
    this.profilephoto,
  });
}

class TrainerUpdateRequest {
  final String fullname;
  final String email;
  final String phone;
  final String dateofbirth;
  final String speciality;
  final String experience;
  final String shifttiming;
  final String monthlysalary;
  final String status;
  final File? profilephoto;

  TrainerUpdateRequest({
    required this.fullname,
    required this.email,
    required this.phone,
    required this.dateofbirth,
    required this.speciality,
    required this.experience,
    required this.shifttiming,
    required this.monthlysalary,
    required this.status,
    this.profilephoto,
  });
}

class MemberSearchModel {
  final int id;
  final String fullname;
  final String? profilephoto;
  final String status;

  MemberSearchModel({
    required this.id,
    required this.fullname,
    this.profilephoto,
    required this.status,
  });

  factory MemberSearchModel.fromJson(Map<String, dynamic> json) {
    return MemberSearchModel(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      profilephoto: json['profilephoto'],
      status: json['status'] ?? 'active',
    );
  }
}

