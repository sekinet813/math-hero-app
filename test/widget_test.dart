// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_hero_app/main.dart';
import 'package:math_hero_app/screens/home_screen.dart';

void main() {
  group('MathHeroApp Widget Tests', () {
    testWidgets('アプリが正常に起動する', (WidgetTester tester) async {
      await tester.pumpWidget(const MathHeroApp());

      // ウィジェットが構築されるまで待機
      await tester.pumpAndSettle();

      // AppBarのタイトルとホーム画面のタイトルの両方が存在することを確認
      expect(find.text('マスヒーロー'), findsNWidgets(2));
      expect(find.text('楽しく計算を学ぼう！'), findsOneWidget);
      expect(find.text('ゲームを始める'), findsOneWidget);
      expect(find.text('履歴を見る'), findsOneWidget);
      expect(find.text('設定'), findsOneWidget);
    });

    testWidgets('ホーム画面のボタンが表示される', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // ウィジェットが構築されるまで待機
      await tester.pumpAndSettle();

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsNWidgets(2));
    });

    testWidgets('ホーム画面のテキストが正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // ウィジェットが構築されるまで待機
      await tester.pumpAndSettle();

      // AppBarのタイトルとホーム画面のタイトルの両方が存在することを確認
      expect(find.text('マスヒーロー'), findsNWidgets(2));
      expect(find.text('楽しく計算を学ぼう！'), findsOneWidget);
    });

    testWidgets('AppBarのタイトルが正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // ウィジェットが構築されるまで待機
      await tester.pumpAndSettle();

      // AppBarのタイトルを確認
      expect(find.byType(AppBar), findsOneWidget);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Text>());
      expect((appBar.title as Text).data, 'マスヒーロー');
    });

    testWidgets('ホーム画面のメインタイトルが正しく表示される', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // ウィジェットが構築されるまで待機
      await tester.pumpAndSettle();

      // メインタイトル（headlineLargeスタイル）を確認
      final titleWidgets = find.byWidgetPredicate((widget) {
        return widget is Text &&
            widget.data == 'マスヒーロー' &&
            widget.style?.fontSize == 32.0;
      });
      expect(titleWidgets, findsOneWidget);
    });
  });
}
