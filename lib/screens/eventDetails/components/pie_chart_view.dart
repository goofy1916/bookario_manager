// import 'package:bookario/components/size_config.dart';
// import 'package:bookario/screens/club_UI_screens/details/components/select_date.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';

// class ChartView extends StatefulWidget {
//   const ChartView({
//     Key? key,
//     this.maleStag,
//     this.femaleStag,
//     this.couples,
//   }) : super(key: key);

//   final double maleStag;
//   final double femaleStag;
//   final double couples;

//   @override
//   _ChartViewState createState() => _ChartViewState();
// }

// class _ChartViewState extends State<ChartView> {
//   List<Color> colorList = [
//     Colors.red,
//     Colors.green,
//     Colors.blue,
//   ];
//   int key = 0;
//   Map<String, double> dataMap;

//   @override
//   void initState() {
//     setState(() {
//       dataMap = {
//         "Male": widget.maleStag,
//         "Female": widget.femaleStag,
//         "Couples": widget.couples,
//       };
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chart = PieChart(
//       key: ValueKey(key),
//       dataMap: dataMap,
//       animationDuration: Duration(seconds: 1),
//       chartLegendSpacing: 32,
//       chartRadius: SizeConfig.screenWidth / 3.2 > 300
//           ? 300
//           : SizeConfig.screenWidth / 3.2,
//       colorList: colorList,
//       chartType: ChartType.ring,
//       legendOptions: LegendOptions(
//         legendPosition: LegendPosition.right,
//         legendTextStyle: TextStyle(
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       chartValuesOptions: ChartValuesOptions(
//         showChartValueBackground: true,
//       ),
//       ringStrokeWidth: 48,
//     );
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: SizedBox(
//         child: LayoutBuilder(
//           builder: (_, constraints) {
//             if (constraints.maxWidth >= 600) {
//               return Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Flexible(
//                     flex: 2,
//                     fit: FlexFit.tight,
//                     child: chart,
//                   ),
//                   Flexible(
//                     child: SelectDate(),
//                   )
//                 ],
//               );
//             } else {
//               return Column(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.symmetric(
//                       vertical: 32,
//                     ),
//                     child: chart,
//                   ),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
