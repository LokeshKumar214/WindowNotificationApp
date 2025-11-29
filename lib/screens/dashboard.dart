import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:test_project/models/alert.dart';
import 'package:test_project/providers/alert_provider.dart';
import 'package:test_project/resourcesFile.dart/app_colors.dart';
import 'package:test_project/resourcesFile.dart/app_fonts.dart';
import 'package:test_project/resourcesFile.dart/app_strings.dart';
import 'package:test_project/resourcesFile.dart/app_dimensions.dart';
import 'package:test_project/resourcesFile.dart/app_images.dart';
import 'package:test_project/services/logFile.dart';
import 'package:test_project/widgets.dart/topNotificationBar.dart';

class DashboardNotification extends StatelessWidget {
  DashboardNotification({super.key});

  bool isFlagImageActive = false;

  void logFileWrite(String message) async {
    await LogService.write(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<AlertProvider>(
        builder: (context, alertProvider, _) {
          final selectedAlert = alertProvider.selectedAlert;
          print("selectedAlert: $selectedAlert");
          logFileWrite("DashboardNotification screen: ----------->>>");
          logFileWrite("selectedAlert : $selectedAlert");

          // If no alert is selected, show empty state
          if (selectedAlert == null) {
            return Center(
              child: Text(
                'No ',
                style: TextStyle(
                  fontSize: AppDimensions.fontSize32,
                  color: AppColors.labelTextColor,
                ),
              ),
            );
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AlertTopBar(),
                topRedBanner(alert: selectedAlert),
                MiddleSection(alert: selectedAlert),
                alertProvider.getFlagImageIsActive
                    ? FlagImageContainer()
                    : buttonSection(alert: selectedAlert),
              ],
            ),
          );
        },
      ),
    );
  }
}

class buttonSection extends StatelessWidget {
  final Alert alert;

