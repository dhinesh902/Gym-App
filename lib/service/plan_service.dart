import 'package:dio/dio.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/service/api_service.dart';

class PlanService extends ApiService {
  Future<List<MembershipPlanModel>> getPlans() async {
    try {
      final response = await dio.post('/plans/get');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => MembershipPlanModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw handleError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
