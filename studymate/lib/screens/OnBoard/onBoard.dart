import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studymate/screens/Authenticated/authenticated.dart';
import 'package:studymate/screens/OnBoard/size_config.dart';

class OnboardModel {
  String img;
  String text;
  String desc;
  OnboardModel({required this.img, required this.text, required this.desc});
}

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int _currentPage = 0;
  late PageController _pageController;
  List<OnboardModel> content = <OnboardModel>[
    OnboardModel(
      img: 'assets/boarding/img-1.png',
      text: "Need help?",
      desc: "Use MutualTutor to find a tutor to support you",
    ),
    OnboardModel(
      img: 'assets/boarding/img-2.png',
      text: "Give Help",
      desc: "Help someone pass exams that you've succesfully pass!",
    ),
    OnboardModel(
      img: 'assets/boarding/img-3.png',
      text: "Recive Help",
      desc: "In exchange, recive help passing yours!",
    ),
  ];

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  _storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color.fromARGB(255, 233, 64, 87),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              flex: 9,
              child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (value) =>
                      setState(() => _currentPage = value),
                  itemCount: content.length,
                  itemBuilder: (context, i) {
                    return Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Image.asset(content[i].img),
                            ),
                            SizedBox(
                              height: (height >= 840) ? 60 : 30,
                            ),
                            Text(
                              content[i].text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Crimson Pro",
                                  fontWeight: FontWeight.w600,
                                  fontSize: (width <= 550) ? 30 : 35,
                                  color: Color.fromARGB(255, 233, 64, 87)),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              content[i].desc,
                              style: TextStyle(
                                fontFamily: "Crimson Pro",
                                fontWeight: FontWeight.w300,
                                fontSize: (width <= 550) ? 17 : 25,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ));
                  }),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      content.length,
                      (int index) => _buildDots(
                        index: index,
                      ),
                    ),
                  ),
                  _currentPage + 1 == content.length
                      ? Padding(
                          padding: const EdgeInsets.all(30),
                          child: ElevatedButton(
                            onPressed: () {
                              _storeOnboardInfo();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Authenticated()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 233, 64, 87),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: (width <= 550)
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20)
                                  : EdgeInsets.symmetric(
                                      horizontal: width * 0.2, vertical: 25),
                            ),
                            child: const Text(
                              "START",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _pageController.jumpToPage(2);
                                },
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: (width <= 550) ? 13 : 17,
                                  ),
                                ),
                                child: const Text(
                                  "SKIP",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 233, 64, 87),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 0,
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 25),
                                ),
                                child: const Text(
                                  "NEXT",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )
          ],
        )));
  }
}
