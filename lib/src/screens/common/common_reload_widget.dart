import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';

class CommonReloadWidget extends StatelessWidget {
  final dynamic reload;
  final String? message;
  const CommonReloadWidget(
      {super.key, required this.message, required this.reload});

  @override
  Widget build(BuildContext context) {
    return Center(child: AppText(message ?? "Something went wrong"));
  }
}
