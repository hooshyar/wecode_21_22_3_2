import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsStudentScreen extends StatefulWidget {
  const NewsStudentScreen({Key? key, required this.generalUser})
      : super(key: key);
  final GeneralUser? generalUser;

  @override
  State<NewsStudentScreen> createState() => _NewsStudentScreenState();
}

class _NewsStudentScreenState extends State<NewsStudentScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
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

        : Scaffold(
            appBar: AppBar(
              title: Text('Student News'),
              centerTitle: true,
              backgroundColor: Colors.deepPurple[400],

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
                  title: Text('Student News'),
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
                            value.visible ? Icons.person_outline : Icons.person,
                            key: ValueKey<bool>(value.visible),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                body: widget.generalUser == null
                    ? Container(child: Text('You are not authorised'))
                    : Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              // color: Colors.red,

                      ElevatedButton(
                          onPressed: () =>
                              Provider.of<AuthService>(context, listen: false)
                                  .logOut(),
                          child: Text('data')),
                      Expanded(
                        flex: 2,
                        child: Container(
                          // color: Colors.red,
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            height: 120,
                            width: 120,
                            // color: Colors.black26,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),

                              child: Container(
                                margin: EdgeInsets.only(top: 20, bottom: 20),
                                height: 120,
                                width: 120,
                                // color: Colors.black26,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        widget.generalUser!.imgUrl == null
                                            ? Container()
                                            : Container(
                                                color: Colors.grey,
                                                child: CachedNetworkImage(
                                                  imageUrl: widget
                                                      .generalUser!.imgUrl!,
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ), //remeber that we have the cachednetworkimage package
                                              ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          left: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'Looking for a job',
                                              textAlign: TextAlign.center,
                                            ),
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              // color: Colors.green,
                              child: Column(
                                children: [
                                  _textContainer(
                                      text: widget.generalUser!.name ?? 'da'),
                                  _textContainer(
                                      text: widget.generalUser!.title ??
                                          'no title'),
                                  widget.generalUser!.location == null
                                      ? Container()
                                      : _textContainer(
                                          text: widget.generalUser!.location ??
                                              'ds'),
                                  const Padding(
                                    child: Divider(
                                      color: Colors.black87,
                                      height: 25,
                                    ),
                                    padding:
                                        EdgeInsets.only(right: 50, left: 50),
                                  ),
                                  _textContainer(text: 'bio'),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8.0),
                                    child: _textContainer(
                                        text:
                                            widget.generalUser!.bio ?? 'no bio',
                                        isJustify: true),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              child: ListView(
                                children: [
                                  widget.generalUser!.linkedIn == null
                                      ? Container()
                                      : _urlLauncherButton(
                                          url: widget.generalUser!.linkedIn!,
                                          label: 'LinkedIn'),
                                  widget.generalUser!.stackOverflow == null
                                      ? Container()
                                      : _urlLauncherButton(
                                          url: widget
                                              .generalUser!.stackOverflow!,
                                          label: 'stackOverflow'),
                                  widget.generalUser!.github == null
                                      ? Container()
                                      : _urlLauncherButton(
                                          url: widget.generalUser!.github!,
                                          label: 'github'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: SafeArea(
                                child: Row(
                                  children: [
                                    _generalBoxButton(
                                        icon: Icon(
                                      FontAwesomeIcons.linkedin,
                                      color: Colors.blue,
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
          );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  Widget _textContainer({required String text, bool? isJustify}) {
    return Container(
      child: isJustify != true
          ? SelectableText(text)
          : SelectableText(
              text,
              textAlign: TextAlign.justify,
            ),
      padding: EdgeInsets.all(2),
    );
  }

// _general button will recive a label  and checks if it can launch a url
  Widget _urlLauncherButton(
      {required String url,
      required String label,
      Color? color = Colors.blue}) {
    return Container(
        height: 50,
        margin: EdgeInsets.only(right: 25, left: 25, bottom: 10),
        child: ElevatedButton(
          child: Text(label),
          style: ElevatedButton.styleFrom(primary: color),
          onPressed: () async {
            await canLaunch(url) == true
                ? launch(url)
                : debugPrint('can not launch');
          },
        ));
  }

// _general button will recive a label  and it can be used to do something onpressed
  Widget _generalButton(
      {required String label, Color? color = Colors.blue, onPressed}) {
    return Container(
        height: 50,
        margin: EdgeInsets.only(right: 25, left: 25, bottom: 10),
        child: ElevatedButton(
          child: Text(label),
          style: ElevatedButton.styleFrom(primary: color),
          onPressed: onPressed,
        ));
  }

  Widget _generalBoxButton(
      {required Icon icon, Color? color = Colors.blue, onPressed}) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(right: 25, left: 25, bottom: 10),
      child: IconButton(
        icon: icon,
        iconSize: 42,
        color: color,
        onPressed: onPressed,
      ),
    );
  }
}
