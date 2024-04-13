import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:music_streaming_app/common/common_cached_network_image.dart";
import "package:music_streaming_app/common/common_image_widget.dart";
import "package:music_streaming_app/functions/app_functions.dart";
import "package:music_streaming_app/models/music_model.dart";

void main() {
  // Unit Testing for encodeString function:
  test(
    "Test encodeString function",
    () {
      const String decodedString = "Hello, World!";
      final String encodedString = encodeString(decodedString: decodedString);
      expect(encodedString, isNotEmpty);
      expect(encodedString, isNot(decodedString));
      expect(encodedString, equals("SGVsbG8sIFdvcmxkIQ=="));
    },
  );

  // Unit Testing for decodeString function:
  test(
    "Test decodeString function",
    () {
      const String encodedString = "SGVsbG8sIFdvcmxkIQ==";
      final String decodedString = decodeString(encodedString: encodedString);
      expect(decodedString, isNotEmpty);
      expect(decodedString, isNot(encodedString));
      expect(decodedString, "Hello, World!");
    },
  );

  // Widget Testing for CommonImageWidget
  testWidgets("CommonImageWidget displays correct image", (
    WidgetTester tester,
  ) async {
    final MusicModel musicModel = MusicModel(
      image: "https://example.com/image.jpg",
      name: "Test Song",
      by: "Test Artist",
      link: "https://example.com/song.mp3",
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommonImageWidget(
            id: "1",
            model: musicModel,
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
    expect(find.byType(CommonCachedNetworkImage), findsOneWidget);
  });

  return;
}
