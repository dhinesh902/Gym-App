class Food {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final MealSession recommendedSession;
  final String servingSize;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String description;
  final String benefits;
  final bool isActive;

  Food({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.recommendedSession,
    required this.servingSize,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.description,
    required this.benefits,
    this.isActive = true,
  });
}

enum MealSession { morning, afternoon, evening, night }

extension MealSessionExtension on MealSession {
  String get displayName {
    switch (this) {
      case MealSession.morning:
        return 'Morning';
      case MealSession.afternoon:
        return 'Afternoon';
      case MealSession.evening:
        return 'Evening';
      case MealSession.night:
        return 'Night';
    }
  }
}

class DietPlanItem {
  final Food food;
  final String quantity;
  final String time;

  DietPlanItem({
    required this.food,
    required this.quantity,
    required this.time,
  });
}

class DietPlan {
  final String id;
  final String customerId;
  final String customerName;
  final String customerImageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final Map<MealSession, List<DietPlanItem>> meals;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final String waterIntake;
  final String trainerNotes;
  final String status; // Active, Upcoming, Completed, Paused

  DietPlan({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerImageUrl,
    required this.startDate,
    required this.endDate,
    required this.meals,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.waterIntake,
    required this.trainerNotes,
    required this.status,
  });
}
