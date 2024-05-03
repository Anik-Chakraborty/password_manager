class PasswordModel {
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
  Category? category;
  Group? group;

  PasswordModel(
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
        this.updatedAt,
        this.category,
        this.group});

  PasswordModel.fromJson(Map<String, dynamic> json) {
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
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    group = json['group'] != null ? Group.fromJson(json['group']) : null;
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
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (group != null) {
      data['group'] = group!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? userId;
  String? categoryName;
  String? createdAt;
  String? updatedAt;

  Category(
      {this.id,
        this.userId,
        this.categoryName,
        this.createdAt,
        this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryName = json['category_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['category_name'] = categoryName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Group {
  int? id;
  String? grouptypeId;
  String? groupName;
  String? status;
  String? description;
  String? image;
  String? createdAt;
  String? updatedAt;

  Group(
      {this.id,
        this.grouptypeId,
        this.groupName,
        this.status,
        this.description,
        this.image,
        this.createdAt,
        this.updatedAt});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grouptypeId = json['grouptype_id'];
    groupName = json['group_name'];
    status = json['status'];
    description = json['description'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['grouptype_id'] = grouptypeId;
    data['group_name'] = groupName;
    data['status'] = status;
    data['description'] = description;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
