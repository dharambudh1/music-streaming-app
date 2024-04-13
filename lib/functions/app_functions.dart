import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";

String lottieJson() {
  final int timeNow = DateTime.now().hour;
  return (timeNow <= 12)
      ? "morning"
      : (timeNow > 12) && (timeNow <= 16)
          ? "afternoon"
          : (timeNow > 16) && (timeNow < 20)
              ? "evening"
              : "evening";
}

QueryDocumentSnapshot<dynamic>? getListItem({
  required QuerySnapshot<dynamic>? snapshotData,
  required int index,
}) {
  return snapshotData?.docs[index];
}

String getId({required QueryDocumentSnapshot<dynamic>? docsData}) {
  return docsData?.id ?? "";
}

Map<String, dynamic> getData({
  required QueryDocumentSnapshot<dynamic>? docsData,
}) {
  return docsData?.data() ?? <String, dynamic>{};
}

String encodeString({required String decodedString}) {
  return utf8.fuse(base64).encode(decodedString);
}

String decodeString({required String encodedString}) {
  return utf8.fuse(base64).decode(encodedString);
}

String formatString(String durationString) {
  final String format = durationString.substring(0, durationString.length - 7);
  return format;
}
