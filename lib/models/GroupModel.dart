class GroupModel {
  int? id;
  String? grouptypeId;
  String? groupName;
  String? status;
  String? description;
  String? image;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  GroupModel(
      {this.id,
        this.grouptypeId,
        this.groupName,
        this.status,
        this.description,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grouptypeId = json['grouptype_id'];
    groupName = json['group_name'];
    status = json['status'];
    description = json['description'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
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
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  String? userId;
  String? groupId;

  Pivot({this.userId, this.groupId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['group_id'] = groupId;
    return data;
  }
}
