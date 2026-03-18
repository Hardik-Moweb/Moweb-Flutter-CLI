// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Size screenSize = const Size(360, 690);
double defaultScreenWidth = 750.0;
double defaultScreenHeight = 1334.0;
double screensWidth = defaultScreenWidth;
double screensHeight = defaultScreenHeight;

class s {
  /*Padding & Margin Constants*/

  static double s0 = 0;
  static double s0_5 = 0.5;
  static double s1 = 1.0;
  static double s1_5 = 1.5;
  static double s2 = 2.0;
  static double s3 = 3.0;
  static double s4 = 4.0;
  static double s5 = 5.0;
  static double s6 = 6.0;
  static double s7 = 7.0;
  static double s8 = 8.0;
  static double s9 = 9.0;
  static double s10 = 10.0;
  static double s11 = 11.0;
  static double s12 = 12.0;
  static double s13 = 13.0;
  static double s14 = 14.0;
  static double s15 = 15.0;
  static double s16 = 16.0;
  static double s17 = 17.0;
  static double s18 = 18.0;
  static double s19 = 19.0;
  static double s20 = 20.0;
  static double s21 = 21.0;
  static double s22 = 22.0;
  static double s23 = 23.0;
  static double s24 = 24.0;
  static double s25 = 25.0;
  static double s26 = 26.0;
  static double s28 = 28.0;
  static double s30 = 30.0;
  static double s32 = 32.0;
  static double s35 = 35.0;
  static double s36 = 36.0;
  static double s38 = 38.0;
  static double s40 = 40.0;
  static double s44 = 44.0;
  static double s45 = 45.0;
  static double s47 = 47.0;
  static double s50 = 50.0;
  static double s55 = 55.0;
  static double s48 = 48.0;
  static double s56 = 56.0;
  static double s60 = 60.0;
  static double s64 = 64.0;
  static double s70 = 70.0;
  static double s72 = 72.0;
  static double s80 = 80.0;
  static double s85 = 85.0;
  static double s88 = 88.0;
  static double s90 = 90.0;
  static double s100 = 100.0;
  static double s105 = 105.0;
  static double s110 = 110.0;
  static double s120 = 120.0;
  static double s128 = 128.0;
  static double s130 = 130.0;
  static double s138 = 138.0;
  static double s140 = 140.0;
  static double s150 = 150.0;
  static double s160 = 160.0;
  static double s164 = 164.0;
  static double s180 = 180.0;
  static double s200 = 200.0;
  static double s205 = 205.0;
  static double s210 = 210.0;
  static double s220 = 220.0;
  static double s240 = 240.0;
  static double s250 = 250.0;
  static double s260 = 260.0;
  static double s275 = 275.0;
  static double s280 = 280.0;
  static double s290 = 290.0;
  static double s300 = 300.0;
  static double s310 = 310.0;
  static double s320 = 320.0;
  static double s330 = 330.0;
  static double s340 = 340.0;
  static double s350 = 350.0;
  static double s360 = 360.0;
  static double s380 = 380.0;
  static double s328 = 328.0;
  static double s400 = 400.0;
  static double s420 = 420.0;
  static double s430 = 430.0;
  static double s450 = 450.0;
  static double s470 = 470.0;
  static double s490 = 490.0;
  static double s500 = 500.0;
  static double s520 = 520.0;
  static double s530 = 530.0;
  static double s550 = 550.0;
  static double s600 = 600.0;
  static double s965 = 965.0;
  static double s1000 = 1000.0;

  /*Screen s dependent Constants*/

  static double screenWidthButton = screensWidth - s64;
  static double screenWidthHalf = screensWidth / 2;
  static double screenWidthThird = screensWidth / 3;
  static double screenWidthFourth = screensWidth / 4;
  static double screenWidthFifth = screensWidth / 5;
  static double screenWidthSixth = screensWidth / 6;
  static double screenWidthTenth = screensWidth / 10;

  /*Image Dimensions*/

