enum SubscriptionTier { free, premium }

class SubscriptionStatus {
  final String userId;
  final SubscriptionTier tier;
  final DateTime? expiresAt;

  SubscriptionStatus({
    required this.userId,
    this.tier = SubscriptionTier.free,
    this.expiresAt,
  });

  bool get isPremium =>
      tier == SubscriptionTier.premium &&
      (expiresAt == null || expiresAt!.isAfter(DateTime.now()));
}
