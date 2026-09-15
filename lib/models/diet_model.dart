import 'package:gym/models/auth_models.dart';
import 'package:gym/models/workout_model.dart';

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

class DietLibraryModel {
  final int id;
  final String session;
  final String foodName;
  final bool isQuantity;
  final bool isGrams;
  final int? quantity;
  final int? grams;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? trainerId;

  DietLibraryModel({
    required this.id,
    required this.session,
    required this.foodName,
    required this.isQuantity,
    required this.isGrams,
    this.quantity,
    this.grams,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.trainerId,
  });

  factory DietLibraryModel.fromJson(Map<String, dynamic> json) {
    return DietLibraryModel(
      id: json['id'],
      session: json['session'] ?? '',
      foodName: json['foodName'] ?? '',
      isQuantity: json['isQuantity'] ?? false,
      isGrams: json['isGrams'] ?? false,
      quantity: json['quantity'],
      grams: json['grams'],
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      trainerId: json['trainerId'],
    );
  }
}

class DietListResponseModel {
  final Map<String, dynamic> counts;
  final List<DietLibraryModel> records;

  DietListResponseModel({
    required this.counts,
    required this.records,
  });

  factory DietListResponseModel.fromJson(Map<String, dynamic> json) {
    return DietListResponseModel(
      counts: json['counts'] ?? {},
      records: (json['records'] as List?)
              ?.map((item) => DietLibraryModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class DietAssignmentItem {
  final int dietId;
  final String scheduledDate;
  final String? status;
  final String? notes;

  DietAssignmentItem({
    required this.dietId,
    required this.scheduledDate,
    this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'dietId': dietId,
      'scheduledDate': scheduledDate,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
    };
  }
}

class AssignDietRequestModel {
  final int memberId;
  final int trainerId;
  final List<DietAssignmentItem> diets;

  AssignDietRequestModel({
    required this.memberId,
    required this.trainerId,
    required this.diets,
  });

  Map<String, dynamic> toJson() {
    return {
      'memberid': memberId, // Based on API requirements
      'trainerId': trainerId,
      'diets': diets.map((d) => d.toJson()).toList(),
    };
  }
}

class DietAssignmentModel {
  final int id;
  final int memberId;
  final int dietId;
  final int trainerId;
  final String scheduledDate;
  final String status;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final MemberSearchModel? member;
  final DietLibraryModel? diet;

  DietAssignmentModel({
    required this.id,
    required this.memberId,
    required this.dietId,
    required this.trainerId,
    required this.scheduledDate,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.member,
    this.diet,
  });

  factory DietAssignmentModel.fromJson(Map<String, dynamic> json) {
    return DietAssignmentModel(
      id: json['id'] ?? 0,
      memberId: json['memberId'] ?? 0,
      dietId: json['dietId'] ?? 0,
      trainerId: json['trainerId'] ?? 0,
      scheduledDate: json['scheduledDate'] ?? '',
      status: json['status'] ?? 'pending',
      notes: json['notes'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      member: json['Member'] != null ? MemberSearchModel.fromJson(json['Member']) : null,
      diet: json['Diet'] != null ? DietLibraryModel.fromJson(json['Diet']) : null,
    );
  }
}

class DietAssignmentResponseModel {
  final List<DietAssignmentModel> data;
  final PaginationModel pagination;

  DietAssignmentResponseModel({
    required this.data,
    required this.pagination,
  });

  factory DietAssignmentResponseModel.fromJson(Map<String, dynamic> json) {
    return DietAssignmentResponseModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => DietAssignmentModel.fromJson(e))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'])
          : PaginationModel(
              currentPage: 1,
              perPage: 30,
              totalRecords: 0,
              totalPages: 1,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
    );
  }
}
