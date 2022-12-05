import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../../constants/colors.dart';
import '../../constants/image_strings.dart';
import '../../constants/texts_string.dart';
import '../models/onboarding_model.dart';
import '../views/onboarding_screen/onboarding_page_widget.dart';

class OnBoardingController extends GetxController{
  
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
          image: moOnboardImg1,
          title: moOnboardTitle1,
          bgColor: moPrimaryColor,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
          image: moOnboardImg2,
          title: moOnboardTitle2,
          bgColor: moSecondarColor,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
          image: moOnboardImg3,
          title: moOnboardTitle3,
          bgColor: moAccentColor,
      ),
    ),
  ];

  onPageChangedCallback(int activePageIndex) => currentPage.value = activePageIndex;
  skip() => controller.jumpToPage(page: 2);
  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
}

}