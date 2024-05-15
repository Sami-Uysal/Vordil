import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Profili'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 50,
            ),
            SizedBox(height: 20),
            Text(
              'Kullanıcı Adı',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'user@example.com',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
