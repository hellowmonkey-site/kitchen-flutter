class PageDataModel<T> {
  final int pageCount;
  final int count;
  final int pageSize;
  final int page;
  final List<T> data;

  PageDataModel(
      {this.pageCount = 0,
      this.count = 0,
      this.pageSize = 10,
      this.page = 1,
      required this.data});

  PageDataModel.fromJson(Map<String, dynamic> json)
      : this(
            count: json['count'],
            pageCount: json['pageCount'],
            pageSize: json['pageSize'],
            page: json['page'],
            data: json['data']);
}
