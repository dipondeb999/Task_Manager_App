class Urls {
  static const String _baseUrl = 'http://152.42.163.176:2006/api/v1';

  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String addNewTask = '$_baseUrl/createTask';
  static const String newTaskList = '$_baseUrl/listTaskByStatus/New';
  static const String completedList = '$_baseUrl/listTaskByStatus/Completed';
  static const String cancelledList = '$_baseUrl/listTaskByStatus/Cancelled';
  static const String progressList = '$_baseUrl/listTaskByStatus/Progress';
  static String recoverVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
}