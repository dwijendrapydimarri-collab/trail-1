class Quest {
  final String id;
  final String title;
  final String description;
  final String type; // 'Daily', 'Weekly'
  final double targetValue;
  final double currentValue;
  final int rewardEggs;
  final bool isCompleted;
  final DateTime expiresAt;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    this.currentValue = 0.0,
    required this.rewardEggs,
    this.isCompleted = false,
    required this.expiresAt,
  });

  Quest copyWith({double? currentValue, bool? isCompleted}) {
    return Quest(
      id: id,
      title: title,
      description: description,
      type: type,
      targetValue: targetValue,
      currentValue: currentValue ?? this.currentValue,
      rewardEggs: rewardEggs,
      isCompleted: isCompleted ?? this.isCompleted,
      expiresAt: expiresAt,
    );
  }
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
  });
}

class ShopItem {
  final String id;
  final String title;
  final String description;
  final int costEggs;
  final String category; // 'Badge', 'Theme', 'Program'
  final bool isUnlocked;

  ShopItem({
    required this.id,
    required this.title,
    required this.description,
    required this.costEggs,
    required this.category,
    this.isUnlocked = false,
  });
}