  const buttonSection({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: AppColors.grey_4,
        border: Border(top: BorderSide(color: AppColors.grey_6, width: 1.5)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingVertical8,
        horizontal: AppDimensions.paddingHorizontal16,
      ),
      child: Container(
        padding: EdgeInsets.only(top: 2.5, bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            bottomButton(AppStrings.flagImageButton, alert),
            bottomButton(AppStrings.silenceAlertButton, alert),
            bottomButton(AppStrings.dismissButton, alert),
          ],
        ),
      ),
    );
  }

  Consumer<AlertProvider> bottomButton(String buttonName, Alert alert) {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, _) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius4),
            color: AppColors.grey_1,
            border: Border.all(width: 1.0, color: AppColors.grey_6),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey_6,
                spreadRadius: 0,
                blurRadius: 1.3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (buttonName == AppStrings.flagImageButton) {
                debugPrint("flagged imaged pressed");
                alertProvider.setFlagImageValue(true);
              } else if (buttonName == AppStrings.dismissButton) {
                alertProvider.dismissSelectedAlert1();
              } else {
                debugPrint("Silence Alert button pressed-->");
                alertProvider.doSilenceAlert();
              }
            },
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border(bottom: BorderSide(color: AppColors.grey_6)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              width: AppDimensions.paddingBottom1,
                              color: AppColors.primary_3,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          buttonName == AppStrings.silenceAlertButton
                              ? AppImages.silenceAlertIcon
                              : buttonName == AppStrings.flagImageButton
                              ? AppImages.flagIcon
                              : AppImages.closeIcon,
                          fit: BoxFit.contain,

                          colorFilter: const ColorFilter.mode(
                            AppColors.grey_9,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingHorizontal53,
                        ),
                        child: Text(
                          buttonName,

                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.grey_9,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.notoSans,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MiddleSection extends StatelessWidget {
  final Alert alert;

  const MiddleSection({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.middleSectionBackground),
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(AppDimensions.paddingAll8),
              child: Row(
                children: [
                  // Display actual alert image
                  SizedBox(
                    height: AppDimensions.imageHeight190,
                    width: AppDimensions.imageWidth284,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: alert.imageBytes.isNotEmpty
                          ? Image.memory(
                              alert.imageBytes,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    AppStrings.imagePlaceholder,
                                    style: TextStyle(
                                      color: AppColors.whiteText,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                AppStrings.imagePlaceholder,
                                style: TextStyle(color: AppColors.whiteText),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.sizedBoxWidth16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        cameraFieldContainer(alert.camName),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: routeFieldContainer(alert.roadName),
                            ),
                            kmPostFieldContainer(alert.alertType),
                          ],
                        ),
                        whenFieldContainer(alert.formattedDateTime),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container cameraFieldContainer(String cameraName) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHorizontal16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.grey_6,
            width: AppDimensions.borderWidth1_9,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.paddingVertical10),
          Text(
            AppStrings.cameraNameLabel,
            style: TextStyle(
              color: AppColors.grey_9,
              fontSize: AppDimensions.fontSize12,
              fontFamily: AppFonts.notoSans,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: AppDimensions.paddingVertical5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  cameraName,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey_11,
                    fontFamily: AppFonts.notoSans,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SvgPicture.asset(AppImages.externalLink),
            ],
          ),
          SizedBox(height: AppDimensions.paddingVertical10),
        ],
      ),
    );
  }

  Container routeFieldContainer(String roadName) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHorizontal16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.grey_6,
            width: AppDimensions.borderWidth1_9,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimensions.paddingVertical10),
              Text(
                AppStrings.routeLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey_9,
                  fontFamily: AppFonts.notoSans,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppDimensions.paddingVertical5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    roadName,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey_11,
                      fontFamily: AppFonts.notoSans,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingVertical10),
            ],
          ),
        ],
      ),
    );
  }

  Container kmPostFieldContainer(String alertType) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHorizontal16,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.fieldBorderColor,
            width: AppDimensions.borderWidth1_9,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimensions.paddingVertical10),
              Text(
                AppStrings.kmPostLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey_9,
                  fontFamily: AppFonts.notoSans,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppDimensions.paddingVertical5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "17.9",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey_11,
                            fontFamily: AppFonts.notoSans,
                            fontWeight: FontWeight.w700, // slightly bolder
                          ),
                        ),
                        TextSpan(
                          text: " KM",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.grey_11.withOpacity(0.7),
                            fontFamily: AppFonts.notoSans,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   "17.9KM",
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: AppColors.grey_11,
                  //     fontFamily: AppFonts.notoSans,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingVertical10),
            ],
          ),
        ],
      ),
    );
  }

  Container whenFieldContainer(String dateTime) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingHorizontal16,
      ),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimensions.paddingVertical10),
          Text(
            AppStrings.whenLabel,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey_9,
              fontFamily: AppFonts.notoSans,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppDimensions.paddingVertical5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateTime,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey_11,
                  fontFamily: AppFonts.notoSans,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class topRedBanner extends StatelessWidget {
  final dynamic alert;

  const topRedBanner({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    // Calculate time difference
    final now = DateTime.now();
    print("Now: $now");
    final detectionTime = alert.detectionDateTime;
    print("detectionTime: $detectionTime");

    final difference = now.difference(detectionTime);
    print("difference: $difference");

    String timeAgo;
    if (difference.inMinutes < 1) {
      timeAgo = "Just now";
    } else if (difference.inMinutes < 60) {
      timeAgo = "${difference.inMinutes}分前";
    } else if (difference.inHours < 24) {
      timeAgo = "${difference.inHours}時間前";
    } else {
      timeAgo = "${difference.inDays}日前";
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.borderRedBanner,
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: AppColors.borderRedBanner.withOpacity(0.4),
          ),
        ),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              AppStrings.detecting,
              style: TextStyle(
                color: AppColors.whiteText,
                fontSize: AppDimensions.fontSize32,
                fontFamily: AppFonts.notoSans,
                fontWeight: FontWeight.w600,
                shadows: [
                  BoxShadow(
                    color: AppColors.whiteShadow,
                    offset: Offset(
                      AppDimensions.shadowOffsetX,
                      AppDimensions.shadowOffsetY,
                    ),
                    blurRadius: AppDimensions.shadowBlurRadius,
                    spreadRadius: AppDimensions.shadowSpreadRadius,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              timeAgo,
              style: TextStyle(
                color: AppColors.whiteShadow,
                fontSize: 14,
                fontFamily: AppFonts.notoSans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlagImageContainer extends StatefulWidget {
  const FlagImageContainer({super.key});

  @override
  State<FlagImageContainer> createState() => _flagImageContainerState();
}

class _flagImageContainerState extends State<FlagImageContainer> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    Provider.of<AlertProvider>(context, listen: false).fetchFlagReasons();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, _) {
        final items = alertProvider.flagReasons; // <-- Fetched from API
        final isLoading = alertProvider.isFlagReasonsLoading;

        return Container(
          margin: const EdgeInsets.only(bottom: 1),
          decoration: BoxDecoration(
            color: AppColors.grey_4,
            border: Border(top: BorderSide(color: AppColors.grey_6, width: 1)),
          ),

          padding: EdgeInsets.symmetric(
            vertical: 7.5,
            horizontal: AppDimensions.paddingHorizontal16,
          ),
          child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ------------------ DROPDOWN ----------------------
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadius4,
                      ),
                      color: AppColors.grey_1,
                      border: Border.all(width: 1.0, color: AppColors.grey_6),
                    ),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 7,
                    ),
                    child: isLoading
                        ? const Center(
                            child: Text(
                              "Loading...",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey_10,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selected,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.expand_more,
                                size: 22,
                                color: Color(0xFF9AA6B8),
                              ),

                              hint: const Text(
                                "Choose a reason for flagging...",
                                style: TextStyle(
                                  color: AppColors.grey_10,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                              ),

                              items: items.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.grey_10,
                                    ),
                                  ),
                                );
                              }).toList(),

                              onChanged: (value) {
                                setState(() => _selected = value);
                              },
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // ------------------ CANCEL BUTTON ----------------------
                InkWell(
                  onTap: () => alertProvider.setFlagImageValue(false),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadius4,
                      ),
                      color: AppColors.grey_1,
                      border: Border.all(width: 1.0, color: AppColors.grey_6),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey_6,
                          spreadRadius: 0,
                          blurRadius: 1.3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border(
                          bottom: BorderSide(color: AppColors.grey_6),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: AppDimensions.paddingHorizontal35,
                        ),
                        child: Text(
                          AppStrings.cancel,
                          style: TextStyle(
                            color: AppColors.grey_9,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.notoSans,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // ------------------ CONFIRM BUTTON ----------------------
                InkWell(
                  onTap: () {
                    if (_selected != null && _selected!.isNotEmpty) {
                      alertProvider.submitFlagReason(_selected!);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: AppColors.primary9),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.borderRadius4,
                      ),
                      color: AppColors.primary9,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey7,
                          spreadRadius: 0.0,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border(
                              bottom: BorderSide(color: AppColors.primary9),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 32,
                                width: 30,
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      width: AppDimensions.paddingBottom1,
                                      color: AppColors.primary_3,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  AppImages.flagIcon,
                                  fit: BoxFit.contain,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.white12,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 25.5,
                                ),
                                child: Text(
                                  AppStrings.confirm,
                                  style: TextStyle(
                                    color: AppColors.white12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppFonts.notoSans,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
