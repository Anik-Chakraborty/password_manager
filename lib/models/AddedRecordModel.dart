class AddedRecordModel {
  bool? success;
  String? message;
  int? total;
  List<AddedRecord>? data;

  AddedRecordModel({this.success, this.message, this.total, this.data});

  AddedRecordModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <AddedRecord>[];
      json['data'].forEach((v) {
        data!.add(AddedRecord.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['total'] = total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddedRecord {
  int? id;
  String? userId;
  String? categoryId;
  String? groupId;
  String? title;
  String? passwordType;
  String? description;
  String? encryptPassword;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  AddedRecord(
      {this.id,
        this.userId,
        this.categoryId,
        this.groupId,
        this.title,
        this.passwordType,
        this.description,
        this.encryptPassword,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  AddedRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    groupId = json['group_id'];
    title = json['title'];
    passwordType = json['password_type'];
    description = json['description'];
    encryptPassword = json['encrypt_password'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['category_id'] = categoryId;
    data['group_id'] = groupId;
    data['title'] = title;
    data['password_type'] = passwordType;
    data['description'] = description;
    data['encrypt_password'] = encryptPassword;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
