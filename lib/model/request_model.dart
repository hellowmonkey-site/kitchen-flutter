class RequestModel<T> {
  final int status;
  final String message;
  final T data;

  RequestModel(
      {required this.status, required this.message, required this.data});
}
