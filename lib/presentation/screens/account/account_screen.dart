import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_track/data/models/user_model.dart';
import 'package:moto_track/data/repositories/profile_repo.dart';
import 'package:moto_track/services/auth_service.dart';

class AccountScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AccountScreen({Key? key, this.onBack}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen> {
  ProfileModel? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  Future<void> getProfileData() async {
    final data = await fetchProfileData();
    setState(() {
      profile = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localProfile = profile;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFF3D34C),
                    padding: const EdgeInsets.only(top: 24, bottom: 32),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              (localProfile?.image?.isNotEmpty ?? false)
                                  ? NetworkImage(localProfile!.image!)
                                  : const AssetImage('assets/images/avatar.png')
                                      as ImageProvider,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          
                              profile?.email!=null ? '${profile?.email}'
                              : 'Email',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('auth_token');
                        AuthService.token = null;
                        context.go('/login');
                      },
                      child: const Text(
                        'Выйти из аккаунта',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Перейти на сайт',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
