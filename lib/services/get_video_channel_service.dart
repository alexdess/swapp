import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/VideoFilter.dart';

 class GetVideoChannelService{
  static Firestore firestore = new Firestore();

   static Future<String> GetChannelId(VideoFilter filter) async {
    var query = firestore.collection("Videos")
    .where("isCultural", isEqualTo: true)
        .where("isDiscussion", isEqualTo: true)
        .where("isEntertainment", isEqualTo: true)
        .where("isLanguage", isEqualTo: true)
        .where("isParty", isEqualTo: true);

    var snapshot = await query.snapshots().first;
    if(snapshot != null && snapshot.documents.length > 0){
      var doc = snapshot.documents[0];
      var video = VideoFilter.fromMap(doc.data, doc.documentID);
      await firestore.collection("Videos").document(video.id).delete();
      return video.id;

    }
    else{
      var added = await firestore.collection("Videos").add(filter.toJson());
      return added.documentID;
    }

  }

  static void ClearId(String currentUserId) {
    firestore.collection("Videos")
        .where("requestorId", isEqualTo: currentUserId)
        .snapshots()
        .first
        .then((value) => removeIfExiste(value));

  }

  static removeIfExiste(QuerySnapshot value) {
     if(value != null && value.documents.length > 0){
       var doc = value.documents[0];
       firestore.collection("Videos").document(doc.documentID).delete();
     }
  }
}