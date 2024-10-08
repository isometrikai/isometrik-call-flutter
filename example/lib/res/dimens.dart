import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimens {
  const Dimens._();

  /// Get the height with the percent value of the screen height.
  static double percentHeight(double percentValue) => percentValue.sh;

  /// Get the width with the percent value of the screen width.
  static double percentWidth(double percentValue) => percentValue.sw;

  static final double appBarHeight = 56.sp;

  static final double appBarElevation = 8.sp;

  static final double zero = 0.sp;
  static final double one = 1.sp;
  static final double two = 2.sp;
  static final double four = 4.sp;
  static final double five = 5.sp;
  static final double six = 6.sp;

  static final double eight = 8.sp;
  static final double nine = 9.sp;
  static final double ten = 10.sp;
  static final double twelve = 12.sp;

  static final double fifteen = 15.sp;
  static final double sixteen = 16.sp;
  static final double fourteen = 14.sp;
  static final double twenty = 20.sp;
  static final double twentyFour = 24.sp;
  static final double twentyFive = 25.sp;

  static final double thirty = 30.sp;
  static final double thirtyTwo = 32.sp;

  static final double forty = 40.sp;
  static final double fortyFive = 45.sp;
  static final double fifty = 50.sp;
  static final double fiftyFive = 55.sp;
  static final double sixty = 60.sp;
  static final double seventyEight = 78.sp;
  static final double seventy = 70.sp;

  static final double eighty = 80.sp;
  static final double ninty = 90.sp;

  static final double hundred = 100.sp;
  static final double oneHundredTwenty = 120.sp;
  static final double hundredFourty = 140.sp;
  static final double oneHundredFifty = 150.sp;
  static final double oneHundredSeventy = 170.sp;
  static final double twoHundred = 200.sp;
  static final double twoHundredTwenty = 220.sp;
  static final double twoHundredFifty = 250.sp;
  static final double threeHundred = 300.sp;

  static const Widget box0 = SizedBox.shrink();

  static final Widget boxHeight2 = SizedBox(height: two);
  static final Widget boxHeight4 = SizedBox(height: four);
  static final Widget boxHeight5 = SizedBox(height: five);
  static final Widget boxHeight8 = SizedBox(height: eight);
  static final Widget boxHeight10 = SizedBox(height: ten);

  static final Widget boxHeight16 = SizedBox(height: sixteen);
  static final Widget boxHeight20 = SizedBox(height: twenty);
  static final Widget boxHeight24 = SizedBox(height: twentyFour);
  static final Widget boxHeight32 = SizedBox(height: thirtyTwo);
  static final Widget boxHeight50 = SizedBox(height: fifty);

  static final Widget boxWidth2 = SizedBox(width: two);
  static final Widget boxWidth4 = SizedBox(width: four);
  static final Widget boxWidth8 = SizedBox(width: eight);
  static final Widget boxWidth10 = SizedBox(width: ten);
  static final Widget boxWidth12 = SizedBox(width: twelve);
  static final Widget boxWidth16 = SizedBox(width: sixteen);
  static final Widget boxWidth20 = SizedBox(width: twenty);
  static final Widget boxWidth24 = SizedBox(width: twentyFour);
  static final Widget boxWidth32 = SizedBox(width: thirtyTwo);
  static final Widget boxWidth50 = SizedBox(width: fifty);
  static final Widget boxWidth80 = SizedBox(width: eighty);

  static const EdgeInsets edgeInsets0 = EdgeInsets.zero;
  static final EdgeInsets edgeInsets2 = EdgeInsets.all(two);
  static final EdgeInsets edgeInsets4 = EdgeInsets.all(four);
  static final EdgeInsets edgeInsets5 = EdgeInsets.all(five);
  static final EdgeInsets edgeInsets6 = EdgeInsets.all(six);
  static final EdgeInsets edgeInsets8 = EdgeInsets.all(eight);
  static final EdgeInsets edgeInsets10 = EdgeInsets.all(ten);
  static final EdgeInsets edgeInsets12 = EdgeInsets.all(twelve);
  static final EdgeInsets edgeInsets16 = EdgeInsets.all(sixteen);
  static final EdgeInsets edgeInsets20 = EdgeInsets.all(twenty);
  static final EdgeInsets edgeInsets32 = EdgeInsets.all(thirtyTwo);

  static final EdgeInsets edgeInsetsL2 = EdgeInsets.only(left: two);
  static final EdgeInsets edgeInsets0_5_10_5 =
      EdgeInsets.only(bottom: five, top: five, right: ten);
  static final EdgeInsets edgeInsets16_30_16_5 =
      EdgeInsets.only(bottom: five, top: thirty, right: sixteen, left: sixteen);
  static final EdgeInsets edgeInsets16_08_16_0 =
      EdgeInsets.only(bottom: zero, top: sixteen, right: eight, left: sixteen);
  static final EdgeInsets edgeInsets16_0_16_20 =
      EdgeInsets.only(bottom: twenty, top: zero, right: eight, left: sixteen);

  static final EdgeInsets edgeInsetsL4 = EdgeInsets.only(left: four);
  static final EdgeInsets edgeInsetsL5 = EdgeInsets.only(left: five);
  static final EdgeInsets edgeInsetsL10 = EdgeInsets.only(left: ten);
  static final EdgeInsets edgeInsetsL20 = EdgeInsets.only(left: twenty);
  static final EdgeInsets edgeInsetsR4 = EdgeInsets.only(right: four);
  static final EdgeInsets edgeInsetsT8 = EdgeInsets.only(top: eight);
  static final EdgeInsets edgeInsetsT16 = EdgeInsets.only(top: sixteen);
  static final EdgeInsets edgeInsetsT100 = EdgeInsets.only(top: hundred);
  static final EdgeInsets edgeInsetsR10 = EdgeInsets.only(right: ten);
  static final EdgeInsets edgeInsetsB10 = EdgeInsets.only(bottom: ten);
  static final EdgeInsets edgeInsetsB25 = EdgeInsets.only(bottom: twentyFive);
  static final EdgeInsets edgeInsetsB20 = EdgeInsets.only(bottom: twenty);

  static final EdgeInsets edgeInsets2_0 = EdgeInsets.symmetric(horizontal: two);
  static final EdgeInsets edgeInsets4_0 =
      EdgeInsets.symmetric(horizontal: four);
  static final EdgeInsets edgeInsets4_2 =
      EdgeInsets.symmetric(horizontal: four, vertical: two);
  static final EdgeInsets edgeInsets8_0 =
      EdgeInsets.symmetric(horizontal: eight);
  static final EdgeInsets edgeInsets10_0 =
      EdgeInsets.symmetric(horizontal: ten);
  static final EdgeInsets edgeInsets20_0 =
      EdgeInsets.symmetric(horizontal: twenty);
  static final EdgeInsets edgeInsets40_0 =
      EdgeInsets.symmetric(horizontal: forty);

  static final EdgeInsets edgeInsets0_4 = EdgeInsets.symmetric(vertical: four);
  static final EdgeInsets edgeInsets0_8 = EdgeInsets.symmetric(vertical: eight);
  static final EdgeInsets edgeInsets0_10 = EdgeInsets.symmetric(vertical: ten);
  static final EdgeInsets edgeInsets0_16 =
      EdgeInsets.symmetric(vertical: sixteen);
  static final EdgeInsets edgeInsets0_25 =
      EdgeInsets.symmetric(vertical: twentyFive);

  static final EdgeInsets edgeInsets4_8 =
      EdgeInsets.symmetric(horizontal: four, vertical: eight);
  static final EdgeInsets edgeInsets6_2 =
      EdgeInsets.symmetric(horizontal: six, vertical: two);
  static final EdgeInsets edgeInsets8_4 =
      EdgeInsets.symmetric(horizontal: eight, vertical: four);
  static final EdgeInsets edgeInsets12_4 =
      EdgeInsets.symmetric(horizontal: twelve, vertical: four);
  static final EdgeInsets edgeInsets16_0 =
      EdgeInsets.symmetric(horizontal: sixteen);
  static final EdgeInsets edgeInsets16_8 =
      EdgeInsets.symmetric(horizontal: sixteen, vertical: eight);
  static final EdgeInsets edgeInsets16_10 =
      EdgeInsets.symmetric(horizontal: sixteen, vertical: ten);
}
