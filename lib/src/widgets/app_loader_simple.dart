import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_const.dart';
import '../../utils/app_colors.dart';

class AppLoader extends StatelessWidget {
  final Color? color;
  final DownloadProgress? downloadProgress;
  const AppLoader({Key? key, this.color = primary, this.downloadProgress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: isMobile
            ? CupertinoActivityIndicator(
                radius: 12,
                color: color,
              )
            : CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
                value: downloadProgress?.progress,
              ),
      ),
    );
  }
}
