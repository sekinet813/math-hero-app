import '../models/reward_ticket.dart';

/// 親用プリセットリスト
final List<RewardTicket> parentRewardTickets = [
  RewardTicket(
    id: 'massage',
    name: 'マッサージ',
    description: 'お子さまからマッサージをしてもらえる',
    iconPath: 'assets/icons/massage.png',
    target: 'parent',
  ),
  RewardTicket(
    id: 'shoulder',
    name: '肩たたき',
    description: 'お子さまから肩たたきをしてもらえる',
    iconPath: 'assets/icons/shoulder.png',
    target: 'parent',
  ),
  RewardTicket(
    id: 'housework',
    name: '家事お手伝い',
    description: 'お子さまが家事を手伝ってくれる',
    iconPath: 'assets/icons/housework.png',
    target: 'parent',
  ),
  RewardTicket(
    id: 'dishwashing',
    name: '洗い物お手伝い',
    description: 'お子さまが洗い物を手伝ってくれる',
    iconPath: 'assets/icons/dishwashing.png',
    target: 'parent',
  ),
];

/// 子ども用プリセットリスト
final List<RewardTicket> childRewardTickets = [
  RewardTicket(
    id: 'snack',
    name: 'おやつ',
    description: 'おやつをもらえる',
    iconPath: 'assets/icons/snack.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'game_time',
    name: 'ゲームえんちょう',
    description: 'ゲームをえんちょうできる',
    iconPath: 'assets/icons/game_time.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'night',
    name: 'よふかし',
    description: 'ちょっとよふかしできる',
    iconPath: 'assets/icons/night.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'piggyback',
    name: 'おんぶ・だっこ',
    description: 'おんぶやだっこをしてもらえる',
    iconPath: 'assets/icons/piggyback.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'outing',
    name: 'おでかけ',
    description: 'すきなところにおでかけできる',
    iconPath: 'assets/icons/outing.png',
    target: 'child',
  ),
  RewardTicket(
    id: 'reading',
    name: 'よみきかせ',
    description: 'えほんをよんでもらえる',
    iconPath: 'assets/icons/reading.png',
    target: 'child',
  ),
];
