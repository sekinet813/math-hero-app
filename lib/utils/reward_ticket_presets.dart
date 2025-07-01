import '../models/reward_ticket.dart';

/// 親用プリセット券リスト
final List<RewardTicket> parentRewardTickets = [
  RewardTicket(
    id: 'massage',
    name: 'マッサージ券',
    description: 'お子さまからマッサージをしてもらえる券です。',
    iconPath: 'assets/icons/massage.png',
    target: 'parent',
  ),
  RewardTicket(
    id: 'shoulder',
    name: '肩たたき券',
    description: 'お子さまから肩たたきをしてもらえる券です。',
    iconPath: 'assets/icons/shoulder.png',
    target: 'parent',
  ),
  RewardTicket(
    id: 'housework',
    name: '家事お手伝い券',
    description: 'お子さまが家事を手伝ってくれる券です。',
    iconPath: 'assets/icons/housework.png',
    target: 'parent',
  ),
  RewardTicket(
    id: 'dishwashing',
    name: '洗い物お手伝い券',
    description: 'お子さまが洗い物を手伝ってくれる券です。',
    iconPath: 'assets/icons/dishwashing.png',
    target: 'parent',
  ),
];

/// 子ども用プリセット券リスト
final List<RewardTicket> childRewardTickets = [
  RewardTicket(
    id: 'snack',
    name: 'おやつ券',
    description: 'おやつをもらえる券です。',
    iconPath: 'assets/icons/snack.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'game_time',
    name: 'ゲーム時間延長券',
    description: 'ゲームの時間を延長できる券です。',
    iconPath: 'assets/icons/game_time.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'night',
    name: '夜ふかし券',
    description: '今日はちょっと夜ふかしできる券です。',
    iconPath: 'assets/icons/night.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'piggyback',
    name: 'おんぶ券・だっこ券',
    description: 'おんぶやだっこをしてもらえる券です。',
    iconPath: 'assets/icons/piggyback.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'outing',
    name: 'お出かけ券',
    description: '好きな場所にお出かけできる券です。',
    iconPath: 'assets/icons/outing.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'reading',
    name: '読み聞かせ時間券',
    description: '本を読んでもらえる券です。',
    iconPath: 'assets/icons/reading.png',
    target: 'child',
  ),
];
