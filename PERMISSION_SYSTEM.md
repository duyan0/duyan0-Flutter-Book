# Permission System for Bookstore App

## Roles
- **Customer**: Chỉ xem và quản lý thông tin, đơn hàng của chính mình.
- **Admin**: Toàn quyền truy cập, quản lý tất cả dữ liệu (sản phẩm, đơn hàng, người dùng, v.v.).

## Access Control
- **Order History**: Khách hàng chỉ xem được đơn hàng của mình. Admin xem được tất cả đơn hàng.
- **Admin Pages**: Chỉ admin mới truy cập được các trang quản trị (quản lý sách, đơn hàng, người dùng, v.v.).
- **Customer Pages**: Cả khách hàng và admin đều có thể truy cập, nhưng dữ liệu hiển thị phù hợp với vai trò.

## Implementation
- Sử dụng `UserSessionService` để lưu thông tin người dùng đăng nhập và vai trò (`role`).
- Các service (ví dụ: `OrderService`) kiểm tra vai trò trước khi trả về dữ liệu.
- Các route quản trị được bảo vệ bởi `AdminGuard`.

## Security Notes
- Không hiển thị hoặc cho phép thao tác với dữ liệu không thuộc quyền của người dùng.
- Kiểm tra phân quyền cả ở UI và service/backend.
- Đảm bảo thông tin nhạy cảm (ví dụ: ID sản phẩm, thông tin người dùng khác) không bị lộ cho khách hàng.

## Testing
- Đã có test cho AuthService, OrderService đảm bảo phân quyền hoạt động đúng. 