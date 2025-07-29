// ignore_for_file: file_names

class DanhGiaSanPham {
  final int? id;
  final int? sanPhamID;
  final int? khachHangID;
  final String? noiDung;
  final int? diem;
  final String? ngayDanhGia;

  DanhGiaSanPham({
    this.id,
    this.sanPhamID,
    this.khachHangID,
    this.noiDung,
    this.diem,
    this.ngayDanhGia,
  });

  factory DanhGiaSanPham.fromJson(Map<String, dynamic> json) {
    return DanhGiaSanPham(
      id: json['id'],
      sanPhamID: json['sanPhamID'],
      khachHangID: json['khachHangID'],
      noiDung: json['noiDung'],
      diem: json['diem'],
      ngayDanhGia: json['ngayDanhGia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sanPhamID': sanPhamID,
      'khachHangID': khachHangID,
      'noiDung': noiDung,
      'diem': diem,
      'ngayDanhGia': ngayDanhGia,
    };
  }
}

class KhachHang {
  int? maKhachHang;
  String? tenKhachHang;
  String? email;
  String? taiKhoan;
  String? soDienThoai;
  String? diaChi;
  DateTime? ngaySinh;
  String? gioiTinh;
  DateTime? ngayTao;
  bool? trangThai;
  String? matKhau; // Chỉ dùng cho đăng ký/đăng nhập

  KhachHang({
    this.maKhachHang,
    this.tenKhachHang,
    this.email,
    this.taiKhoan,
    this.soDienThoai,
    this.diaChi,
    this.ngaySinh,
    this.gioiTinh,
    this.ngayTao,
    this.trangThai,
    this.matKhau,
  });

  // Getter aliases for backward compatibility with tests
  int? get khachHangId => maKhachHang;
  String? get soDT => soDienThoai;

  factory KhachHang.fromJson(Map<String, dynamic> json) {
    return KhachHang(
      maKhachHang: json['maKhachHang'],
      tenKhachHang: json['tenKhachHang'] ?? '',
      email: json['email'] ?? '',
      taiKhoan: json['taiKhoan'] ?? '',
      soDienThoai: json['soDienThoai'] ?? '',
      diaChi: json['diaChi'],
      ngaySinh:
          json['ngaySinh'] != null ? DateTime.tryParse(json['ngaySinh']) : null,
      gioiTinh: json['gioiTinh'],
      ngayTao:
          json['ngayTao'] != null ? DateTime.tryParse(json['ngayTao']) : null,
      trangThai: json['trangThai'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maKhachHang': maKhachHang,
      'tenKhachHang': tenKhachHang,
      'email': email,
      'taiKhoan': taiKhoan,
      'soDienThoai': soDienThoai,
      'diaChi': diaChi,
      'ngaySinh': ngaySinh?.toIso8601String(),
      'gioiTinh': gioiTinh,
      'ngayTao': ngayTao?.toIso8601String(),
      'trangThai': trangThai,
      if (matKhau != null) 'matKhau': matKhau,
    };
  }

  // Tạo object cho đăng ký
  Map<String, dynamic> toRegisterJson() {
    return {
      'tenKhachHang': tenKhachHang,
      'email': email,
      'taiKhoan': taiKhoan,
      'matKhau': matKhau,
      'soDienThoai': soDienThoai,
      'diaChi': diaChi,
      'ngaySinh': ngaySinh?.toIso8601String(),
      'gioiTinh': gioiTinh,
    };
  }

  // Tạo object cho đăng nhập
  Map<String, dynamic> toLoginJson() {
    return {'taiKhoan': taiKhoan, 'matKhau': matKhau};
  }
}
