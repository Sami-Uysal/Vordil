import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/user_service.dart';
import 'auth_page.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  late User _user;
  late String _name;
  late String _email;
  late int _level;
  String? _selectedAvatar;
  bool isLoading = true;
  bool isEditing = false;

  final List<String> _avatars = [
    'lib/assets/avatars/avatar1.jpeg',
    'lib/assets/avatars/avatar2.jpeg',
    'lib/assets/avatars/avatar3.jpeg',
    'lib/assets/avatars/avatar4.jpeg',
    'lib/assets/avatars/avatar5.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _name = _user.displayName ?? '';
    _email = _user.email ?? '';
    _level = 1;
    _selectedAvatar = _avatars[0];
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      UserService userService = UserService();
      Map<String, dynamic> userData = await userService.getUserData(_user.uid);

      setState(() {
        _name = userData['name'] ?? _name;
        _email = userData['email'] ?? _email;
        _level = userData['level'] ?? _level;
        _selectedAvatar = userData['avatar'] ?? _selectedAvatar;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Kullanıcı verilerini yüklerken hata oluştu: $e')));
    }
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _user.updateProfile(displayName: _name);
        await _user.updateEmail(_email);

        UserService userService = UserService();
        await userService.updateUserData({
          'userId': _user.uid,
          'name': _name,
          'email': _email,
          'level': _level,
          'avatar': _selectedAvatar,
        });

        setState(() {
          isEditing = false;
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Firebase Auth hatası: ${e.message}')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Veri güncellenirken hata oluştu: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Profili'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : isEditing
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            initialValue: _name,
                            decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lütfen kullanıcı adını giriniz';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _name = value!;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            initialValue: _email,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lütfen email giriniz';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text('Avatar Seç'),
                          const SizedBox(height: 10),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: _avatars.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAvatar = _avatars[index];
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(_avatars[index]),
                                      if (_avatars[index] == _selectedAvatar)
                                        const Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _updateUserData,
                            child: const Text('Kaydet'),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                              });
                            },
                            child: const Text('İptal'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(_selectedAvatar!),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _email,
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Level: $_level',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
      ),
    );
  }
}
