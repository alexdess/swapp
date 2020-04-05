import 'package:Swapp/services/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/VideoFilter.dart';

class GetVideoChannelService {
  static Firestore firestore = new Firestore();
  static BaseAuth auth = new Auth();

  static Future<String> GetChannelId(VideoFilter askVideofilter) async {
    String channelId;
    var videoList = await firestore.collection("Videos").snapshots().first;
    if (videoList != null && videoList.documents.length > 0) {
      var documents = videoList.documents;
      for (var value in documents) {
        var videoFilter = VideoFilter.fromMap(value.data, value.documentID);
        if ((videoFilter.isCultural && askVideofilter.isCultural) ||
            (videoFilter.isDiscussion && askVideofilter.isDiscussion) ||
            (videoFilter.isEntertainment && askVideofilter.isEntertainment) ||
            (videoFilter.isLanguage && askVideofilter.isLanguage) ||
            (videoFilter.isParty && askVideofilter.isParty)) {
          channelId = videoFilter.id;
        }
      }
    }
    if (channelId != null) {
      await firestore.collection("Videos").document(channelId).delete();
      return channelId;
    } else {
      var added =
          await firestore.collection("Videos").add(askVideofilter.toJson());
      return added.documentID;
    }
  }

  static void ClearId() {
    var currentUserId = auth.getCurrentUserId();
    firestore
        .collection("Videos")
        .where("requestorId", isEqualTo: currentUserId)
        .snapshots()
        .first
        .then((value) => removeIfExiste(value));
  }

  static removeIfExiste(QuerySnapshot value) {
    if (value != null && value.documents.length > 0) {
      var doc = value.documents[0];
      firestore.collection("Videos").document(doc.documentID).delete();
    }
  }
}
