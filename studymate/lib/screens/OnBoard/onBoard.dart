import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studymate/screens/Authenticated/authenticated.dart';
import 'package:studymate/screens/Login/login.dart';

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

  AnimatedContainer _buildVerticalDots(
      {int? index, required double h, required double w}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color.fromARGB(255, 233, 64, 87),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 0.012 * h,
      curve: Curves.easeIn,
      width: _currentPage == index ? w * 0.05 : w * 0.025,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    if (width >= height) {
      return horizontalView(width, height);
    } else {
      return verticalView(width, height);
    }
  }

  Widget verticalView(double width, double height) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(0.01 * width),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                                child: Image.asset(
                              content[i].img,
                              height: 0.5 * height,
                            )),
                            SizedBox(
                              height: 0.03 * height,
                            ),
                            Text(
                              content[i].text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Crimson Pro",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 0.08 * width,
                                  color: Color.fromARGB(255, 233, 64, 87)),
                            ),
                            SizedBox(height: 0.01 * height),
                            Text(
                              content[i].desc,
                              style: TextStyle(
                                fontFamily: "Crimson Pro",
                                fontWeight: FontWeight.w300,
                                fontSize: 0.03 * width,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 0.02 * height,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      content.length,
                      (int index) =>
                          _buildVerticalDots(index: index, h: height, w: width),
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
                                      builder: (context) => Login()));
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

  AnimatedContainer _buildHorizontalDots(
      {int? index, required double h, required double w}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color.fromARGB(255, 233, 64, 87),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 0.03 * h,
      curve: Curves.easeIn,
      width: _currentPage == index ? w * 0.04 : 0.03 * h,
    );
  }

  Widget horizontalView(double width, double height) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
              flex: 9,
              child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (value) =>
                      setState(() => _currentPage = value),
                  itemCount: content.length,
                  itemBuilder: (context, i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                            child: Padding(
                          padding: EdgeInsets.all(0.1 * height),
                          child: Image.asset(
                            content[i].img,
                            height: 0.7 * height,
                          ),
                        )),
                        Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  content[i].text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Crimson Pro",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 0.05 * width,
                                      color: Color.fromARGB(255, 233, 64, 87)),
                                ),
                                SizedBox(height: 0.01 * height),
                                Text(
                                  content[i].desc,
                                  style: TextStyle(
                                    fontFamily: "Crimson Pro",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 0.02 * width,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 0.03 * height,
                                ),
                              ]),
                        )
                      ],
                    );
                  })),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _currentPage + 1 == content.length
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: 0.1 * height, bottom: 0.1 * height),
                      child: ElevatedButton(
                        onPressed: () {
                          _storeOnboardInfo();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 233, 64, 87),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 0.2 * width),
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
                      padding: EdgeInsets.all(0.06 * width),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              padding:
                                  EdgeInsets.symmetric(horizontal: 0.1 * width),
                            ),
                            child: const Text(
                              "SKIP",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: width - 0.65 * width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                content.length,
                                (int index) => _buildHorizontalDots(
                                    index: index, h: height, w: width),
                              ),
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
                              padding:
                                  EdgeInsets.symmetric(horizontal: 0.1 * width),
                            ),
                            child: const Text(
                              "NEXT",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ])));
  }
}
