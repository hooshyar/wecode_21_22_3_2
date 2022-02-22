import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';
import 'package:wecode_2021/src/jobs_screen/jobs_board_screen.dart';
import 'package:wecode_2021/src/profile_screens/create_profile_screen.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:wecode_2021/src/services/firestore_service.dart';
import 'package:wecode_2021/src/student_screen/student_linktree_view.dart';
import 'package:wecode_2021/src/student_screen/news_student_screen.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_job_view.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_list_of_news.dart';
import 'package:wecode_2021/src/trainers_screen/trainers_list_of_students.dart';

class TrainersScreenView extends StatefulWidget {
  TrainersScreenView({Key? key, required this.generalUser}) : super(key: key);
  final GeneralUser? generalUser;
  @override
  State<TrainersScreenView> createState() => _TrainersScreenViewState();
}

class _TrainersScreenViewState extends State<TrainersScreenView> {
  final _advancedDrawerController = AdvancedDrawerController();
  @override
  int _currentIndex = 0;

  List<Widget> _screens = [
    TrainersListOfStudentsScreen(),
    TrainersListOfJobsScreen(),
    TrainersListOfNewsScreen()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.generalUser == 1
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
                                  imageUrl: widget.generalUser!.imgUrl ??
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
                          widget.generalUser!.name != null
                              ? widget.generalUser!.name.toString()
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
                        title: Text(widget.generalUser!.title ?? 'no Title'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_city),
                        title:
                            Text(widget.generalUser!.location ?? 'no Location'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: const Text('Bio'),
                        subtitle: Text(widget.generalUser!.bio ?? 'no bio'),
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
                      widget.generalUser!.github != null
                          ? ListTile(
                              onTap: () async {
                                await canLaunch(widget.generalUser!.github!) ==
                                        true
                                    ? launch(widget.generalUser!.github!)
                                    : debugPrint('can not launch');
                              },
                              leading: const Icon(FontAwesomeIcons.github),
                              title: const Text('GitHub'),
                            )
                          : Container(),
                      widget.generalUser!.stackOverflow != null
                          ? ListTile(
                              onTap: () async {
                                await canLaunch(widget
                                            .generalUser!.stackOverflow!) ==
                                        true
                                    ? launch(widget.generalUser!.stackOverflow!)
                                    : debugPrint('can not launch');
                              },
                              leading:
                                  const Icon(FontAwesomeIcons.stackOverflow),
                              title: const Text('stackOverflow'),
                            )
                          : Container(),
                      widget.generalUser!.linkedIn != null
                          ? ListTile(
                              onTap: () async {
                                await canLaunch(
                                            widget.generalUser!.linkedIn!) ==
                                        true
                                    ? launch(widget.generalUser!.linkedIn!)
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
                      widget.generalUser!.uid != null
                          ? ListTile(
                              onTap: () {},
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
                title: Text('Trainer Dashboard'),
                centerTitle: true,
                backgroundColor: Colors.deepPurple[400],
                leading: IconButton(
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: _handleMenuButtonPressed,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: _advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          value.visible
                              ? Icons.person_outline
                              : FontAwesomeIcons.chalkboardTeacher,
                          key: ValueKey<bool>(value.visible),
                        ),
                      );
                    },
                  ),
                ),
              ),
              body: _screens[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                onTap: (value) => setState(() {
                  _currentIndex = value;
                }),
                currentIndex: _currentIndex,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Students',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.cases),
                    label: 'Jobs',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.event),
                    label: 'News',
                  ),
                ],
              ),
            ),
          );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
