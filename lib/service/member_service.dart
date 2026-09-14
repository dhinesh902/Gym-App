import 'package:dio/dio.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/models/attendance_model.dart';
import 'package:gym/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberService extends ApiService {
  Future<AuthResponse> registerMember(MemberRegisterRequest request) async {
    try {
      final Map<String, dynamic> data = request.toJson();
      if (request.profilephoto != null) {
        data['profilephoto'] = await MultipartFile.fromFile(
          request.profilephoto!.path,
          filename: request.profilephoto!.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(data);

      final response = await dio.post(
        '/members/add',
        data: formData,
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AuthResponse> loginMember(LoginRequest request) async {
    try {
      final response = await dio.post(
        '/members/login',
        data: request.toJson(),
      );
      
      final authResponse = AuthResponse.fromJson(response.data);
      
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

  Future<MemberDetailModel> getMemberById(int id) async {
    try {
      final response = await dio.post('/members/get/$id');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return MemberDetailModel.fromJson(response.data['data']);
      }
      throw 'Failed to fetch member profile';
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AuthResponse> updateMember(int id, MemberUpdateRequest request) async {
    try {
      final Map<String, dynamic> data = {
        'fullname': request.fullname,
        'email': request.email,
        'phone': request.phone,
        'dateofbirth': request.dateofbirth,
        'gender': request.gender,
        'emergency': request.emergency,
        'address': request.address,
        'height': request.height,
        'weight': request.weight,
        'bloodgroup': request.bloodgroup,
        'fitnessgoal': request.fitnessgoal,
        'assignedtrainer': request.assignedtrainer,
        'membershipplanid': request.membershipplanid,
        'joiningdate': request.joiningdate,
        'status': request.status,
      };

      if (request.profilephoto != null) {
        data['profilephoto'] = await MultipartFile.fromFile(
          request.profilephoto!.path,
          filename: request.profilephoto!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(data);
      final response = await dio.post('/members/edit/$id', data: formData);
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

  Future<void> markAttendance(int memberId, String date, String checkInTime, String checkOutTime) async {
    try {
      final response = await dio.post(
        '/attendance/check-in/add',
        data: {
          'memberId': memberId,
          'date': date,
          'checkInTime': checkInTime,
          'checkOutTime': checkOutTime,
        },
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw 'Failed to mark attendance';
      }
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AttendanceDataModel> getMemberAttendance(int memberId) async {
    try {
      final response = await dio.post('/attendance/member/$memberId');
      if (response.statusCode == 200 && response.data['data'] != null) {
        return AttendanceDataModel.fromJson(response.data['data']);
      }
      throw 'Failed to fetch attendance history';
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
