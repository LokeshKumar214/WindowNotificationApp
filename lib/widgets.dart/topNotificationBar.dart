import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:test_project/providers/alert_provider.dart';
import 'package:test_project/resourcesFile.dart/app_dimensions.dart';
import 'package:test_project/resourcesFile.dart/app_colors.dart';
import 'package:test_project/resourcesFile.dart/app_fonts.dart';
import 'package:test_project/resourcesFile.dart/app_images.dart';

class AlertTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, _) {
        int currentIndex = 1;
        currentIndex += alertProvider.currentAlerts.indexWhere(
          (alert) => alert.key == alertProvider.selectedAlert?.key,
        );
        int totalAlerts = alertProvider.currentAlerts.length;
        int remainingAlerts = totalAlerts - 11;

        return Container(
          height: 48,
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: AppColors.grey12),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(child: listAlertNotification(alertProvider)),
              ),
              Visibility(
                visible: totalAlerts > 11,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    "+$remainingAlerts",
                    style: TextStyle(
                      color: AppColors.whiteTextF,
                      fontWeight: FontWeight.bold,
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: SvgPicture.asset(AppImages.leftArrow),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 1.0, color: AppColors.grey_10),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  "$currentIndex / $totalAlerts",
                  style: TextStyle(
                    color: AppColors.whiteTextF,
                    fontWeight: FontWeight.bold,
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: SvgPicture.asset(AppImages.rightArrow),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ListView listAlertNotification(AlertProvider alertProvider) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: alertProvider.currentAlerts.length,
      separatorBuilder: (_, __) => SizedBox(width: 0),
      itemBuilder: (context, index) {
        final alert = alertProvider.currentAlerts[index];
        final isSelected = alertProvider.selectedAlert?.key == alert.key;

        print('KEY----   ${alertProvider.selectedAlert?.key}:   ${alert.key}');

        return GestureDetector(
          onTap: () {
            alertProvider.selectAlert(alert);
          },
          child: Container(
            height: 24,
            width: 24,
            margin: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingVertical8,
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
    );
  }
}
