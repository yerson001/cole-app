class ApiConstants {
  static const String baseUrl = '192.168.18.26:3000';
  static const int port = 3000;

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String loginEndPoint = '/auth/login';
  static const String tenantExistEndPoint = '/tenants/exist';
  static const String usersEndPoint = '/users';
}
