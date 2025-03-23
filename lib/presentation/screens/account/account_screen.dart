import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit_demo/data/models/user_model.dart';
import 'package:yandex_mapkit_demo/data/repositories/profile_repo.dart';
import 'package:yandex_mapkit_demo/presentation/navigation/bottom_nav_bar.dart';
import 'package:yandex_mapkit_demo/presentation/screens/auth/login_screen.dart';

class AccountScreen extends StatefulWidget {
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
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      child: profile?.backgroundImage != null &&
                              profile!.backgroundImage!.isNotEmpty
                          ? Image.network(
                              profile!.backgroundImage!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/backgrount_account.png',
                              fit: BoxFit.cover,
                            ),
                      right: 0,
                      left: 0,
                      bottom: MediaQuery.of(context).size.height * 0.52,
                    ),
                    Positioned(
                      top: 20,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFFFFF),
                        ),
                        child: IconButton(
                          splashColor: const Color.fromARGB(255, 0, 0, 0),
                          icon: Icon(Icons.arrow_back,
                              color: const Color.fromARGB(255, 8, 8, 8)),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNavScreen()),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.08,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [

CircleAvatar(
  radius: 40,
  backgroundImage: (localProfile?.image?.isNotEmpty ?? false)
      ? NetworkImage(localProfile!.image!)
      : const AssetImage('assets/images/avatar.png') as ImageProvider,
),

                          SizedBox(height: 8),
                          profile?.name != null && profile!.name!.isNotEmpty &&
                          profile?.surname != null && profile!.surname!.isNotEmpty
                          ?  Text('${profile!.name ?? ''} ${profile!.surname ?? ''}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)) :  Text('Name Surname',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          profile?.status != null && profile!.status!.isNotEmpty ?
                          Text(
                              '${profile?.status}',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)) :
                                  Text(
                              'Свобода – это дорога, которую...\n- двигаемся самими собой.',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.29,
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                              bottom: Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5)
                          ],
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              iconColor: Color(0xFFD4D4D4),
                              leading: ImageIcon(
                                  AssetImage('assets/icons/settings_icon.png')),
                              title: Text('Настройки аккаунта'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {},
                            ),
                            Divider(),
                            ListTile(
                              iconColor: Color(0xFFD4D4D4),
                              leading: ImageIcon(AssetImage(
                                  'assets/icons/mapmarker_icon.png')),
                              title: Text('Мои маршруты'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {},
                            ),
                          ],
                          /*
                  ListTile(
                    leading: Icon(Icons.policy),
                    title: Text('Политика конфиденциальности'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('FAQ'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Выйти из аккаунта'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),*/
                        ),
                      ),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.495,
                        left: MediaQuery.of(context).size.width * 0.02,
                        right: MediaQuery.of(context).size.width * 0.02,
                        child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                  bottom: Radius.circular(16)),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                            ),
                            child: Column(children: [
                              ListTile(
                                iconColor: Color(0xFFD4D4D4),
                                leading: ImageIcon(
                                    AssetImage('assets/icons/key_icon.png')),
                                title: Text('Политика конфиденциальности'),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {},
                              ),
                              Divider(),
                              ListTile(
                                iconColor: Color(0xFFD4D4D4),
                                leading: ImageIcon(
                                    AssetImage('assets/icons/book_icon.png')),
                                title: Text('FAQ'),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {},
                              ),
                              Divider(),
                              ListTile(
                                iconColor: Color(0xFFD4D4D4),
                                leading: ImageIcon(AssetImage(
                                    'assets/icons/account_logout_icon.png')),
                                title: Text('Выйти из аккаунта'),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.remove('auth_token');
                                  Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginScreen()),
                            );

                                },
                              ),
                            ]))),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.77,
                      left: MediaQuery.of(context).size.width * 0,
                      right: MediaQuery.of(context).size.width * 0,
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        margin: EdgeInsets.all(16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF3D34C),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {},
                          child: Text('Перейти на сайт',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
