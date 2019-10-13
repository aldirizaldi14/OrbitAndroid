class ResponseModel {
  ResponseModel._privateConstructor();
  static final ResponseModel instance = ResponseModel._privateConstructor();

  String status;
  String success;
  String message;

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'success': success,
      'message': message,
    };
  }

  ResponseModel.fromDb(Map<String, dynamic> map)
      : status = map['status'],
        success = map['success'],
        message = map['message'];
}