import 'category.dart';

class Genre {
  final int maTheLoai;
  final String tenTheLoai;
  final String? moTa;
  final bool trangThai;
  final List<Category> danhMuc;

  Genre({
    required this.maTheLoai,
    required this.tenTheLoai,
    this.moTa,
    required this.trangThai,
    required this.danhMuc,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    List<Category> categories = [];
    if (json['danhMuc'] != null && json['danhMuc']['\$values'] != null) {
      categories = (json['danhMuc']['\$values'] as List)
          .map((item) => Category.fromJson(item))
          .toList();
    }

    return Genre(
      maTheLoai: json['maTheLoai'] as int,
      tenTheLoai: json['tenTheLoai'] as String,
      moTa: json['moTa'] as String?,
      trangThai: json['trangThai'] as bool,
      danhMuc: categories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maTheLoai': maTheLoai,
      'tenTheLoai': tenTheLoai,
      'moTa': moTa,
      'trangThai': trangThai,
    };
  }
} 