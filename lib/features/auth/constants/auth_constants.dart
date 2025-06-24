class AuthConstants {
  // base url of our app
  static const String baseUrl = 'https://fleer-management-be.onrender.com';

  // auth points
  static const String loginEndpoint = '/api/auth/login';
  static const String signupEndpoint = '/api/auth/register';
  static const String logoutEndpoint = '/api/auth/logout';

  static String acceptAdminRequest(int id) => '/api/transports/$id/accept';
  static String rejectAdminRequest(int id) => '/api/transports/$id/reject';
  static String completedAdminRequest(int id) => '/api/transports/$id/complete';

  //transport requests
  static const String pushToBackendEndPoint = '/api/vehicle-locations';
  static const String getRequestEndpoint = '/api/transports';

  // Storage Keys
  static const String userKey = 'user_data';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength =
      'Password must be at least 6 characters';
  static const String nameRequired = 'Name is required';
  static const String nameMinLength = 'Name must be at least 2 characters';
}