  static double defaultIconSize = 80.0;
  static double defaultImageHeight = 120.0;
  static double snackBarHeight = 50.0;
  static double texIconSize = 30.0;

  /*Default Height&Width*/
  static double defaultIndicatorHeight = 5.0;
  static double defaultIndicatorWidth = screenWidthFourth;

  /*EdgeInsets*/
  static EdgeInsets spacingAllDefault = EdgeInsets.all(s8);
  static EdgeInsets spacingAllSmall = EdgeInsets.all(s12);

  static void setDefaultSize(context) {
    screenSize = MediaQuery.of(context).size;
    screensWidth = screenSize.width;
    screensHeight = screenSize.height;

    s24 = 20.0;
    s32 = 30.0;
    s44 = 40.0;
    s56 = 50.0;

    screenWidthHalf = screensWidth / 2;
    screenWidthThird = screensWidth / 3;
    screenWidthFourth = screensWidth / 4;
    screenWidthFifth = screensWidth / 5;
    screenWidthSixth = screensWidth / 6;
    screenWidthTenth = screensWidth / 10;

    defaultIconSize = 80.0;
    defaultImageHeight = 120.0;
    snackBarHeight = 50.0;
    texIconSize = 30.0;

    defaultIndicatorHeight = 5.0;
    defaultIndicatorWidth = screenWidthFourth;

    spacingAllDefault = EdgeInsets.all(s8);
    spacingAllSmall = EdgeInsets.all(s12);

    FontSize.setDefaultFontSize();
  }

