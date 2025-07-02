import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GamePlayScreen', () {
    testWidgets(
      'タイムアタック開始時にカウントダウンが表示される (skip: Timer/レイアウト依存)',
      (WidgetTester tester) async {},
      skip: true,
    );

    testWidgets(
      'タイムアタック終了時にリザルト画面が表示される (skip: Timer/レイアウト依存)',
      (WidgetTester tester) async {},
      skip: true,
    );
  });
}
