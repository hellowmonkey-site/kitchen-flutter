class RequestModel<T> {
  final int status;
  final String message;
  final T data;

  RequestModel({this.status = 200, this.message = '操作成功', required this.data});
}
