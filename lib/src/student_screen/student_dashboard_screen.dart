import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wecode_2021/src/constants/style.dart';
import 'package:wecode_2021/src/jobs_screen/favourite_job_screen.dart';
import 'package:wecode_2021/src/jobs_screen/jobs_board_screen.dart';
import 'package:wecode_2021/src/jobs_screen/list_of_jobs_screen.dart';
import 'package:wecode_2021/src/profile_screens/create_profile_screen.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:wecode_2021/src/student_screen/news_student_screen.dart';
import 'package:wecode_2021/src/student_screen/student_linktree_view.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _currentIndex = 0;
  AdvancedDrawerController _advancedDrawerController =
      AdvancedDrawerController();
  List<Widget> _screens = [
    ListOfJobsScreen(),
    FavouriteJobScreen(),
    //Todo: listOfNewsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    AuthService _auth = Provider.of<AuthService>(context, listen: false);
    return _auth.generalUser == null
        ? Container()
        : AdvancedDrawer(
            backdropColor: Color.fromARGB(255, 0, 0, 0),
            controller: _advancedDrawerController,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 300),
            animateChildDecoration: true,
            rtlOpening: false,
            disabledGestures: false,
            childDecoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 20.0,
                  spreadRadius: 5.0,
                  offset: const Offset(-20.0, 0.0),
                ),
              ],
              borderRadius: BorderRadius.circular(30),
            ),
            drawer: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: ListTileTheme(
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 100.0,
                          height: 100.0,
                          margin: const EdgeInsets.only(
                            left: 20,
                            top: 10,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                  imageUrl: _auth.generalUser!.imgUrl ??
                                      'https://th.bing.com/th/id/OIP._eiPTOPDhIdzMSO6092xdwHaHa?pid=ImgDet&rs=1'),
                            ],
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          top: 3,
                        ),
                        child: Text(
                          _auth.generalUser!.name != null
                              ? _auth.generalUser!.name.toString()
                              : 'no user',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      ListTile(
                        leading: const Icon(Icons.title),
                        title: Text(_auth.generalUser!.title ?? 'no Title'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_city),
                        title:
                            Text(_auth.generalUser!.location ?? 'no Location'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: const Text('Bio'),
                        subtitle: Text(_auth.generalUser!.bio ?? 'no bio'),
                      ),
                      Divider(
                        thickness: 2,
                        indent: 14,
                        height: 3,
                        endIndent: 2,
                        color: Colors.white54,
                      ),
                      Text(
                        'Social Link',
                        style: TextStyle(
                            color: Color.fromARGB(255, 205, 4, 231),
                            fontSize: 16),
                      ),
                      _auth.generalUser!.github != null
                          ? ListTile(
                              onTap: () async {
                                await canLaunch(_auth.generalUser!.github!) ==
                                        true
                                    ? launch(_auth.generalUser!.github!)
                                    : debugPrint('can not launch');
                              },
                              leading: const Icon(FontAwesomeIcons.github),
                              title: const Text('GitHub'),
                            )
                          : Container(),
                      _auth.generalUser!.stackOverflow != null
                          ? ListTile(
                              onTap: () async {
                                await canLaunch(_auth
                                            .generalUser!.stackOverflow!) ==
                                        true
                                    ? launch(_auth.generalUser!.stackOverflow!)
                                    : debugPrint('can not launch');
                              },
                              leading:
                                  const Icon(FontAwesomeIcons.stackOverflow),
                              title: const Text('stackOverflow'),
                            )
                          : Container(),
                      _auth.generalUser!.linkedIn != null
                          ? ListTile(
                              onTap: () async {
                                await canLaunch(_auth.generalUser!.linkedIn!) ==
                                        true
                                    ? launch(_auth.generalUser!.linkedIn!)
                                    : debugPrint('can not launch');
                              },
                              leading: const Icon(FontAwesomeIcons.linkedin),
                              title: const Text('linkedin'),
                            )
                          : Container(),
                      Divider(
                        thickness: 2,
                        indent: 14,
                        height: 3,
                        endIndent: 2,
                        color: Colors.white54,
                      ),
                      _auth.generalUser!.uid != null
                          ? ListTile(
                              onTap: () {
                                _auth.logOut();
                              },
                              leading: const Icon(Icons.logout),
                              title: const Text('Sign out'),
                            )
                          : ListTile(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              leading: const Icon(Icons.login),
                              title: const Text('Sign In'),
                            ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Version 1.0.0',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: _handleMenuButtonPressed,
                    icon: Icon(Icons.person),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Get.isDarkMode
                            ? Get.changeTheme(ThemeData.light())
                            : Get.changeTheme(ThemeData.dark());
                      },
                      icon: Icon(Get.isDarkMode
                          ? Icons.mode_night
                          : Icons.brightness_7),
                      color: Colors.white,
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  onTap: (value) => setState(() {
                    _currentIndex = value;
                  }),
                  currentIndex: _currentIndex,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list),
                      label: 'List',
                      backgroundColor: Colors.red,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'Fav',
                      backgroundColor: Colors.green,
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.event),
                    //   label: 'News',
                    //   backgroundColor: Colors.green,
                    // ),
                  ],
                ),
                body: _screens[_currentIndex]),
          );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
