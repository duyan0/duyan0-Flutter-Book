// ignore_for_file: file_names

class User {
  int? maKhachHang;
  String? tenKhachHang;
  String? soDienThoai;
  String? email;
  String? taiKhoan;
  String? diaChi;
  String? ngaySinh;
  String? gioiTinh;
  String? ngayTao;
  bool? trangThai;

  User({
    this.maKhachHang,
    this.tenKhachHang,
    this.soDienThoai,
    this.email,
    this.taiKhoan,
    this.diaChi,
    this.ngaySinh,
    this.gioiTinh,
    this.ngayTao,
    this.trangThai,
  });

  // Getter aliases for backward compatibility
  String? get tenKH => tenKhachHang;
  String? get tKhoan => taiKhoan;
  int? get iDkh => maKhachHang;
  String get trangThaiTaiKhoan => (trangThai == true) ? 'Active' : 'Inactive';

  User.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing User from JSON: $json');
      maKhachHang = json['maKhachHang'];
      tenKhachHang = json['tenKhachHang'];
      soDienThoai = json['soDienThoai'];
      email = json['email'];
      taiKhoan = json['taiKhoan'];
      diaChi = json['diaChi'];
      ngaySinh = json['ngaySinh'];
      gioiTinh = json['gioiTinh'];
      ngayTao = json['ngayTao'];
      trangThai = json['trangThai'];
      print('User parsed successfully: $tenKhachHang');
    } catch (e) {
      print('Error parsing User: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maKhachHang'] = maKhachHang;
    data['tenKhachHang'] = tenKhachHang;
    data['soDienThoai'] = soDienThoai;
    data['email'] = email;
    data['taiKhoan'] = taiKhoan;
    data['diaChi'] = diaChi;
    data['ngaySinh'] = ngaySinh;
    data['gioiTinh'] = gioiTinh;
    data['ngayTao'] = ngayTao;
    data['trangThai'] = trangThai;
    return data;
  }

  @override
  String toString() {
    return 'User{maKhachHang: $maKhachHang, tenKhachHang: $tenKhachHang, email: $email, taiKhoan: $taiKhoan}';
  }
}
