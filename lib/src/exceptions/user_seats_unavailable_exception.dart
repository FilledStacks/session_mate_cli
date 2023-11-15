class UserSeatsUnavailableException implements Exception {
  final String message;

  UserSeatsUnavailableException(this.message);

  @override
  String toString() {
    return message;
  }
}
