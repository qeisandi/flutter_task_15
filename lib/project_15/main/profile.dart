import 'package:flutter/material.dart';
import 'package:futsal_56/project_15/login_regis/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  static const String id = "/profile";

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? nameUser;
  String? usernameUser;

  @override
  void initState() {
    super.initState();
    ambilDataUser();
  }

  Future<void> ambilDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameUser = prefs.getString('name') ?? 'No Name';
      usernameUser = prefs.getString('username') ?? 'username';
    });
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void editProfileDialog() {
    final nameController = TextEditingController(text: nameUser);
    final usernameController = TextEditingController(text: usernameUser);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('name', nameController.text);
                await prefs.setString('username', usernameController.text);
                if (!mounted) return;
                setState(() {
                  nameUser = nameController.text;
                  usernameUser = usernameController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: Color(0xff2F5249),
        title: Text('Profil Saya', style: TextStyle(color: Colors.white)),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/image/cat.jpg'),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.edit, size: 18, color: Colors.teal),
                    onPressed: editProfileDialog,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            nameUser ?? 'Loading...',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontFamily: 'Gilroy',
            ),
          ),
          SizedBox(height: 4),
          Text(
            '@${usernameUser ?? 'username'}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 30),
          Divider(thickness: 0.8),
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.black),
            title: Text('Edit Profile'),
            onTap: editProfileDialog,
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: Text('Konfirmasi'),
                      content: Text('Apakah Anda yakin ingin logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            logoutUser();
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Gilroy',
                            ),
                          ),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
