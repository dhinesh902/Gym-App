import 'package:gym/models/auth_models.dart';

class WorkoutModel {
  final int id;
  final String title;
  final String targetmuscle;
  final String difficultlevel;
  final String duration;
  final String description;
  final String createdAt;
  final String updatedAt;
  final int? trainerId;

  WorkoutModel({
    required this.id,
    required this.title,
    required this.targetmuscle,
    required this.difficultlevel,
    required this.duration,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.trainerId,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      targetmuscle: json['targetmuscle'] ?? '',
      difficultlevel: json['difficultlevel'] ?? '',
      duration: json['duration']?.toString() ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      trainerId: json['trainerId'],
    );
  }
}

class WorkoutRequestModel {
  final String title;
  final String targetmuscle;
  final String difficultlevel;
  final String duration;
  final String description;

  WorkoutRequestModel({
    required this.title,
    required this.targetmuscle,
    required this.difficultlevel,
    required this.duration,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'targetmuscle': targetmuscle,
      'difficultlevel': difficultlevel,
      'duration': duration,
      'description': description,
    };
  }
}

class WorkoutAssignmentItem {
  final int workoutId;
  final String scheduledDate;
  final String? status;
  final String? notes;

  WorkoutAssignmentItem({
    required this.workoutId,
    required this.scheduledDate,
    this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'workoutId': workoutId,
      'scheduledDate': scheduledDate,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
    };
  }
}

class AssignWorkoutRequestModel {
  final int memberId;
  final int trainerId;
  final List<WorkoutAssignmentItem> workouts;

  AssignWorkoutRequestModel({
    required this.memberId,
    required this.trainerId,
    required this.workouts,
  });

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'trainerId': trainerId,
      'workouts': workouts.map((w) => w.toJson()).toList(),
    };
  }
}

class WorkoutSearchModel {
  final int id;
  final String title;
  final String targetmuscle;
  final String difficultlevel;
  final String duration;
  final String description;
  final int? trainerId;

  WorkoutSearchModel({
    required this.id,
    required this.title,
    required this.targetmuscle,
    required this.difficultlevel,
    required this.duration,
    required this.description,
    this.trainerId,
  });

  factory WorkoutSearchModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSearchModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      targetmuscle: json['targetmuscle'] ?? '',
      difficultlevel: json['difficultlevel'] ?? '',
      duration: json['duration']?.toString() ?? '',
      description: json['description'] ?? '',
      trainerId: json['trainerId'],
    );
  }
}

class PaginationModel {
  final int currentPage;
  final int perPage;
  final int totalRecords;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.totalRecords,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['currentPage'] ?? 1,
      perPage: json['perPage'] ?? 30,
      totalRecords: json['totalRecords'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

class WorkoutAssignmentModel {
  final int id;
  final int memberId;
  final int trainerId;
  final int workoutId;
  final String scheduledDate;
  final String status;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final MemberSearchModel? member;
  final WorkoutSearchModel? workout;

  WorkoutAssignmentModel({
    required this.id,
    required this.memberId,
    required this.trainerId,
    required this.workoutId,
    required this.scheduledDate,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.member,
    this.workout,
  });

  factory WorkoutAssignmentModel.fromJson(Map<String, dynamic> json) {
    return WorkoutAssignmentModel(
      id: json['id'] ?? 0,
      memberId: json['memberId'] ?? 0,
      trainerId: json['trainerId'] ?? 0,
      workoutId: json['workoutId'] ?? 0,
      scheduledDate: json['scheduledDate'] ?? '',
      status: json['status'] ?? 'pending',
      notes: json['notes'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      member: json['Member'] != null ? MemberSearchModel.fromJson(json['Member']) : null,
      workout: json['Workout'] != null ? WorkoutSearchModel.fromJson(json['Workout']) : null,
    );
  }
}

class AssignmentResponseModel {
  final List<WorkoutAssignmentModel> data;
  final PaginationModel pagination;

  AssignmentResponseModel({
    required this.data,
    required this.pagination,
  });

  factory AssignmentResponseModel.fromJson(Map<String, dynamic> json) {
    return AssignmentResponseModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => WorkoutAssignmentModel.fromJson(e))
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
