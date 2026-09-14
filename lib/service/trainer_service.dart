import 'package:dio/dio.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/models/workout_model.dart';
import 'package:gym/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainerService extends ApiService {
  Future<AuthResponse> registerTrainer(TrainerRegisterRequest request) async {
    try {
      // Create FormData because backend uses multer/multipart for photo upload
      final formData = FormData.fromMap(request.toJson());

      final response = await dio.post(
        '/trainers/add',
        data: formData,
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AuthResponse> loginTrainer(LoginRequest request) async {
    try {
      final response = await dio.post(
        '/trainers/login',
        data: request.toJson(),
      );
      
      final authResponse = AuthResponse.fromJson(response.data);
      
      // Save token to SharedPreferences
      if (authResponse.token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', authResponse.token!);
        if (authResponse.user != null) {
          await prefs.setString('role', authResponse.user!.role);
          await prefs.setInt('userId', authResponse.user!.id);
        }
      }
      
      return authResponse;
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }
  
  Future<List<TrainerModel>> getTrainers() async {
    try {
      final response = await dio.post('/trainers/get');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => TrainerModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<TrainerDetailModel> getTrainerById(int id) async {
    try {
      final response = await dio.post('/trainers/get/$id');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return TrainerDetailModel.fromJson(response.data['data']);
      }
      throw 'Failed to fetch trainer profile';
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<MemberDetailModel>> getCustomers() async {
    try {
      final response = await dio.post('/members/get');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => MemberDetailModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<MemberSearchModel>> searchCustomers(String query) async {
    try {
      final response = await dio.post('/members/search', data: {'query': query});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => MemberSearchModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<MemberDetailModel> getCustomerById(int id) async {
    try {
      final response = await dio.post('/members/get/$id');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return MemberDetailModel.fromJson(response.data['data']);
      }
      throw 'Failed to fetch customer profile';
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AuthResponse> updateTrainer(int id, TrainerUpdateRequest request) async {
    try {
      final Map<String, dynamic> data = {
        'fullname': request.fullname,
        'email': request.email,
        'phone': request.phone,
        'dateofbirth': request.dateofbirth,
        'speciality': request.speciality,
        'experience': request.experience,
        'shifttiming': request.shifttiming,
        'monthlysalary': request.monthlysalary,
        'status': request.status,
      };

      if (request.profilephoto != null) {
        data['profilephoto'] = await MultipartFile.fromFile(
          request.profilephoto!.path,
          filename: request.profilephoto!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(data);
      final response = await dio.post('/trainers/edit/$id', data: formData);
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('userId');
  }

  Future<List<WorkoutModel>> getWorkouts() async {
    try {
      final response = await dio.post('/workouts/get');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => WorkoutModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<WorkoutSearchModel>> searchWorkouts(String query) async {
    try {
      final response = await dio.post('/workouts/search', data: {'query': query});
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => WorkoutSearchModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> addWorkout(WorkoutRequestModel request) async {
    try {
      await dio.post('/workouts/add', data: request.toJson());
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> editWorkout(int id, WorkoutRequestModel request) async {
    try {
      await dio.post('/workouts/edit/$id', data: request.toJson());
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteWorkout(int id) async {
    try {
      await dio.post('/workouts/delete/$id');
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> assignWorkouts(AssignWorkoutRequestModel request) async {
    try {
      await dio.post('/workout-assignments/assign', data: request.toJson());
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AssignmentResponseModel> getTrainerAssignments(int trainerId, {int page = 1, int limit = 30, required String month}) async {
    try {
      final response = await dio.post(
        '/workout-assignments/trainer/$trainerId',
        data: {
          'page': page,
          'limit': limit,
          'month': month,
        },
      );
      if (response.statusCode == 200) {
        return AssignmentResponseModel.fromJson(response.data);
      }
      throw 'Failed to fetch assignments';
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> editTrainerAssignment(int id, {required String scheduledDate, String? notes}) async {
    try {
      await dio.post(
        '/workout-assignments/edit/$id',
        data: {
          'scheduledDate': scheduledDate,
          'notes': notes,
        },
      );
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteTrainerAssignment(int id) async {
    try {
      await dio.post('/workout-assignments/delete/$id');
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
