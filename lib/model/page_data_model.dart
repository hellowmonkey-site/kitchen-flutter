class PageDataModel<T> {
  final int pageCount;
  final int count;
  final int pageSize;
  final int page;
  final List<T> data;

  PageDataModel(
      {required this.pageCount,
      required this.count,
      required this.pageSize,
      required this.page,
      required this.data});

  PageDataModel.fromJson(Map<String, dynamic> json)
      : this(
            count: json['count'],
            pageCount: json['pageCount'],
            pageSize: json['pageSize'],
            page: json['page'],
            data: json['data']);
}
