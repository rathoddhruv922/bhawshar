// import 'package:bhawsar_chemical/data/models/medical_model/item.dart' as medical;
// import 'package:bhawsar_chemical/src/screens/common/common_order_type_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
//
// import '../../../../constants/app_const.dart';
// import '../../../../generated/l10n.dart';
// import '../../../../helper/app_helper.dart';
// import '../../../../main.dart';
// import '../../../../utils/app_colors.dart';
// import '../../../router/route_list.dart';
// import '../../../widgets/app_bar.dart';
// import '../../../widgets/app_dialog.dart';
// import '../../../widgets/app_text.dart';
// import '../../common/common_medical_card_widget.dart';
//
// class AddOrderScreen extends StatefulWidget {
//   const AddOrderScreen({super.key, required this.medicalInfo});
//
//   final medical.Item medicalInfo;
//
//   @override
//   State<AddOrderScreen> createState() => _AddOrderScreenState();
// }
//
// class _AddOrderScreenState extends State<AddOrderScreen> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   String? orderType = 'At Shop';
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: true,
//       onPopInvoked: (v) async {
//         await appAlertDialog(
//             context,
//             AppText(
//               S.of(context).confirmation,
//               textAlign: TextAlign.center,
//               fontSize: 17,
//             ), () {
//           Navigator.of(context).pop();
//           Navigator.of(context).pop();
//           return true;
//         }, () {
//           Navigator.of(context).pop();
//           return false;
//         });
//       },
//       child: Scaffold(
//         key: scaffoldKey,
//         backgroundColor: white,
//         appBar: CustomAppBar(
//           AppText(
//             localization.order_add,
//             color: primary,
//             fontWeight: FontWeight.bold,
//           ),
//           leading: IconButton(
//             onPressed: () async {
//               await appAlertDialog(
//                   context,
//                   AppText(
//                     S.of(context).confirmation,
//                     textAlign: TextAlign.center,
//                     fontSize: 17,
//                   ), () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//               }, () {
//                 Navigator.of(context).pop();
//               });
//             },
//             icon: getBackArrow(),
//             color: primary,
//           ),
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.zero,
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 100.h <= 667 ? 17.h : 16.h,
//                   child: Stack(
//                     children: [
//                       Positioned(child: Container(height: 8.h, color: secondary)),
//                       Positioned(child: GlobalMedicalCard(medicalInfo: widget.medicalInfo)),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: paddingDefault, horizontal: paddingDefault + 5),
//                   child: StatefulBuilder(
//                     builder: (BuildContext context, StateSetter setState) {
//                       return OrderTypeWidget(
//                         type: orderType,
//                         onChanged: ((value) {
//                           setState(() {
//                             orderType = value;
//                           });
//                         }),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 16, right: 16, bottom: paddingDefault),
//                   child: AppText(
//                     localization.order_type,
//                     color: textBlack,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 Card(
//                   margin: EdgeInsets.only(left: 16, right: 16, bottom: paddingDefault),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.symmetric(horizontal: paddingLarge),
//                     tileColor: secondary,
//                     dense: true,
//                     title: AppText(
//                       localization.productive,
//                       color: textBlack,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     onTap: () {
//                       navigationKey.currentState!.pushNamed(
//                         RouteList.productive,
//                         arguments: {
//                           'medicalInfo': widget.medicalInfo,
//                           'orderType': orderType,
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 Card(
//                   margin: EdgeInsets.only(left: 16, right: 16, bottom: paddingDefault),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.symmetric(horizontal: paddingLarge),
//                     tileColor: secondary,
//                     dense: true,
//                     title: AppText(
//                       localization.non_productive_call,
//                       color: textBlack,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     onTap: () {
//                       navigationKey.currentState!.pushNamed(
//                         RouteList.nonProductive,
//                         arguments: {
//                           'medicalInfo': widget.medicalInfo,
//                           'orderType': orderType,
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
