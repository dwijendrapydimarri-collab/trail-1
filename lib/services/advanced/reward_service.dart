import 'package:app/models/advanced/gamification_models.dart';

class RewardService {
  List<ShopItem> getAvailableItems() {
    return [
      ShopItem(
        id: 'shop_1',
        title: 'Golden Frame',
        description: 'A glowing golden frame for your leaderboard avatar.',
        costEggs: 500,
        category: 'Cosmetic',
      ),
      ShopItem(
        id: 'shop_2',
        title: 'Cyberpunk Theme',
        description:
            'Unlocks the neon pink and cyan color palette for the app.',
        costEggs: 1200,
        category: 'Theme',
      ),
      ShopItem(
        id: 'shop_3',
        title: 'Smolov Jr. Routine',
        description:
            'Unlocks the famous 4-week heavy squat progression program.',
        costEggs: 800,
        category: 'Program',
      ),
      ShopItem(
        id: 'shop_4',
        title: 'Streak Freeze',
        description:
            'Automatically preserves your streak if you miss a workout within 72 hours.',
        costEggs: 300,
        category: 'Utility',
      ),
    ];
  }
}
