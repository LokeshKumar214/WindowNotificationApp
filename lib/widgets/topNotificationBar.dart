import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:test_project/ResourcesFile/app_colors.dart';
import 'package:test_project/ResourcesFile/app_dimensions.dart';
import 'package:test_project/ResourcesFile/app_fonts.dart';
import 'package:test_project/ResourcesFile/app_images.dart';
import 'package:test_project/providers/alert_provider.dart';

class AlertTopBar extends StatelessWidget {
  Logger _logger = Logger();
  int preDefinedContainer = 14;
  @override
  Widget build(BuildContext context) {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, _) {
        int currentIndex = 1;
        currentIndex += alertProvider.currentAlerts.indexWhere(
          (alert) => alert.key == alertProvider.selectedAlert?.key,
        );
        int totalAlerts = alertProvider.currentAlerts.length;
        int remainingAlerts = totalAlerts - preDefinedContainer;

        return Container(
          height: 48,
          width: double.maxFinite,
          padding: EdgeInsets.only(right: 8, left: 12),
          decoration: BoxDecoration(color: AppColors.grey12),
          child: Row(
            children: [
              Expanded(
                child: listAlertNotification(context,alertProvider)
              ),
              Visibility(
                visible: remainingAlerts > 0,
                child: Container(
                  // color: Colors.amber,
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    left: 8,
                    right: 16,
                  ),
                  child: Text(
                    "+$remainingAlerts",
                    style: TextStyle(
                      color: AppColors.whiteTextF,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.notoSans,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  alertProvider.decrementCurrAlertListIndex();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 1.0, color: AppColors.grey_10),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 15,
                    right: 16,
                  ),
                  child: SvgPicture.asset(AppImages.leftArrow),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 1.0, color: AppColors.grey_10),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                  left: 15,
                  right: 16,
                ),
                child: Text(
                  "$currentIndex / $totalAlerts",
                  style: TextStyle(
                    color: AppColors.whiteTextF,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.notoSans,
                    fontSize: 18,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  alertProvider.incrementCurrAlertListIndex();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 1.0, color: AppColors.grey_10),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 15,
                    right: 8,
                  ),
                  child: SvgPicture.asset(AppImages.rightArrow),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget listAlertNotification(BuildContext context,AlertProvider alertProvider) {
    return 
    ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
      scrollbars: false,
      physics: BouncingScrollPhysics(
        decelerationRate: ScrollDecelerationRate.fast
      ),
      dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.trackpad,
      },
    ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: alertProvider.currentAlerts.length,
        separatorBuilder: (_, __) => SizedBox(width: 0),
        itemBuilder: (context, index) {
          final alert = alertProvider.currentAlerts[index];
          final isSelected = alertProvider.selectedAlert?.key == alert.key;
          debugPrint('From---listAlertNotification  ${alertProvider.selectedAlert?.key}:   ${alert.key}');
          _logger.i("silence alert : ${alertProvider.getSilenceAlertList}");
          return GestureDetector(
            onTap: () {
              if (alertProvider.selectedAlert?.key == alert.key) {
                return; // do nothing → no flicker
              }
              alertProvider.selectAlert(alert);
            },
            child: Container(
              height: 24,
              width: 24,
              margin: EdgeInsets.symmetric(
                horizontal: 4,
                vertical: AppDimensions.paddingVertical12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary9 : AppColors.grey_5,
                border: Border.all(
                  color: isSelected ? Colors.white : AppColors.grey7,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primaryA_9
                        : AppColors.blackA_6.withOpacity(0.11),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class _HorizontalScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}