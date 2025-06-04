import 'package:flutter/material.dart';
import 'package:bookstore/services/user_service.dart';
import 'package:bookstore/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookstore App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const UserScreen(),
    );
  }
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ApiService apiService = ApiService();
  List<User>? users;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final fetchedUsers = await apiService.getAllUsers();
      setState(() {
        isLoading = false;
        users = fetchedUsers;
        if (fetchedUsers == null) {
          errorMessage = 'Không thể tải danh sách người dùng';
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Lỗi: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách người dùng')),
      body: Center(
        child:
            isLoading
                ? const CircularProgressIndicator()
                : errorMessage.isNotEmpty
                ? Text(errorMessage)
                : users != null && users!.isNotEmpty
                ? ListView.builder(
                  itemCount: users!.length,
                  itemBuilder: (context, index) {
                    final user = users![index];
                    return ListTile(
                      title: Text(user.tenKH ?? 'Không có tên'),

                      subtitle: Text(user.email ?? 'Không có email'),
                      leading: Text(user.iDkh?.toString() ?? 'không có id '),
                    );
                  },
                )
                : const Text('Không tìm thấy người dùng'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
