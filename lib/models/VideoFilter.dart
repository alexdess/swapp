import 'package:cloud_firestore/cloud_firestore.dart';

class VideoFilter {
  String id;
  String requestorId;
  bool isDiscussion;
  bool isEntertainment;
  bool isCultural;
  bool isParty;
  bool isLanguage;
  String timestamp;

  VideoFilter(
      this.id,
      this.requestorId,
      this.isDiscussion,
      this.isEntertainment,
      this.isCultural,
      this.isParty,
      this.isLanguage,
      this.timestamp);

  VideoFilter.fromMap(Map snapshot, String id)
      : id = id ?? '',
        requestorId = snapshot["requestorId"] ?? '',
        timestamp = snapshot["timestamp"]?.toString() ?? '',
        isDiscussion = snapshot["isDiscussion"] ?? true,
        isEntertainment = snapshot["isEntertainment"] ?? true,
        isCultural = snapshot["isCultural"] ?? true,
        isParty = snapshot["isParty"] ?? true,
        isLanguage = snapshot["isLanguage"] ?? true;

  Map<String, dynamic> toJson() {
    return {
      "requestorId": requestorId,
      "timestamp": FieldValue.serverTimestamp(),
      "isDiscussion": isDiscussion,
      "isEntertainment": isEntertainment,
      "isCultural": isCultural,
      "isParty": isParty,
      "isLanguage": isLanguage,
    };
  }
}
