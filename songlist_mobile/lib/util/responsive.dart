import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  //These are the threshold sizes for each type of device
  static const int tabletSize = 800; //anything smaller is considered mobile
  //anything in between is considered tabled
  static const int desktopSize = 1100; //anything bigger is considered desktop

  const Responsive({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  }) : super(key: key);

  //Distribute table cell widths evenly based on the screen width and number of cells
  static double getTableCellWidth(int numberOfCells, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //Leave 10% space for some padding
    return (screenWidth / numberOfCells) * 0.9;
  }

  //Adjust dropdown search height according to the device height
  static double getDropdownSearchHeight(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * 0.5; // 50% of the screen height
  }

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletSize;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < desktopSize &&
      MediaQuery.of(context).size.width >= tabletSize;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopSize;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= desktopSize) {
      return desktop;
      // ignore: unnecessary_null_comparison
    } else if (_size.width >= tabletSize && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
