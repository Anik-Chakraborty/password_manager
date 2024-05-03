import 'package:password_manager/models/OccupationModel.dart';

class UserProfileModel {
  int? id;
  String? role;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? isAuthenticator;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  Userinfo? userinfo;

  OccupationModel? occupationList;

  UserProfileModel(
      {this.id,
        this.role,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.isAuthenticator,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.userinfo,
      this.occupationList});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    isAuthenticator = json['is_authenticator'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userinfo = json['userinfo'] != null
        ? Userinfo.fromJson(json['userinfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['is_authenticator'] = isAuthenticator;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (userinfo != null) {
      data['userinfo'] = userinfo!.toJson();
    }
    return data;
  }
}

class Userinfo {
  int? id;
  String? userId;
  String? occupationId;
  String? gender;
  String? phone;
  String? address;
  String? zipCode;
  String? nidPassportNo;
  String? facebookProfileUrl;
  String? twitterProfileUrl;
  String? linkedinProfileUrl;
  String? instagramProfileUrl;
  String? createdAt;
  String? updatedAt;

  Userinfo(
      {this.id,
        this.userId,
        this.occupationId,
        this.gender,
        this.phone,
        this.address,
        this.zipCode,
        this.nidPassportNo,
        this.facebookProfileUrl,
        this.twitterProfileUrl,
        this.linkedinProfileUrl,
        this.instagramProfileUrl,
        this.createdAt,
        this.updatedAt});

  Userinfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    occupationId = json['occupation_id'];
    gender = json['gender'];
    phone = json['phone'];
    address = json['address'];
    zipCode = json['zip_code'];
    nidPassportNo = json['nid_passport_no'];
    facebookProfileUrl = json['facebook_profile_url'];
    twitterProfileUrl = json['twitter_profile_url'];
    linkedinProfileUrl = json['linkedin_profile_url'];
    instagramProfileUrl = json['instagram_profile_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['occupation_id'] = occupationId;
    data['gender'] = gender;
    data['phone'] = phone;
    data['address'] = address;
    data['zip_code'] = zipCode;
    data['nid_passport_no'] = nidPassportNo;
    data['facebook_profile_url'] = facebookProfileUrl;
    data['twitter_profile_url'] = twitterProfileUrl;
    data['linkedin_profile_url'] = linkedinProfileUrl;
    data['instagram_profile_url'] = instagramProfileUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
