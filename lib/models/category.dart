class Category {
  final int maDanhMuc;
  final String tenDanhMuc;
  final String? moTa;
  final bool trangThai;

  Category({
    required this.maDanhMuc,
    required this.tenDanhMuc,
    this.moTa,
    required this.trangThai,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      maDanhMuc: json['maDanhMuc'] as int,
      tenDanhMuc: json['tenDanhMuc'] as String,
      moTa: json['moTa'] as String?,
      trangThai: json['trangThai'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maDanhMuc': maDanhMuc,
      'tenDanhMuc': tenDanhMuc,
      'moTa': moTa,
      'trangThai': trangThai,
    };
  }
} 