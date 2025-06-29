import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// ホーム画面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('マスヒーロー'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.kSpacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppConstants.kSpacing32),
            // タイトル
            Text(
              'マスヒーロー',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.kSpacing8),
            Text(
              '楽しく計算を学ぼう！',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.kSpacing32),
            // ゲーム開始ボタン
            FilledButton(
              onPressed: () {
                // TODO: ゲーム画面に遷移
              },
              child: const Text('ゲームを始める'),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 履歴ボタン
            OutlinedButton(
              onPressed: () {
                // TODO: 履歴画面に遷移
              },
              child: const Text('履歴を見る'),
            ),
            const SizedBox(height: AppConstants.kSpacing16),
            // 設定ボタン
            OutlinedButton(
              onPressed: () {
                // TODO: 設定画面に遷移
              },
              child: const Text('設定'),
            ),
          ],
        ),
      ),
    );
  }
}