  static void setScreenAwareConstant(context) {
//    ScreenUtil = ScreenUtil(
//      width: defaultScreenWidth,
//      height: defaultScreenHeight,
//      allowFontScaling: true,
//    )..init(context);
//     ScreenUtil.init(context, designSize:Size(defaultScreenWidth, defaultScreenWidth), allowFontScaling: true,orientation: Orientation.portrait);
    // ScreenUtil.init(
    //     BoxConstraints(
    //         maxWidth: MediaQuery.of(context).size.width,
    //         maxHeight: MediaQuery.of(context).size.height),
    //     designSize: Size(MediaQuery.of(context).size.width,
    //         MediaQuery.of(context).size.height),
    //     orientation: Orientation.portrait);
    FontSize.setScreenAwareFontSize();

    /*Padding & Margin Constants*/

    s0 = ScreenUtil().setWidth(0);
    s0_5 = ScreenUtil().setWidth(0.5);
    s1 = ScreenUtil().setWidth(1.0);
    s1_5 = ScreenUtil().setWidth(1.5);
    s3 = ScreenUtil().setWidth(3.0);
    s2 = ScreenUtil().setWidth(2.0);
    s4 = ScreenUtil().setWidth(4.0);
    s5 = ScreenUtil().setWidth(5.0);
    s6 = ScreenUtil().setWidth(6.0);
    s7 = ScreenUtil().setWidth(7.0);
    s8 = ScreenUtil().setWidth(8.0);
    s9 = ScreenUtil().setWidth(9.0);
    s10 = ScreenUtil().setWidth(10.0);
    s11 = ScreenUtil().setWidth(11.0);
    s12 = ScreenUtil().setWidth(12.0);
    s13 = ScreenUtil().setWidth(13.0);
    s14 = ScreenUtil().setWidth(14.0);
    s15 = ScreenUtil().setWidth(15.0);
    s16 = ScreenUtil().setWidth(16.0);
    s17 = ScreenUtil().setWidth(17.0);
    s18 = ScreenUtil().setWidth(18.0);
    s19 = ScreenUtil().setWidth(19.0);
    s20 = ScreenUtil().setWidth(20.0);
    s21 = ScreenUtil().setWidth(21.0);
    s22 = ScreenUtil().setWidth(22.0);
    s23 = ScreenUtil().setWidth(23.0);
    s24 = ScreenUtil().setWidth(24.0);
    s25 = ScreenUtil().setWidth(25.0);
    s26 = ScreenUtil().setWidth(26.0);
    s28 = ScreenUtil().setWidth(28.0);
    s30 = ScreenUtil().setWidth(30.0);
    s32 = ScreenUtil().setWidth(32.0);
    s40 = ScreenUtil().setWidth(40.0);
    s35 = ScreenUtil().setWidth(35.0);
    s36 = ScreenUtil().setWidth(36.0);
    s38 = ScreenUtil().setWidth(38.0);
    s40 = ScreenUtil().setWidth(40.0);
    s44 = ScreenUtil().setWidth(44.0);
    s45 = ScreenUtil().setWidth(45.0);
    s47 = ScreenUtil().setWidth(47.0);
    s50 = ScreenUtil().setWidth(50.0);
    s55 = ScreenUtil().setWidth(55.0);
    s48 = ScreenUtil().setWidth(48.0);
    s56 = ScreenUtil().setWidth(56.0);
    s60 = ScreenUtil().setWidth(60.0);
    s64 = ScreenUtil().setWidth(64.0);
    s70 = ScreenUtil().setWidth(70.0);
    s72 = ScreenUtil().setWidth(72.0);
    s80 = ScreenUtil().setWidth(80.0);
    s85 = ScreenUtil().setWidth(80.0);
    s88 = ScreenUtil().setWidth(88.0);
    s100 = ScreenUtil().setWidth(100.0);
    s105 = ScreenUtil().setWidth(105.0);
    s110 = ScreenUtil().setWidth(110.0);
    s120 = ScreenUtil().setWidth(120.0);
    s128 = ScreenUtil().setWidth(128.0);
    s130 = ScreenUtil().setWidth(130.0);
    s138 = ScreenUtil().setWidth(138.0);
    s140 = ScreenUtil().setWidth(140.0);
    s150 = ScreenUtil().setWidth(150.0);
    s160 = ScreenUtil().setWidth(160.0);
    s164 = ScreenUtil().setWidth(164.0);
    s180 = ScreenUtil().setWidth(180.0);
    s200 = ScreenUtil().setWidth(200.0);
    s205 = ScreenUtil().setWidth(205.0);
    s210 = ScreenUtil().setWidth(210.0);
    s220 = ScreenUtil().setWidth(220.0);
    s240 = ScreenUtil().setWidth(240.0);
    s250 = ScreenUtil().setWidth(250.0);
    s260 = ScreenUtil().setWidth(260.0);
    s275 = ScreenUtil().setWidth(275.0);
    s280 = ScreenUtil().setWidth(280.0);
    s290 = ScreenUtil().setWidth(290.0);
    s300 = ScreenUtil().setWidth(300.0);
    s310 = ScreenUtil().setWidth(310.0);
    s320 = ScreenUtil().setWidth(320.0);
    s330 = ScreenUtil().setWidth(330.0);
    s340 = ScreenUtil().setWidth(340.0);
    s350 = ScreenUtil().setWidth(350.0);
    s360 = ScreenUtil().setWidth(360.0);
    s380 = ScreenUtil().setWidth(380.0);
    s328 = ScreenUtil().setWidth(328.0);
    s400 = ScreenUtil().setWidth(400.0);
    s420 = ScreenUtil().setWidth(420.0);
    s430 = ScreenUtil().setWidth(430.0);
    s450 = ScreenUtil().setWidth(450.0);
    s470 = ScreenUtil().setWidth(470.0);
    s490 = ScreenUtil().setWidth(490.0);
    s500 = ScreenUtil().setWidth(500.0);
    s520 = ScreenUtil().setWidth(520.0);
    s530 = ScreenUtil().setWidth(530.0);
    s550 = ScreenUtil().setWidth(550.0);
    s600 = ScreenUtil().setWidth(600.0);
    s965 = ScreenUtil().setWidth(965.0);
    s1000 = ScreenUtil().setWidth(1000.0);
    /*EdgeInsets*/

    spacingAllDefault = EdgeInsets.all(s8);
    spacingAllSmall = EdgeInsets.all(s12);

    /*Image Dimensions*/

    defaultIconSize = ScreenUtil().setWidth(80.0);
    defaultImageHeight = ScreenUtil().setHeight(120.0);
    snackBarHeight = ScreenUtil().setHeight(50.0);
    texIconSize = ScreenUtil().setWidth(30.0);

    /*Default Height&Width*/
    defaultIndicatorHeight = ScreenUtil().setHeight(5.0);
    defaultIndicatorWidth = screenWidthFourth;
  }
}

