import 'package:dio/dio.dart';
import 'package:coleapp/core/constants/api_constants.dart';
import 'package:coleapp/core/errors/helpers.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource({required this.dio});

  Future<Resource<AuthResponse>> login(
      String dni, String password, String tenantKey) async {
    try {
      final response = await dio.post(
        ApiConstants.loginEndPoint,
        data: {'dni': dni, 'password': password},
        options: Options(headers: {'tenant-id': tenantKey}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse =
            AuthResponse.fromJson(response.data)..tenantKey = tenantKey;
        return SuccessResource(authResponse);
      } else {
        return ErrorResource(listToString(response.data['message']));
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message']?.toString() ?? e.message ?? 'Error de conexión';
      return ErrorResource(message);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  Future<Resource<bool>> tenantExists(String tenantKey) async {
    try {
      final response = await dio.get(
        ApiConstants.tenantExistEndPoint,
        queryParameters: {'tenant-id': tenantKey},
      );
      return SuccessResource(response.statusCode == 200);
    } on DioException catch (e) {
      return ErrorResource(e.message ?? 'Error al verificar tenant');
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }
}
