import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../utils/app_colors.dart';
import 'package:bhawsar_chemical/data/models/feedback_model/attachment.dart'
    as feedback_attachment;
import 'dart:io' as platform;

import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_loader_simple.dart';
import '../../../widgets/app_spacer.dart';
import '../../../widgets/app_text.dart';

class CommentAttachmentWidget extends StatelessWidget {
  final bool commentedByMe;
  final List<feedback_attachment.Attachment?> attachments;
  const CommentAttachmentWidget(
      {super.key, required this.attachments, required this.commentedByMe});

  @override
  Widget build(BuildContext context) {
    final CarouselSliderController controller = CarouselSliderController();
    int current = 0;
    return Flexible(
      child: GestureDetector(
        onTap: () async {
          await appInfoDialog(
            context,
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return SizedBox(
                      height: 50.h,
                      width: 100.w,
                      child: Column(
                        children: <Widget>[
                          CarouselSlider(
                            items: attachments
                                .map(
                                  (item) => item!.id == -1
                                      ? Image.file(
                                          platform.File((item.url).toString()),
                                          semanticLabel: "image",
                                          errorBuilder: (context, url, error) =>
                                              const Icon(
                                            Icons.error_outline,
                                            color: primary,
                                          ),
                                          fit: BoxFit.fill,
                                        )
                                      : CachedNetworkImage(
                                          httpHeaders: {
                                            "Referer":
                                                "https://mobile.bhawsarayurveda.in/"
                                          },
                                          imageUrl: item.url!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: 50.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                                filterQuality:
                                                    FilterQuality.low,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const AppLoader(),
                                          errorWidget: (context, url, error) =>
                                              Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                                'assets/ic_launcher.png'),
                                          ),
                                        ),
                                )
                                .toList(),
                            carouselController: controller,
                            options: CarouselOptions(
                                viewportFraction: 1.0,
                                aspectRatio: 13 / 16,
                                enlargeCenterPage: false,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    current = index;
                                  });
                                }),
                          ),
                          const AppSpacerHeight(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: attachments.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    controller.animateToPage(entry.key),
                                child: Container(
                                  width: current == entry.key ? 5.w : 3.w,
                                  height: 5,
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                      color: primary.withOpacity(
                                          current == entry.key ? 1 : 0.4)),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            isDismissible: true,
            isShowButton: false,
          );
        },
        child: Stack(children: [
          Container(
            margin: EdgeInsets.only(
              top: 6.sp,
            ),
            constraints: BoxConstraints.tightFor(width: 45.sp, height: 43.sp),
            decoration: BoxDecoration(
              border: Border.all(color: greyLight, width: 1),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(commentedByMe ? 0.0 : 10.0),
                topLeft: Radius.circular(commentedByMe ? 10.0 : 0.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(commentedByMe ? 0.0 : 10.0),
                topLeft: Radius.circular(commentedByMe ? 10.0 : 0.0),
                bottomRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
              ),
              child: attachments[0]!.id == -1
                  ? Image.file(
                      platform.File((attachments[0]!.url).toString()),
                      semanticLabel: "image",
                      errorBuilder: (context, url, error) => const Icon(
                        Icons.error_outline,
                        color: primary,
                      ),
                      fit: BoxFit.fill,
                    )
                  : CachedNetworkImage(
                      httpHeaders: {
                        "Referer": "https://mobile.bhawsarayurveda.in/"
                      },
                      imageUrl: attachments[0]!.url!,
                      placeholder: (context, url) => const AppLoader(),
                      errorWidget: (context, url, error) => Container(
                        width: 45.sp,
                        height: 43.sp,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.error_outline,
                          color: primary,
                        ),
                      ),
                      fit: BoxFit.fitWidth,
                      filterQuality: FilterQuality.medium,
                    ),
            ),
          ),
          attachments.length > 1
              ? Container(
                  width: 45.sp,
                  height: 43.sp,
                  decoration: BoxDecoration(
                    color: black.withOpacity(0.4),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(commentedByMe ? 0.0 : 10.0),
                      topLeft: Radius.circular(commentedByMe ? 10.0 : 0.0),
                      bottomRight: const Radius.circular(10.0),
                      bottomLeft: const Radius.circular(10.0),
                    ),
                  ),
                  margin: EdgeInsets.only(
                    top: 6.sp,
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    '+ ${(attachments.length - 1)}',
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const SizedBox.shrink(),
        ]),
      ),
    );
  }
}
