import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intrapair_mobile_apt_test/screens/search.dart';

import '../common/assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map? _country;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: size.height * 0.06,
              ),
              SvgPicture.asset(
                Assets.location,
                width: size.width * 0.3,
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              const Text(
                'Choose Your Country',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Please select your country to help us to give you a better experience',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CupertinoColors.inactiveGray,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              InkWell(
                onTap: () async {
                  final country = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                      fullscreenDialog: true,
                    ),
                  );
                  if (country is Map) {
                    setState(() {
                      _country = country;
                    });
                  }
                },
                child: Ink(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.inactiveGray),
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.inactiveGray.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset:
                            const Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: _country == null
                              ? const Text(
                                  "Select Country",
                                  style: TextStyle(
                                      color: CupertinoColors.inactiveGray),
                                )
                              : Row(
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  _country!['flag']
                                                      .toString()))),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                        child:
                                            Text(_country!['name'].toString()))
                                  ],
                                )),
                      const Icon(
                        Icons.arrow_right_alt_rounded,
                        color: CupertinoColors.inactiveGray,
                      )
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: _country!=null ? null : Border.all(color: CupertinoColors.inactiveGray),
                  borderRadius: BorderRadius.circular(10),
                  color: _country!=null ? Theme.of(context).primaryColor : null,
                ),
                child: Text(
                  "Go ahead",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _country!=null ? Colors.white : CupertinoColors.inactiveGray),
                ),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.google,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    "Continue with another Gmail",
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