class FontSize {
  static double s7 = 7.0;
  static double s8 = 8.0;
  static double s9 = 9.0;
  static double s10 = 10.0;
  static double s11 = 11.0;
  static double s12 = 12.0;
  static double s13 = 13.0;
  static double s14 = 14.0;
  static double s15 = 15.0;
  static double s16 = 16.0;
  static double s17 = 17.0;
  static double s18 = 18.0;
  static double s19 = 19.0;
  static double s20 = 20.0;
  static double s21 = 21.0;
  static double s22 = 22.0;
  static double s23 = 23.0;
  static double s24 = 24.0;
  static double s25 = 25.0;
  static double s26 = 26.0;
  static double s27 = 27.0;
  static double s28 = 28.0;
  static double s29 = 29.0;
  static double s30 = 30.0;
  static double s32 = 32.0;
  static double s34 = 34.0;
  static double s36 = 36.0;
  static double s40 = 40.0;
  static double s42 = 42.0;
  static double s48 = 48.0;
  static double s52 = 52.0;

  static setDefaultFontSize() {
    s7 = 7.0;
    s8 = 8.0;
    s9 = 9.0;
    s10 = 10.0;
    s11 = 11.0;
    s12 = 12.0;
    s13 = 13.0;
    s14 = 14.0;
    s15 = 15.0;
    s16 = 16.0;
    s17 = 17.0;
    s18 = 18.0;
    s19 = 19.0;
    s20 = 20.0;
    s21 = 21.0;
    s22 = 22.0;
    s23 = 23.0;
    s24 = 24.0;
    s25 = 25.0;
    s26 = 26.0;
    s27 = 27.0;
    s28 = 28.0;
    s29 = 29.0;
    s30 = 30.0;
    s32 = 32.0;
    s36 = 36.0;
    s40 = 40.0;
    s42 = 42.0;
    s48 = 48.0;
    s52 = 52.0;
  }

  static setScreenAwareFontSize() {
    s7 = ScreenUtil().setSp(7.0);
    s8 = ScreenUtil().setSp(8.0);
    s9 = ScreenUtil().setSp(9.0);
    s10 = ScreenUtil().setSp(10.0);
    s11 = ScreenUtil().setSp(11.0);
    s12 = ScreenUtil().setSp(12.0);
    s13 = ScreenUtil().setSp(13.0);
    s14 = ScreenUtil().setSp(14.0);
    s15 = ScreenUtil().setSp(15.0);
    s16 = ScreenUtil().setSp(16.0);
    s17 = ScreenUtil().setSp(17.0);
    s18 = ScreenUtil().setSp(18.0);
    s19 = ScreenUtil().setSp(19.0);
    s20 = ScreenUtil().setSp(20.0);
    s21 = ScreenUtil().setSp(21.0);
    s22 = ScreenUtil().setSp(22.0);
    s23 = ScreenUtil().setSp(23.0);
    s24 = ScreenUtil().setSp(24.0);
    s25 = ScreenUtil().setSp(25.0);
    s26 = ScreenUtil().setSp(26.0);
    s27 = ScreenUtil().setSp(27.0);
    s28 = ScreenUtil().setSp(28.0);
    s29 = ScreenUtil().setSp(29.0);
    s30 = ScreenUtil().setSp(30.0);
    s32 = ScreenUtil().setSp(32.0);
    s34 = ScreenUtil().setSp(34.0);
    s36 = ScreenUtil().setSp(36.0);
    s40 = ScreenUtil().setSp(40.0);
    s42 = ScreenUtil().setSp(42.0);
    s48 = ScreenUtil().setSp(48.0);
    s52 = ScreenUtil().setSp(52.0);
  }
}
