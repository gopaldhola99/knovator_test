import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        onFinish: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(Constants.isNewUser, false);
          Navigator.pushReplacementNamed(context, '/home');
        },
        finishButtonText: "Get Started",
        finishButtonStyle: const FinishButtonStyle(
          backgroundColor: Colors.black87,
        ),
        background: [
          Container(),
          Container(),
          Container(),
          Container(),
          Container(),
        ],
        totalPage: 5,
        speed: 1.8,
        pageBodies: const [
          CustomPageWidget(
            title: 'Welcome to the App!',
            description:
                "It is just a demo app created for the assesment purpose",
            lottiePath: Constants.hiLottie,
          ),
          CustomPageWidget(
            title: 'What to expect in the app?',
            description:
                "It will show the list of posts on homescreen (fetched from jsonplaceholder API) \nOn tap of each posts it will redirect you to the post detail screen",
            lottiePath: Constants.whatLottie,
          ),
          CustomPageWidget(
            title: 'What features integrated?',
            // lottieHeight: 25.h,
            description:
                "Initially all posts will have light yellow background color. On Tap of any post, it will mark it as read and will change it's color to white \n\n Each Posts will show specific timer at the right hand side. Initital Second of the timer will be set randomly between 10-60 seconds. When the post tile is not visible, the timer for that particular post will be paused.",
            lottiePath: Constants.featuresLottie,
          ),
          CustomPageWidget(
            title: 'Locally managed',
            // lottieHeight: 25.h,
            description:
                'Once the data is fetched from the internet, it will automatically saved locally. When user tries to restart the app again without internet, it will show the locally stored data. When connected to the internet, locally stored data will get updated.',
            lottiePath: Constants.localLottie,
          ),
          CustomPageWidget(
            title: 'Start Now!',
            // lottieHeight: 25.h,
            description: 'Lets dive into the app check its functionality.',
            lottiePath: Constants.startLottie,
          ),
        ],
      ),
    );
  }
}

class CustomPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String lottiePath;
  final double? lottieHeight;
  const CustomPageWidget({
    required this.title,
    required this.description,
    required this.lottiePath,
    this.lottieHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset(
            lottiePath,
            width: MediaQuery.of(context).size.width,
            height: lottieHeight ?? MediaQuery.of(context).size.height * 0.5,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
