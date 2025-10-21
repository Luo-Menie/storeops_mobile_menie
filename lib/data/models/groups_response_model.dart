

class GroupsResponseModel {
  final String groupId;
  final String group;

  GroupsResponseModel({required this.groupId, required this.group});

  factory GroupsResponseModel.fromJson(Map<String, dynamic> json) {
    return GroupsResponseModel(
      groupId: json["groupId"],
      group: json["groupName"],
    );
  }
}