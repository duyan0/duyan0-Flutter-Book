class User {
  int? iDkh;
  String? tenKH;
  String? soDT;
  String? email;
  String? tKhoan;
  String? mKhau;
  String? diaChi;
  String? trangThaiTaiKhoan;
  String? otp;
  String? otpExpiry;
  String? ngayTao;
  String? ngayCapNhat;

  User({
    this.iDkh,
    this.tenKH,
    this.soDT,
    this.email,
    this.tKhoan,
    this.mKhau,
    this.diaChi,
    this.trangThaiTaiKhoan,
    this.otp,
    this.otpExpiry,
    this.ngayTao,
    this.ngayCapNhat,
  });

  User.fromJson(Map<String, dynamic> json) {
    iDkh = json['iDkh'];
    tenKH = json['tenKH'];
    soDT = json['soDT'];
    email = json['email'];
    tKhoan = json['tKhoan'];
    mKhau = json['mKhau'];
    diaChi = json['diaChi'];
    trangThaiTaiKhoan = json['trangThaiTaiKhoan'];
    otp = json['otp'];
    otpExpiry = json['otpExpiry'];
    ngayTao = json['ngayTao'];
    ngayCapNhat = json['ngayCapNhat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iDkh'] = iDkh;
    data['tenKH'] = tenKH;
    data['soDT'] = soDT;
    data['email'] = email;
    data['tKhoan'] = tKhoan;
    data['mKhau'] = mKhau;
    data['diaChi'] = diaChi;
    data['trangThaiTaiKhoan'] = trangThaiTaiKhoan;
    data['otp'] = otp;
    data['otpExpiry'] = otpExpiry;
    data['ngayTao'] = ngayTao;
    data['ngayCapNhat'] = ngayCapNhat;
    return data;
  }
}
