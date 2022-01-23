import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wecode_2021/src/data_models/general_user.dart';
import 'package:wecode_2021/src/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key, required this.generalUser}) : super(key: key);
  final GeneralUser? generalUser;

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.generalUser == null
        ? Container()
        : Scaffold(
            appBar: AppBar(title: Text('the User'), actions: [
              IconButton(
                  onPressed: () {
                    Provider.of<AuthService>(context, listen: false).logOut();
                  },
                  icon: Icon(Icons.logout)),
            ]),
            body: widget.generalUser == null
                ? Container(child: Text('You are not authorised'))
                : Column(
                    children: [
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
                                child: Stack(
                                  children: [
                                    widget.generalUser!.imgUrl == null
                                        ? Container()
                                        : Container(
                                            color: Colors.grey,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  widget.generalUser!.imgUrl!,
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
                                  text:
                                      widget.generalUser!.title ?? 'no title'),
                              widget.generalUser!.location == null
                                  ? Container()
                                  : _textContainer(
                                      text:
                                          widget.generalUser!.location ?? 'ds'),
                              const Padding(
                                child: Divider(
                                  color: Colors.black87,
                                  height: 25,
                                ),
                                padding: EdgeInsets.only(right: 50, left: 50),
                              ),
                              _textContainer(text: 'bio'),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, left: 8.0),
                                child: _textContainer(
                                    text: widget.generalUser!.bio ?? 'no bio',
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
                                      url: widget.generalUser!.stackOverflow!,
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
                  ));
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
